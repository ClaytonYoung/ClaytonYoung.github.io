metacog\_01\_clean-merge

Clayton

9/15/2021

timestamp for knit

``` r
Sys.time()
```

    ## [1] "2022-01-17 20:42:20 PST"

Set up directories and load required packages.

Note-you will need to install JAGS to get Fleming’s code to work. It’s
required for rjags package
[JAGS](https://sourceforge.net/projects/mcmc-jags/)

``` r
# setup datafolder target
if (Sys.info()["sysname"] == "Windows"){
  repofolder <- paste("C:/Users/", Sys.getenv("USERNAME"), "/decisionlab/AgingCog/analysis/Metacog", 
                      sep = "")
  datafolder <- "R:/groups/chiong/aging-and-cognition/tasks/metacog/data"
  rdrivepath <- "R:/"
} else if (Sys.info()["sysname"] == "Darwin"){ # not sure why MacOS is "Darwin" but it is...
  repofolder <- "~/decisionlab/AgingCog/analysis/Metacog"
  datafolder <- "/Volumes/macdata/groups/chiong/aging-and-cognition/tasks/metacog/data/"
  rdrivepath <- "/Volumes/macdata/"
} # probably good to add another condition for Unix, later on...

library(knitr) # knitr is part of R Markdown
library(tidyverse)
```

    ## ── Attaching packages ─────────────────────────────────────── tidyverse 1.3.1 ──

    ## ✓ ggplot2 3.3.5     ✓ purrr   0.3.4
    ## ✓ tibble  3.1.5     ✓ dplyr   1.0.7
    ## ✓ tidyr   1.1.4     ✓ stringr 1.4.0
    ## ✓ readr   2.0.2     ✓ forcats 0.5.1

    ## ── Conflicts ────────────────────────────────────────── tidyverse_conflicts() ──
    ## x dplyr::filter() masks stats::filter()
    ## x dplyr::lag()    masks stats::lag()

``` r
library(readxl) # readxl is part of tidyverse, but is not "core tidyverse"
library(lubridate)
```

    ## 
    ## Attaching package: 'lubridate'

    ## The following objects are masked from 'package:base':
    ## 
    ##     date, intersect, setdiff, union

``` r
## Packages from Fleming code----------------------------------------------------------------
library(rjags)
```

    ## Loading required package: coda

    ## Linked to JAGS 4.3.0

    ## Loaded modules: basemod,bugs

``` r
library(magrittr)
```

    ## 
    ## Attaching package: 'magrittr'

    ## The following object is masked from 'package:purrr':
    ## 
    ##     set_names

    ## The following object is masked from 'package:tidyr':
    ## 
    ##     extract

``` r
library(reshape2)
```

    ## 
    ## Attaching package: 'reshape2'

    ## The following object is masked from 'package:tidyr':
    ## 
    ##     smiths

``` r
library(coda)
library(lattice)
library(broom)
library(ggpubr)
library(ggmcmc)
```

    ## Registered S3 method overwritten by 'GGally':
    ##   method from   
    ##   +.gg   ggplot2

``` r
knitr::opts_chunk$set(echo = TRUE)
knitr::opts_knit$set(root.dir = datafolder)

# comment out (see root.dir above): setwd(datafolder)
```

## Data cleaning

load in qualtrics files

``` r
emometa_b_df = read_csv("Emotion Metacognition B_December 21, 2021_18.20.csv")[-1:-2,]
```

    ## Rows: 75 Columns: 1974

    ## ── Column specification ────────────────────────────────────────────────────────
    ## Delimiter: ","
    ## chr (1974): StartDate, EndDate, Status, IPAddress, Progress, Duration (in se...

    ## 
    ## ℹ Use `spec()` to retrieve the full column specification for this data.
    ## ℹ Specify the column types or set `show_col_types = FALSE` to quiet this message.

``` r
emometa_a_df = read_csv("Emotion Metacognition A_December 21, 2021_18.19.csv")[-1:-2,]
```

    ## Rows: 125 Columns: 1974

    ## ── Column specification ────────────────────────────────────────────────────────
    ## Delimiter: ","
    ## chr (1974): StartDate, EndDate, Status, IPAddress, Progress, Duration (in se...

    ## 
    ## ℹ Use `spec()` to retrieve the full column specification for this data.
    ## ℹ Specify the column types or set `show_col_types = FALSE` to quiet this message.

``` r
memmeta_b_df = read_csv("Memory Metacognition B_December 21, 2021_18.18.csv")[-1:-2,]
```

    ## Rows: 87 Columns: 2469

    ## ── Column specification ────────────────────────────────────────────────────────
    ## Delimiter: ","
    ## chr (2469): StartDate, EndDate, Status, IPAddress, Progress, Duration (in se...

    ## 
    ## ℹ Use `spec()` to retrieve the full column specification for this data.
    ## ℹ Specify the column types or set `show_col_types = FALSE` to quiet this message.

``` r
memmeta_a_df = read_csv("Memory Metacognition A_December 21, 2021_18.13.csv")[-1:-2,]
```

    ## Rows: 92 Columns: 2469

    ## ── Column specification ────────────────────────────────────────────────────────
    ## Delimiter: ","
    ## chr (2469): StartDate, EndDate, Status, IPAddress, Progress, Duration (in se...

    ## 
    ## ℹ Use `spec()` to retrieve the full column specification for this data.
    ## ℹ Specify the column types or set `show_col_types = FALSE` to quiet this message.

``` r
demographics_df = read_xlsx('metacog_demographics.xlsx')
```

``` r
pidn_date_emo_b_df=emometa_b_df%>%
  select(ExternalReference,RecordedDate)

pidn_date_emo_a_df=emometa_a_df%>%
  select(ExternalReference,RecordedDate)%>%
  rbind(pidn_date_emo_b_df)

pidn_date_mem_b_df=memmeta_b_df%>%
  select(ExternalReference,RecordedDate)%>%
  rbind(pidn_date_emo_a_df)

#merge with the last df and mutate dates into dates datatype
pidn_date_df=memmeta_a_df%>%
  select(ExternalReference,RecordedDate)%>%
  rbind(pidn_date_mem_b_df)%>%
  mutate(RecordedDate=as_date(RecordedDate))%>%
  #group by pidn and keep only the latest completion date for age calculation
  group_by(ExternalReference) %>%
  slice(which.max(RecordedDate))

#write csv with agest to paste into lava for dob and demographics
#write_csv(pidn_date_df, 'pidn_date_df.csv')

demographics_df=demographics_df%>%
  rename(ExternalReference=PIDN)%>%
  mutate(ExternalReference=as.character(ExternalReference))
```

This selects only the pidn, responses, and bets-removing the practice
trial data

``` r
emometa_a_df = emometa_a_df %>%
  select(matches('ExternalReference|FirstResponse|Bet'))%>%
  select(-c(`2_c022Bet`,`3_c022Bet`))%>%
  drop_na()

emometa_b_df = emometa_b_df %>%
  select(matches('ExternalReference|FirstResponse|Bet'))%>%
  select(-c(`2_c022Bet`,`3_c022Bet`))%>%
  drop_na()

memmeta_a_df = memmeta_a_df %>%
  select(matches('ExternalReference|Choice|Bet'))%>%
  select('ExternalReference', '1_e061Choice1':'6_k113Bet6')%>%
  drop_na()

memmeta_b_df = memmeta_b_df %>%
  select(matches('ExternalReference|Choice|Bet'))%>%
  select('ExternalReference', '1_e061Choice1':'6_k113Bet6')%>%
  drop_na()
```

# specify the order (a,b) when using this function. Since nR\_S1, nR\_S2 will be used, we need to assign the randomized order to these two arrays

See
[\!link](https://github.com/LegrandNico/metadPy/tree/7f2916c4c5932b610ee805a4220dee0238f7cc6d)
[\!link](https://github.com/embodied-computation-group/EmotionMetamemory)

# nrs1 and nrs2s

``` r
function_name = function(df,a,b) {
datalist=list()
for (j in 1:nrow(tibble(df))){
  s1_4=0
  s1_3=0
  s1_2=0
  s1_1=0
  s2_1=0
  s2_2=0
  s2_3=0
  s2_4=0
for (i in 1:((ncol(tibble(df)))/3)){
  #when a=1 and b=2, the correct response is on the left and incorrect on right
  #when b=1 and a=2, correct response on right and incorrect on left
  if ((as.numeric(str_extract_all(df[j,c(i*3)],"[0-9]+")[[1]])[1]>=min(a))
      &(as.numeric(str_extract_all(df[j,c(i*3)],"[0-9]+")[[1]])[1]<=max(a))
      &(as.numeric(str_extract_all(df[j,c(i*3)],"[0-9]+")[[1]])[2]>=min(b))
      &(as.numeric(str_extract_all(df[j,c(i*3)],"[0-9]+")[[1]])[2]<=max(b))){
  #returns 1:160
    #chose incorrect response so when nR_S2 (a=2, b=1)
    if ((as.numeric(str_extract_all(df[j,c(i*3-1)],"[0-9]+")[[1]])>=min(a))
      &(as.numeric(str_extract_all(df[j,c(i*3-1)],"[0-9]+")[[1]])<=max(a))){
       if (df[j,c(i*3+1)] == 4){ #responded S1, rating = 4
         s1_4= s1_4+1}
       else if (df[j,c(i*3+1)]==3){
         s1_3=s1_3+1}
       else if (df[j,c(i*3+1)]==2){
         s1_2=s1_2+1}
       else if (df[j,c(i*3+1)]==1){ #responded S1, rating = 1
         s1_1=s1_1+1}
     }
      if ((as.numeric(str_extract_all(df[j,c(i*3-1)],"[0-9]+")[[1]])>=min(b))
      &(as.numeric(str_extract_all(df[j,c(i*3-1)],"[0-9]+")[[1]])<=max(b))){
        if (df[j,c(i*3+1)] == 1){ #responded S2, rating = 1
          s2_1=s2_1+1}
        else if (df[j,c(i*3+1)]==2){
          s2_2=s2_2+1}
        else if (df[j,c(i*3+1)]==3){
          s2_3=s2_3+1}
        else if (df[j,c(i*3+1)]==4){ #responded S2, rating = 4
          s2_4=s2_4+1}
      }
  }
  #print(c(s1_4, s1_3, s1_2, s1_1, s2_1, s2_2, s2_3, s2_4))
}
  nR=(tibble(ExternalReference=df$ExternalReference[j], s1_4, s1_3, s1_2, s1_1, s2_1, s2_2, s2_3, s2_4))
  datalist[[j]]=nR

}
  return(bind_rows(datalist))
}

#array for when the correct answer was displayed on the right
#nR_S1=function_name(emometa_a_df[6,],a=1,b=2)

#for nR_S1, when a=1 and b=2, the display of the choices is the correct response on the left and the incorrect on the right. The items in the array are the counts for when the participant was correct and responded with a confidence rating of 4, 3, 2, 1. The next half of this array is still saw the correct response on the left but chose the answer on the right, the incorrect response. These are arranged in ascending confidence order, 1,2,3,4


#array for when the correct answer was displayed on the right 
#nR_S2=function_name(emometa_a_df[6,],a=2,b=1)
#saw correct choice on the right and chose incorrectly with descending confidence levels then chose correctly with ascending confidence levels
```

``` r
get_accuracy = function(df,a) {
accuracy_list=list()
for (j in 1:nrow(tibble(df))){
  accuracy=0
  for (i in 1:((ncol(tibble(df)))/3)){
        if ((as.numeric(str_extract_all(df[j,c(i*3-1)],"[0-9]+"))>=min(a))
            &(as.numeric(str_extract_all(df[j,c(i*3-1)],"[0-9]+"))<=max(a))){
          accuracy=accuracy+1}}
#  if (((round(accuracy/((ncol(tibble(df))-1)/3),2))>=.58)&
#      (round(accuracy/((ncol(tibble(df))-1)/3),2))<=.78){
  acc=tibble(ExternalReference=df$ExternalReference[j], accuracy=(accuracy/((ncol(tibble(emometa_a_df))-1)/3)))
  accuracy_list[[j]]=acc
  }
return(bind_rows(accuracy_list))
}

### filter above between 58-78% accuracy

#both emo dfs passed with all falling in range from 68-76%--getting dfs 
emo_a_accuracy=get_accuracy(emometa_a_df,1)%>%
  filter((accuracy<.58) |
           accuracy>.78)
emo_b_accuracy=get_accuracy(emometa_b_df,1)%>%
  filter((accuracy<.58) |
           accuracy>.78)
mem_a_accuracy=get_accuracy(memmeta_a_df,1:6)%>%
  filter((accuracy<.58) |
           accuracy>.78)
mem_b_accuracy=get_accuracy(memmeta_b_df,1:6)%>%
  filter((accuracy<.58) |
           accuracy>.78)


emo_accuracy=rbind(emo_a_accuracy,emo_b_accuracy)
mem_accuracy=rbind(mem_a_accuracy, mem_b_accuracy)
accuracy=rbind(emo_accuracy,mem_accuracy)
```

### This is a little more forloopy than I wanted but dont want to spend any more time on figuring out ways around it

``` r
#assign df of interest to 'test'
test=memmeta_a_df

#tibbles work the same as arrays for getting meta-d'--range should be the ${lm://Field/"} fields
#for mem task, the lower numbers are correct and range from 1-6 and higher are lures ranging from 21-26
#for emo, 1s are target and 2s are lures
nR_S1=function_name(test,a=1:6,b=21:26)
nR_S2=function_name(test,a=21:26,b=1:6)

#join the nrs1 and nrs2 to a new df called temp
temp=nest_join(test,nR_S1, by='ExternalReference' )
temp=nest_join(temp,nR_S2, by='ExternalReference' )
```

### return meta-d only

``` r
metad_indiv <- function (nR_S1, nR_S2) {

  Tol <- 1e-05
  nratings <- length(nR_S1)/2
  
  # Adjust to ensure non-zero counts for type 1 d' point estimate
  adj_f <- 1/((nratings)*2)
  nR_S1_adj = nR_S1 + adj_f
  nR_S2_adj = nR_S2 + adj_f

  ratingHR <- matrix()
  ratingFAR <- matrix()

  for (c in 2:(nratings*2)) {
    #HR=hit rate
    ratingHR[c-1] <- sum(nR_S2_adj[c:length(nR_S2_adj)]) / sum(nR_S2_adj)
    # FAR = false alarm rate
    ratingFAR[c-1] <- sum(nR_S1_adj[c:length(nR_S1_adj)]) / sum(nR_S1_adj)

  }
  
  

  t1_index <- nratings
  
  d1 <<- qnorm(ratingHR[(t1_index)]) - qnorm(ratingFAR[(t1_index)])
  c1 <<- -0.5 * (qnorm(ratingHR[(t1_index)]) + qnorm(ratingFAR[(t1_index)]))
  
  counts <- t(nR_S1) %>% 
      cbind(t(nR_S2))
  counts <- as.vector(counts)

  # Data preparation for model
    data <- list(
      d1 = d1,
      c1 = c1,
      counts = counts,
      nratings = nratings,
      Tol = Tol
    )
    
    
    ## Model using JAGS
    # Create and update model
    #pasted repofolder-that's where I saved fleming code to 
    model <- jags.model(file = paste(repofolder,'Bayes_metad_indiv_R.txt',sep='/'), data = data,
                            n.chains = 3, quiet=FALSE)
    update(model, n.iter=1000)
    
    # Sampling
    output <- coda.samples( 
      model          = model,
      variable.names = c("meta_d", "cS1", "cS2"),
      n.iter         = 10000,
      thin           = 1 )
  
  #get and return only meta-d
    Value <- summary(output)

  return(list('metad'=Value$statistics[["meta_d","Mean"]],"dprime"=d1))
}
```

### loop to get meta-d and store it

### merge metad and dprime df (‘blah’) to the temp one-the one with the nrs1 and nrs2 added on to the copy (‘test’) of the df

``` r
metad_memmeta_a_df=merge(temp,blah, by='ExternalReference')

#read in others created teh same way
metad_memmeta_a_df=read_rds('metad_memmeta_a_df.rds')
metad_memmeta_b_df=read_rds('metad_memmeta_b_df.rds')
metad_emometa_a_df=read_rds('metad_emometa_a_df.rds')
metad_emometa_b_df=read_rds('metad_emometa_b_df.rds')
```

### isolate only relevant data to merge. create emofirst for ordering effects

``` r
emo_a_df=metad_emometa_a_df%>%
  select(ExternalReference,metad,dprime)%>%
  mutate('emometad'=metad,'emodprime'=dprime, 'emofirst'=as_factor(1))%>%
  select(ExternalReference,emometad,emodprime,emofirst)

mem_a_df=metad_memmeta_a_df%>%
  select(ExternalReference,metad,dprime)%>%
  mutate('memmetad'=metad,'memdprime'=dprime, 'emofirst'=as_factor(1))%>%
  select(ExternalReference,memmetad,memdprime,emofirst)


emo_b_df=metad_emometa_b_df%>%
  select(ExternalReference,metad,dprime)%>%
  mutate('emometad'=metad,'emodprime'=dprime, 'emofirst'=as_factor(0))%>%
  select(ExternalReference,emometad,emodprime,emofirst)

mem_b_df=metad_memmeta_b_df%>%
  select(ExternalReference,metad,dprime)%>%
  mutate('memmetad'=metad,'memdprime'=dprime, 'emofirst'=as_factor(0))%>%
  select(ExternalReference,memmetad,memdprime,emofirst)

#combining emo dfs
emo_df=rbind(emo_a_df,emo_b_df)
#combining mem dfs
mem_df=rbind(mem_a_df,mem_b_df)
#merging all and creating mratios (metad/d')
emo_mem_df=full_join(emo_df,mem_df, by = c("ExternalReference","emofirst"))%>%
  mutate('emoMratio'=emometad/emodprime,
         'memMratio'=memmetad/memdprime)
```

### removing those that dont have accuracy within range

``` r
'%!in%' <- function(x,y)!('%in%'(x,y))
emo_mem_df=emo_mem_df%>%
  filter(ExternalReference%!in%accuracy$ExternalReference)
```

\#meta\_d/d1

[\!need to verify, but it looks like d1 is
d’](https://github.com/metacoglab/HMeta-d/blob/67514c1368171ed727d9fb24a2e5d4ea0a990904/Matlab/fit_meta_d_mcmc.m)

[\!see also](https://github.com/LegrandNico)

Merge the demogrphics df with the emo\_mem\_df

``` r
emo_mem_df=left_join(emo_mem_df, demographics_df, by='ExternalReference')
emo_mem_df=left_join(emo_mem_df,pidn_date_df,by='ExternalReference')
emo_mem_df$age=as.period(interval(start = as_date(emo_mem_df$DOB), end = emo_mem_df$RecordedDate))$year
#saveRDS(emo_mem_df,'emo_mem_df.rds')
```
