GARP
================
Clayton Young
4/6/2020

timestamp for knit

``` r
Sys.time()
```

    ## [1] "2022-01-17 21:21:45 PST"

Load libraries

``` r
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
library(knitr)
library(maptools)
```

    ## Loading required package: sp

    ## Checking rgeos availability: FALSE
    ## Please note that 'maptools' will be retired by the end of 2023,
    ## plan transition at your earliest convenience;
    ## some functionality will be moved to 'sp'.
    ##      Note: when rgeos is not available, polygon geometry     computations in maptools depend on gpclib,
    ##      which has a restricted licence. It is disabled by default;
    ##      to enable gpclib, type gpclibPermit()

``` r
library(revealedPrefs)
```

    ## Loading required package: Rcpp

``` r
library(readxl)
library(lubridate)
```

    ## 
    ## Attaching package: 'lubridate'

    ## The following objects are masked from 'package:base':
    ## 
    ##     date, intersect, setdiff, union

First, set the directories.

``` r
if (Sys.info()["sysname"] == "Windows"){
  repofolder <- paste("C:/Users/", Sys.getenv("USERNAME"), "/decisionlab/DMA/Analysis/GARP_Analysis/", 
                      sep = "")
  datafolder <- "R:/groups/chiong/DMA/GARP/GARP_CSV/"
  rdrivepath <- "R:/"
} else if (Sys.info()["sysname"] == "Darwin"){ # not sure why MacOS is "Darwin" but it is...
  repofolder <- "~/decisionlab/DMA/Analysis/GARP_Analysis/"
  datafolder <- "/Volumes/macdata/groups/chiong/DMA/GARP/GARP_CSV/"
  rdrivepath <- "/Volumes/macdata/"
} # probably good to add another condition for Unix, later on...

knitr::opts_chunk$set(echo = TRUE)
knitr::opts_knit$set(root.dir = paste(datafolder))
```

Load in the functions we’ll use.

``` r
source(paste0(repofolder,"/fxn_garp.R"))
source(paste0(repofolder,"/fxn_emax.R"))
source(paste0(repofolder,"/fxn_garpe.R"))
source(paste0(repofolder,"/fxn_warshall.R"))
```

## R Markdown

First, download the qualtrics folder and rename it GARP\_DATA. Be sure
to store this in the R Drive in GARP\_CSV

This imports the qualtrics data with the relevant columns only and fills
the blanks with NA (so we can refer to them). We’ll name this dataframe
“GARP\_DATA”.

WARNING: This script requires users to import a new csv from Qualtrics
in order to run correctly.

``` r
#previous import and filter-now saving colnames as list and importing to dfs

#GARP_DATA_OUTDATED <- read.csv(paste(datafolder, "GARP_DATA.csv", sep=""), na.strings=c(""," ","NA"))[-c(1:2),c(1,7,18:19,34:44)]

#renaming columns-creating list to use to use for col names
colNames<-read_csv("GARP_DATA.csv", n_max = 0)%>%
  names()%>%
  recode("QI-1" = "PIDN", "Q47" = "Session", "QI-4" = "favChips", "QI-5" = "favCandy", "Q7" = "Example", "Q7_1" = "Q7", "random" = "selectedTrial")
```

    ## New names:
    ## * Q7 -> Q7...22
    ## * Q7 -> Q7...29

    ## Rows: 0 Columns: 48

    ## ── Column specification ────────────────────────────────────────────────────────
    ## Delimiter: ","
    ## chr (48): StartDate, EndDate, Status, IPAddress, Progress, Duration (in seco...

    ## 
    ## ℹ Use `spec()` to retrieve the full column specification for this data.
    ## ℹ Specify the column types or set `show_col_types = FALSE` to quiet this message.

``` r
#filter out 'test' sessions any pidn with a letter 't' gets filtered
GARP_df<-read_csv("GARP_DATA.csv",  col_names = colNames, skip = 3)%>%
  filter(!grepl("t", Session) & !grepl("t", PIDN))%>%
  mutate(Session = as.numeric(Session), StartDate = str_replace(StartDate, "\\s[^ ]+$", ""), StartDate = mdy(StartDate),
         EndDate = str_replace(EndDate, "\\s[^ ]+$", ""), EndDate = mdy(EndDate), 
         RecordedDate = str_replace(RecordedDate, "\\s[^ ]+$", ""), RecordedDate = mdy(RecordedDate), Collection = "In-person")
```

    ## Rows: 130 Columns: 48

    ## ── Column specification ────────────────────────────────────────────────────────
    ## Delimiter: ","
    ## chr (12): StartDate, EndDate, IPAddress, RecordedDate, ResponseId, Distribut...
    ## dbl (32): Status, Progress, Duration (in seconds), Finished, LocationLatitud...
    ## lgl  (4): RecipientLastName, RecipientFirstName, RecipientEmail, ExternalRef...

    ## 
    ## ℹ Use `spec()` to retrieve the full column specification for this data.
    ## ℹ Specify the column types or set `show_col_types = FALSE` to quiet this message.

    ## Warning in mask$eval_all_mutate(quo): NAs introduced by coercion

``` r
GARPVirtual_df<-read_csv("GARP_DATA_virtual.csv", col_names = colNames, skip = 3)%>%
  filter(!grepl("t", Session) & !grepl("t", PIDN))%>%
  mutate(Session = as.numeric(Session), StartDate = as_date(StartDate), EndDate = as_date(EndDate), RecordedDate = as_date(RecordedDate), Collection = "Online")
```

    ## Rows: 30 Columns: 47

    ## ── Column specification ────────────────────────────────────────────────────────
    ## Delimiter: ","
    ## chr   (7): IPAddress, ResponseId, DistributionChannel, UserLanguage, PIDN, c...
    ## dbl  (33): Status, Progress, Duration (in seconds), Finished, LocationLatitu...
    ## lgl   (4): RecipientLastName, RecipientFirstName, RecipientEmail, ExternalRe...
    ## dttm  (3): StartDate, EndDate, RecordedDate

    ## 
    ## ℹ Use `spec()` to retrieve the full column specification for this data.
    ## ℹ Specify the column types or set `show_col_types = FALSE` to quiet this message.

``` r
#count occurrences of PIDNS (the existing 'session' is inaccurate)
#n counts thee number of times the PIDN has appeared so far, so we're filtering out second+ sessions
GARP_df<-bind_rows(GARP_df, GARPVirtual_df)%>%
  add_count(PIDN)%>%
  filter(Progress == 100 & n == 1)%>%
  mutate(chocolate = case_when(chocolate == 'https://ucsf.co1.qualtrics.com/ControlPanel/Graphic.php?IM=IM_a4uLmzzEQsBMeRT' ~ "Reese's",
                               chocolate == "https://ucsf.co1.qualtrics.com/ControlPanel/Graphic.php?IM=IM_e2rPPLntCXqbQZn" ~ "SNICKERS",
                               chocolate == "https://ucsf.co1.qualtrics.com/ControlPanel/Graphic.php?IM=IM_9M750JRqJ218L09" ~ "M&M's"))%>%
  mutate(chips = case_when(chips == "https://ucsf.co1.qualtrics.com/ControlPanel/Graphic.php?IM=IM_0BoW27DZmmXVgxL" ~ "Doritos",
                           chips == "https://ucsf.co1.qualtrics.com/ControlPanel/Graphic.php?IM=IM_9LCYYvt9Hv9hlsh" ~ "Cheetos",
                           chips == "https://ucsf.co1.qualtrics.com/ControlPanel/Graphic.php?IM=IM_6LHdROHXyoyBDoN" ~ "Lay's"))


#for plotting later
safe_colorblind_palette <- c("#88CCEE", "#CC6677", "#DDCC77", "#117733", "#332288", "#AA4499", 
                             "#44AA99", "#999933", "#882255", "#661100", "#6699CC", "#888888")
```

Create subset of columns for test responses and store as GARP\_Columns
and store all rows where the test responses weren’t left blank.

``` r
#previous method

#GARP_Columns <- GARP_DATA_OUTDATED[ ,5:15] 
#GARP_DATA_OUTDATED <- GARP_DATA_OUTDATED[complete.cases(GARP_Columns), ] 
#Lava_OUTDATED<-read.csv(paste(datafolder, "Lava.csv", sep=""), na.strings=c(""," ","NA"))[,c(1,7)]
#GARP_DATA_OUTDATED$Dx <- Lava$ClinSynBestEst[match(GARP_DATA_OUTDATED$QI.1, Lava$PIDN)]
#GARP_DATA_OUTDATED<- GARP_DATA_OUTDATED[,c(1,2,4,3,16,5:15)]
#names(GARP_DATA_OUTDATED)[3]<-"Session"
#names(GARP_DATA_OUTDATED)[4]<-"PIDN"


#TidyVersion of base R above
Lava_df<-read_xlsx("Lava.xlsx")%>%
  select(as.character('PIDN...1'), ClinSynBestEst)%>%
  rename("PIDN" = "PIDN...1", "Dx" = "ClinSynBestEst")
```

    ## New names:
    ## * PIDN -> PIDN...1
    ## * InstrID -> InstrID...3
    ## * PIDN -> PIDN...4
    ## * InstrID -> InstrID...106

``` r
#TidyVersion of original code w/merging lava data included 
GARP_DATA<-GARP_df%>%
  select(StartDate, Collection, Finished, PIDN, 'Q1':'Q2-11')%>%
  drop_na()%>%
  merge(Lava_df, by = "PIDN")

#If need list of PIDNs to gather data from Lava, drop the "merge" code and replace with: select(PIDN)
```

Import price matrix (relevant columns only).

``` r
P_GARP <- read_csv("P_GARP.csv")[1:11,2:4]
```

    ## Rows: 22 Columns: 4

    ## ── Column specification ────────────────────────────────────────────────────────
    ## Delimiter: ","
    ## dbl (4): Choice Set, Chips, Candy, Available Funds

    ## 
    ## ℹ Use `spec()` to retrieve the full column specification for this data.
    ## ℹ Specify the column types or set `show_col_types = FALSE` to quiet this message.

Create a list with all the CS files so they can be called and imported

``` r
CScsv<-c()

for (i in 1:11){
  CScsv[i]<-(sprintf("CS%d_GARP.csv",i))
}
```

Create a name for the CS files w/o .csv to make environment look pretty

``` r
CS<-c()

for (i in 1:11){
  CS[i]<-(sprintf("CS%d_GARP",i))
}
```

Import choice set files w/relevant columns only

``` r
for (i in 1:11)
{
  assign(CS[i], read.csv(paste0(CScsv[i]))[,2:3])
}
```

This creates a list to store all of the matrices we’re about to create
for each participant (DRP, transitive (RP), Strict (P0)) and lists to
hold each participant’s violation indices and their number of
violations.

``` r
list_mat <- list()

list_DRP<-list()

list_RP<-list()

list_P0<-list()

list_viol<-list()

list_indices<-list()

list_ViolIndices<-list()
```

We’ll want to now create a pdf to export our plots to. The following
loop creates an x matrix for each participant. That is, a matrix that
contains the participant’s number of items chosen in each trial.

``` r
pdf("plots.pdf")
#this loop ensures that we create an X matrix for each participant
for (b in 1:nrow(GARP_DATA)){
  
  ##Create a matrix to populate with the item quantity of participant's choices
  x<-matrix(data = NA, nrow = 11, ncol = 2)
  
  ##since there are two columns in our matrix, we are going to want to do two iterations of the loops below
  for (k in 1:2)
    
    ##and now, since there are 11 rows in our matrix, we need the rest of the nested loop
    ##to iterate through these as well
    for (j in 1:11){
      
      ## read the GARP_DATA's Q# response into placeholder object (first part in the bracket is the PIDN)
      EXx_GARP<-GARP_DATA[(get(paste0("b"))),(get(paste0("j")))+15]
      
      ## We are now creating a placeholder object for the various CS#_GARP files
      CSx_GARP <- get(paste0("CS", j, "_GARP"))
      
      ## Here we are referencing the rows in each CS file 
      for (o in 1:nrow(CSx_GARP)){
        
        ## now we use the rows referenced above to see if the participant's response EXx_GARP)
        ## is equal to a row in the various CS files
        if (EXx_GARP == o){
          
          ##this last bit inserts the row of the CS file that corresponds to the participant's response
          ##into the row of the X matrix we created in the beginning
          x[j,k]<-CSx_GARP[o,k]
        }
      }
    }
   #this stores each X matrix to the list we created in the very beginning
  list_mat[[b]] <- x 
  
  #this labels columns in the new matrices
  colnames(list_mat[[b]]) <- c("Chips", "Candy")
  
  #this correctly labels the rows in each matrix
  rownames(list_mat[[b]]) <-c(1:11)
  
  
  #create a variable that stores the participant's PIDN and Dx for plot label
  file_name = sprintf("PIDN %s Dx:%s", GARP_DATA$PIDN[b], GARP_DATA$Dx[b])
  #create a plot for each participant (indexes the list mat[[]] that corresponds to each participant (1-however many         participants there are)
  #note that this only creates a plot with labels, axis labels, and with the participant's responses as Blue dots 
  plot(NULL,xlab="Candy", ylab="Chips",xlim = c(0,9), ylim = c(0,9), xaxs="i", yaxs="i", main=file_name)
    #this labels the axis with 0-9 by 1
  axis(1, at=seq(0, 9, 1))
  axis(2, at=seq(0, 9, 1))
  #this loop creates lines and points on the lines with all response options, as well as a legend. 
  for (i in 1:11){
    
    points(x = (get(paste0("CS", i, "_GARP"))$Candy), y = (get(paste0("CS", i, "_GARP"))$Chips), pch=4)
    lines(x = c(P_GARP$`Available Funds`[i]/P_GARP$Candy[i],0), y= c(0,P_GARP$`Available Funds`[i]/P_GARP$Chips[i]), col=safe_colorblind_palette[i], lwd =3)
    legend(x="topright",y= 0, legend=c("Trial 1", "Trial 2","Trial 3", "Trial 4", "Trial 5", "Trial 6", "Trial 7", "Trial 8", "Trial 9", "Trial 10", "Trial 11"),
           col=safe_colorblind_palette[1:11], lty=1, cex=1.2, lwd =3)
  }
  
  
  
  #this creates points for the participant's responses and jitters then by .09 to ensure they aren't completely overlapping one another
    points(jitter(list_mat[[b]][,2], factor =.2), jitter(list_mat[[b]][,1], factor = .2), col = safe_colorblind_palette[1:11], pch = 21, bg = alpha(safe_colorblind_palette, 0.5), cex = 2)
    

  
  #label participant responses with the trial number-----removed to reduce clutter
    #maptools::pointLabel(x=list_mat[[b]][,2],y=list_mat[[b]][,1], labels=sprintf("%d",1:11), cex=.5, allowSmallOverlap = FALSE, doPlot = TRUE, pos =4 )
    

  
  
  #This stores whether or not there is a GARP violation for each participant in the GARP_DATA data frame
  #True=violation; False=no violation
  GARP_DATA$violation[b] <- (revealedPrefs::checkGarp(list_mat[[b]],P_GARP[,1:2],afriat.par= 1)$violation)
  
}
```

Here is an example of the x matrix created for a participant, the p
matrix we use (P\_GARP), and the participant’s plot.

X matrix

    ##    Chips Candy
    ## 1      2     0
    ## 2      2     2
    ## 3      2     3
    ## 4      2     2
    ## 5      3     2
    ## 6      3     2
    ## 7      0     2
    ## 8      2     2
    ## 9      3     3
    ## 10     2     3
    ## 11     3     2

P Matrix

    ## # A tibble: 11 × 2
    ##    Chips Candy
    ##    <dbl> <dbl>
    ##  1     3     1
    ##  2     2     1
    ##  3     3     1
    ##  4     1     1
    ##  5     2     1
    ##  6     1     1
    ##  7     1     3
    ##  8     1     2
    ##  9     1     1
    ## 10     1     2
    ## 11     1     3

![](GARP_correctedPlots_files/figure-gfm/unnamed-chunk-13-1.png)<!-- -->

Now we have x matrices, plots, and a column in our dataframe GARP\_DATA
that lets us know if a participant has a violation.

Next, we will create 11x11 matrices for each participant. The matrices
stored in list\_DRP are the direct revealed preferred matrices. The
list\_RP matrices are the (in)direct revealed preferred matrices, and
the list\_P0 matrices are transposed strict direct revealed preferred
matrices.

For each matrix, the rows are being compared to the columns (e.g. index
\[3,6\] is comparing the product of p^3 X x^3 to the product of p^3 X
x^6). A value of 1 in an index is used to indicate that the index meets
the condition.

There are notes that further describe each process within the code.

``` r
for (b in 1:nrow(GARP_DATA)){
  #MAKE DRP-MATRIX AND P0-MATRIX
  #DRP-matrix has T rows and columns. 
  #Element (i,j)=1 if i DRP j (i directly revealed preferred over j)
  
  #here we are creating an 11x11 matrix (based on the first dimension of
  #x)
  
  #create 11x11 matrix
  x<-matrix(data = NA,nrow = 11, ncol = 11)
  
  #create a list that contains an 11x11 matrix for each participant. this is where we will store the Direct Revealed Preferred (DRP) matrix
  list_DRP[[b]]<-x
  #now we're creating another 11x11 matrix filled with zeros. this matrix will be used to compare our transitive closure DRP matrix 
  #to see if there are any violations
  list_P0[[b]]=x
  
  #This calls 1:11 (the eleven comes from the size of the first dimension of p_garp) as i
  for (i in 1:nrow(list_DRP[[b]])){
    
    #this calls 1:11  
    for (j in 1:nrow(list_DRP[[b]])){
      
      #This compares the product of i row for participant's [[b]] quantity of items and the price of the items in i row of P_GARP
      #and the product of j row for b participant's quantity of items and the price of the items in i row of P_GARP
      #USES MATRIX MULTIPLICATION

      if ((list_mat[[b]][i,]%*%t(P_GARP[i,c(1,2)]))>=(list_mat[[b]][j,]%*%t(P_GARP[i,c(1,2)]))){
        
        #if x^i*p^i>=x^j*p^i, then we set participant b's DRP matrix index [i,j] to 1
        list_DRP[[b]][i,j]<-1
        
        #this is the same condition as above but without 'equal to'
        if ((list_mat[[b]][i,]%*%t(P_GARP[i,c(1,2)]))>(list_mat[[b]][j,]%*%t(P_GARP[i,c(1,2)]))){
          
          #so, if the first half of this condition is greater than
          #the second half, the new matrix P0 index (i,j) is set to 1
          #we will use the P0 matrix to compare our transitive closure DRP matrix to find the number of GARP violations
          
          list_P0[[b]][i,j]<-1
        } 
      } 
    } 
  }
  #set all NAs in our new matrices to 0
  list_P0[[b]][is.na(list_P0[[b]])]<- 0
  list_DRP[[b]][is.na(list_DRP[[b]])]<-0
}
#we'll stop using the DRP matrices from here on out and instead use the RP matrices 
#so we can use the DRPs for reference 
list_RP<-list_DRP

# We look for transitivities: if i R0 j and j R0 k then we note i R k 
#R0=directly revealed preferred 
#R=indirectly revealed preferred
#(i indirectly revealed preferred over j).
# Adapt R0-matrix such that element (i,j)=1 if i R j

for (b in 1:nrow(GARP_DATA)){
  
  #K will initially refer to the columns in RP matrix, then be used as the column number if all conditions are met. 
  #this is how we find the transitive closures
  for (k in 1:11){
    
    #i will be used to reference all rows
    for (i in 1:11){ 
      
      #this conditional statement is indexing R the RP matrix
      #Only continues if (i,k) not 0
      #this starts at k column and cycles through each row 
      if (list_RP[[b]][i,k]>0){    
        
        #this set j to iterate through all rows except k 
        #once we run into a 1 going down i rows in k col, we continue with this for loop
        for (j in 1:11){
          
          #we keep the i row where we encountered a 1 and see if any of the values in columns 1:11 are equal to zero
          #its important to note that this will not stop when a zero is found. It will cycle through all 11 columns.
          if (list_RP[[b]][i,j]==0){
            
            #if the indexed value is 0, this sets the indexed value
            #of R(i,j) to R(k,j) 
            list_RP[[b]][i,j]=list_RP[[b]][k,j]
            
            #in other words, for example:
            #if 1 R0 2 or (DRP[1,2]==1)
            #and 1 != R0 6 or (DRP[1,6]==0)
            #but 2 R0 6 or (DRP[2,6]==1)
            #then 1 R 6 or (RP[1,6]==1)
            
            
          }
        } 
      } 
    } 
  }
}
```

Here is an example of the DRP, RP, and P0 matrix for the same
participant.

DRP

    ##       [,1] [,2] [,3] [,4] [,5] [,6] [,7] [,8] [,9] [,10] [,11]
    ##  [1,]    1    0    0    0    0    0    1    0    0     0     0
    ##  [2,]    1    1    0    1    0    0    1    1    0     0     0
    ##  [3,]    1    1    1    1    0    0    1    1    0     1     0
    ##  [4,]    1    1    0    1    0    0    1    1    0     0     0
    ##  [5,]    1    1    1    1    1    1    1    1    0     1     1
    ##  [6,]    1    1    1    1    1    1    1    1    0     1     1
    ##  [7,]    1    0    0    0    0    0    1    0    0     0     0
    ##  [8,]    1    1    0    1    0    0    1    1    0     0     0
    ##  [9,]    1    1    1    1    1    1    1    1    1     1     1
    ## [10,]    1    1    1    1    1    1    1    1    0     1     1
    ## [11,]    1    1    0    1    1    1    1    1    0     0     1

RP-indirectly revealed preferred

    ##       [,1] [,2] [,3] [,4] [,5] [,6] [,7] [,8] [,9] [,10] [,11]
    ##  [1,]    1    0    0    0    0    0    1    0    0     0     0
    ##  [2,]    1    1    0    1    0    0    1    1    0     0     0
    ##  [3,]    1    1    1    1    1    1    1    1    0     1     1
    ##  [4,]    1    1    0    1    0    0    1    1    0     0     0
    ##  [5,]    1    1    1    1    1    1    1    1    0     1     1
    ##  [6,]    1    1    1    1    1    1    1    1    0     1     1
    ##  [7,]    1    0    0    0    0    0    1    0    0     0     0
    ##  [8,]    1    1    0    1    0    0    1    1    0     0     0
    ##  [9,]    1    1    1    1    1    1    1    1    1     1     1
    ## [10,]    1    1    1    1    1    1    1    1    0     1     1
    ## [11,]    1    1    1    1    1    1    1    1    0     1     1

P0

    ##       [,1] [,2] [,3] [,4] [,5] [,6] [,7] [,8] [,9] [,10] [,11]
    ##  [1,]    0    0    0    0    0    0    1    0    0     0     0
    ##  [2,]    1    0    0    0    0    0    1    0    0     0     0
    ##  [3,]    1    1    0    1    0    0    1    1    0     0     0
    ##  [4,]    1    0    0    0    0    0    1    0    0     0     0
    ##  [5,]    1    1    1    1    0    0    1    1    0     1     0
    ##  [6,]    1    1    0    1    0    0    1    1    0     0     0
    ##  [7,]    1    0    0    0    0    0    0    0    0     0     0
    ##  [8,]    1    0    0    0    0    0    1    0    0     0     0
    ##  [9,]    1    1    1    1    1    1    1    1    0     1     1
    ## [10,]    1    1    0    1    1    1    1    1    0     0     1
    ## [11,]    1    1    0    1    0    0    1    1    0     0     0

This next bit of looping counts the number of violations for each
participant and stores the number of violations in the GARP\_DATA and
stores the ACCI in GARP\_DATA. If the participant only chose one item
(e.g. chips the entire time), the GARP\_DATA column labled exclude will
appear as “True” for the participant. It also stores that participant’s
violations in list\_violIndices. A more detailed explanation for each
bit of code can be found below.

``` r
for (b in 1:nrow(GARP_DATA)){
  #we set nviol to 0 before we start counting the # of violations
  list_viol[[b]] = 0;
  
  #set t to 1:11
  for (t in 1:11){
    #set v for 1:11
    for (v in 1:11){
      #Here we use the transitive closure DRP matrix to see if there are any GARP violations
      #we first start at t row and go through v columns until we encounter a 1 
      #once we encounter a 1, we look to see if the strictly directly preferred matrix P0's v row and t column is also equal to 1
      #if both matrix indicies are equal to 1, then there is a violation. 
      #however, once we encounter a violation in a row of the DRP matrix, we continue to the next row of the DRP matrix. 
      
      #conceptually, this is saying that if the transitive closure DRP matrix provides us with this R relation between 1 and 3:
      #if 1 R0 7 or (DRP[1,7]==1) or p^1*x^1>=p^1x^7
      #and 1 != R0 3 or (DRP[1,3]==0) or p^1*x^1!>=p^1x^3
      #but 7 R0 3 or (DRP[7,3]==1) or p^7*x^7!>=p^7x^3
      #then 1 R 3 or warshall(DRP[1,3]==1) or p^1*x^1>=p^1x^3 by transitive closure (or the logic above)
      
      #then we CANNOT have P0 index of [3,1]==1
      #this would mean that 3 is stricly preferred to 1 
      
      #this is a GARP violation because at the same at the same price, choice 1 is greater or equal to 7
      #and at the same price choice 7 is greater than or equal to 3
      #thus, we can infer that at the same price, 1 is greater than or equal to choice 3
      #however, we calculated in the P0 matrix that at the same price, choice 3 is greater than choice 1, which violates our  `         inference
      
      
      if (list_RP[[b]][t,v] == 1 && list_P0[[b]][v,t] ==1){ # if t is indir RP to v and v is directly RP to t
        
        #we add +1 to the list_viol counter for that participant
        list_viol[[b]] = list_viol[[b]]+1;
        
        #here we index where the violations occured on the RP matrix
        list_indices[[b]]<-(which(list_RP[[b]] == 1 & t(list_P0[[b]]) ==1, arr.ind = TRUE))
        
        #this gets rid of duplicates similar to how the break statement jumps to the next row when it encounters a violation 
        list_ViolIndices[[b]]<-list_indices[[b]][which(!duplicated(list_indices[[b]][,1])),]
        
        #NOTE: the indices in list_indices refer to the index of the RP Matrix, and the reverse index of the P0 matrix. 
        #for example, if the index listed is row 6 column 1, then this index in the RP matrix will be 1 and 
        #the index in the P0 matix row 1, column 6 will be 1. In other words, RP[6,1]=1 and P0[1,6]=1, which is a violation.
        break
      }
    }
  }
  
  
  #these create columns in our final dataframe that include the number of GARP violations, the Afriat Critical Cost efficiency Index, 
  #and the participants that should be exluded from final analysis because they only chose one set of items in the expirement(e.g. chips only)
  GARP_DATA$violations[b] <- list_viol[[b]]
  GARP_DATA$ACCI[b]<- emax(P_GARP, list_mat[[b]])
  GARP_DATA$Exclude[b]<-(sum(list_mat[[b]][,1])==0 | sum(list_mat[[b]][,2])==0)
}

#this creates a .csv file with the final dataframe
#write.csv(GARP_DATA, file="GARP_DATA_FINAL.csv", row.names=FALSE)
```

For this participant, we can use the list\_ViolIndices to find the
indices of our violations.

Violations

    ##      row col
    ## [1,]   7   1
    ## [2,]   3   5
    ## [3,]  10   5
    ## [4,]   1   7
    ## [5,]   5  10
    ## [6,]   6  10
    ## [7,]  11  10

If we look at our DRP matrix index \[3,5\], we see the value 1. Because
this is the index of a violation, our P0 index \[5,3\] should also give
us a value of 1, which is a violation.

Similarly, if we look at the DRP matrix index \[6,5\], we see the value
1. Because this is the index of a violation, our P0 index \[5,6\] should
also give us a value of 1, which is a violation.

consolidate clinBestEst dx to larger groups for prelim analysis

``` r
GARP_DATA<-GARP_DATA%>%
  mutate(groupedDX = ifelse(Dx %in% c(grep("ALZ|LOGO", Dx, value = T)), "AD",
                            ifelse(Dx %in% c(grep("FTD|FRONTOTEMPORAL", Dx, value = T)), "bvFTD", 
                                   ifelse(Dx %in% c(grep("SEMANTIC", Dx, value = T)), "svPPA", 
                                          ifelse(Dx %in% c(grep("NORMAL", Dx, value = T)), "Clinically Normal", NA)))),
         StartDate = str_replace(StartDate, "\\s[^ ]+$", ""),
         ACCI = as_factor(ACCI))


#counts w/filtering
GARP_DATA%>%
  filter(!is.na(groupedDX) & Exclude == FALSE)%>%
  count(groupedDX)
```

    ##           groupedDX  n
    ## 1                AD 25
    ## 2             bvFTD 23
    ## 3 Clinically Normal 13
    ## 4             svPPA  8

``` r
ACCIcount<-GARP_DATA%>%
  filter(!is.na(groupedDX) & Exclude == FALSE)%>%
  group_by(groupedDX)%>%
  count(., groupedDX, ACCI, Collection)

#all dates hereafter were administered online: 6/17/2020 

ggplot(data = ACCIcount, aes(x = ACCI , y = n, fill = Collection))+
  geom_bar(stat='identity')+
  facet_wrap(~groupedDX, scales = "free_x")+
  theme_classic()+
  theme(axis.text.x = element_text(angle = 45, 
                                   vjust = 1, 
                                   hjust = 1,
                                   size = 8))
```

![](GARP_correctedPlots_files/figure-gfm/unnamed-chunk-20-1.png)<!-- -->

``` r
  #ggsave("ACCIprelim.eps", width = 7, height = 7,  device=cairo_ps)


violcount<-GARP_DATA%>%
  filter(!is.na(groupedDX) & Exclude == FALSE)%>%
  group_by(groupedDX)%>%
  count(., groupedDX, violations, Collection)

ggplot(data = violcount, aes(x = violations, y = n, fill = Collection))+
  geom_bar(stat='identity')+
  expand_limits(x =c(0,10))+
  scale_x_continuous(name = "Violations",
                     breaks = seq(from= 0, to = 10, by = 1))+
  facet_wrap(~groupedDX)+
  theme_classic()
```

![](GARP_correctedPlots_files/figure-gfm/unnamed-chunk-20-2.png)<!-- -->

``` r
  #ggsave("violPrelim.eps", width = 7, height = 7,  device=cairo_ps)
```

modeling. realized the violcounts used for plots shouldn’t be used for
modeling\!

``` r
garpFiltered_df<-GARP_DATA%>%
  filter(!is.na(groupedDX) & Exclude == FALSE)

#x^2 should be close to 1. this signals that the mean and variance are roughly equal
chisq.test(x=garpFiltered_df$groupedDX, y = garpFiltered_df$violations)
```

    ## Warning in chisq.test(x = garpFiltered_df$groupedDX, y =
    ## garpFiltered_df$violations): Chi-squared approximation may be incorrect

    ## 
    ##  Pearson's Chi-squared test
    ## 
    ## data:  garpFiltered_df$groupedDX and garpFiltered_df$violations
    ## X-squared = 41.056, df = 30, p-value = 0.08597

``` r
#could also just look at these outcome variables to compare
var(garpFiltered_df$violations)
```

    ## [1] 7.629582

``` r
mean(garpFiltered_df$violations)
```

    ## [1] 2.753623

``` r
#check for ACCI-this will use a different model
chisq.test(x = garpFiltered_df$groupedDX, y=as.numeric(as.character(garpFiltered_df$ACCI)))
```

    ## Warning in chisq.test(x = garpFiltered_df$groupedDX, y =
    ## as.numeric(as.character(garpFiltered_df$ACCI))): Chi-squared approximation may
    ## be incorrect

    ## 
    ##  Pearson's Chi-squared test
    ## 
    ## data:  garpFiltered_df$groupedDX and as.numeric(as.character(garpFiltered_df$ACCI))
    ## X-squared = 24.828, df = 27, p-value = 0.5841

``` r
mean(as.numeric(as.character(garpFiltered_df$ACCI)))
```

    ## [1] 0.9218196

``` r
var(as.numeric(as.character(garpFiltered_df$ACCI)))
```

    ## [1] 0.01437983

``` r
#When the dispersion statistic is close to one, a Poisson model fits. If it is larger than one, a negative binomial model fits better.
#taken from : https://www.theanalysisfactor.com/poisson-or-negative-binomial-using-count-model-diagnostics-to-select-a-model/

#other resources to save progress: https://cran.r-project.org/web/packages/pscl/vignettes/countreg.pdf
#https://stats.idre.ucla.edu/stata/dae/zero-inflated-negative-binomial-regression/

#https://datavoreconsulting.com/post/count-data-glms-choosing-poisson-negative-binomial-zero-inflated-poisson/

#https://stat.ethz.ch/R-manual/R-patched/library/stats/html/chisq.test.html


GARP_DATA%>%
    filter(!is.na(groupedDX) & Exclude == FALSE)%>%
    group_by(groupedDX)%>%
    summarise(mean(violations), median(violations), sd(violations), mean(as.numeric(as.character(ACCI))), median(as.numeric(as.character(ACCI))), sd(as.numeric(as.character(ACCI))))
```

    ## # A tibble: 4 × 7
    ##   groupedDX         `mean(violation… `median(violati… `sd(violations)` `mean(as.numeri…
    ##   <chr>                        <dbl>            <dbl>            <dbl>            <dbl>
    ## 1 AD                            2.64              3               2.33            0.933
    ## 2 bvFTD                         2.65              2               2.74            0.925
    ## 3 Clinically Normal             3.23              2               3.75            0.891
    ## 4 svPPA                         2.62              1.5             2.72            0.927
    ## # … with 2 more variables: median(as.numeric(as.character(ACCI))) <dbl>,
    ## #   sd(as.numeric(as.character(ACCI))) <dbl>

``` r
chisq.test(x = violcount$groupedDX, y = violcount$violations)
```

    ## Warning in chisq.test(x = violcount$groupedDX, y = violcount$violations): Chi-
    ## squared approximation may be incorrect

    ## 
    ##  Pearson's Chi-squared test
    ## 
    ## data:  violcount$groupedDX and violcount$violations
    ## X-squared = 28.133, df = 30, p-value = 0.5634

``` r
dispersion_test <- function(x) 
{
  res <- 1-2 * abs((1 - pchisq((sum((x - mean(x))^2)/mean(x)), length(x) - 1))-0.5)

  cat("Dispersion test of count data:\n",
      length(x), " data points.\n",
      "Mean: ",mean(x),"\n",
      "Variance: ",var(x),"\n",
      "Probability of being drawn from Poisson distribution: ", 
      round(res, 3),"\n", sep = "")

  invisible(res)
}


dispersion_test(violcount$violations)
```

    ## Dispersion test of count data:
    ## 33 data points.
    ## Mean: 3.393939
    ## Variance: 7.683712
    ## Probability of being drawn from Poisson distribution: 0

``` r
pois<-glm(violations ~ groupedDX, data = violcount, family = poisson())
summary(pois)
```

    ## 
    ## Call:
    ## glm(formula = violations ~ groupedDX, family = poisson(), data = violcount)
    ## 
    ## Deviance Residuals: 
    ##     Min       1Q   Median       3Q      Max  
    ## -2.8284  -1.3427  -0.5234   0.6595   2.7202  
    ## 
    ## Coefficients:
    ##                             Estimate Std. Error z value Pr(>|z|)    
    ## (Intercept)                1.099e+00  1.741e-01   6.311 2.77e-10 ***
    ## groupedDXbvFTD             2.877e-01  2.410e-01   1.194    0.233    
    ## groupedDXClinically Normal 2.007e-01  2.752e-01   0.729    0.466    
    ## groupedDXsvPPA             7.322e-13  2.791e-01   0.000    1.000    
    ## ---
    ## Signif. codes:  0 '***' 0.001 '**' 0.01 '*' 0.05 '.' 0.1 ' ' 1
    ## 
    ## (Dispersion parameter for poisson family taken to be 1)
    ## 
    ##     Null deviance: 84.274  on 32  degrees of freedom
    ## Residual deviance: 82.368  on 29  degrees of freedom
    ## AIC: 174.54
    ## 
    ## Number of Fisher Scoring iterations: 5

``` r
quasipois<-glm(violations ~ groupedDX, data = violcount, family = quasipoisson)
summary(pois)
```

    ## 
    ## Call:
    ## glm(formula = violations ~ groupedDX, family = poisson(), data = violcount)
    ## 
    ## Deviance Residuals: 
    ##     Min       1Q   Median       3Q      Max  
    ## -2.8284  -1.3427  -0.5234   0.6595   2.7202  
    ## 
    ## Coefficients:
    ##                             Estimate Std. Error z value Pr(>|z|)    
    ## (Intercept)                1.099e+00  1.741e-01   6.311 2.77e-10 ***
    ## groupedDXbvFTD             2.877e-01  2.410e-01   1.194    0.233    
    ## groupedDXClinically Normal 2.007e-01  2.752e-01   0.729    0.466    
    ## groupedDXsvPPA             7.322e-13  2.791e-01   0.000    1.000    
    ## ---
    ## Signif. codes:  0 '***' 0.001 '**' 0.01 '*' 0.05 '.' 0.1 ' ' 1
    ## 
    ## (Dispersion parameter for poisson family taken to be 1)
    ## 
    ##     Null deviance: 84.274  on 32  degrees of freedom
    ## Residual deviance: 82.368  on 29  degrees of freedom
    ## AIC: 174.54
    ## 
    ## Number of Fisher Scoring iterations: 5

``` r
#zero infalted models
library(pscl)
```

    ## Classes and Methods for R developed in the
    ## Political Science Computational Laboratory
    ## Department of Political Science
    ## Stanford University
    ## Simon Jackman
    ## hurdle and zeroinfl functions by Achim Zeileis

``` r
zinfpois<-zeroinfl(violations ~groupedDX, data = violcount, dist = "poisson")
summary(zinfpois)
```

    ## 
    ## Call:
    ## zeroinfl(formula = violations ~ groupedDX, data = violcount, dist = "poisson")
    ## 
    ## Pearson residuals:
    ##     Min      1Q  Median      3Q     Max 
    ## -1.6625 -0.9826 -0.4156  0.4913  2.0781 
    ## 
    ## Count model coefficients (poisson with log link):
    ##                            Estimate Std. Error z value Pr(>|z|)    
    ## (Intercept)                 1.27051    0.18390   6.909 4.89e-12 ***
    ## groupedDXbvFTD              0.22179    0.25128   0.883    0.377    
    ## groupedDXClinically Normal  0.43005    0.28345   1.517    0.129    
    ## groupedDXsvPPA             -0.05235    0.29644  -0.177    0.860    
    ## 
    ## Zero-inflation model coefficients (binomial with logit link):
    ##                            Estimate Std. Error z value Pr(>|z|)  
    ## (Intercept)                 -1.6737     0.9081  -1.843   0.0653 .
    ## groupedDXbvFTD              -0.5171     1.4851  -0.348   0.7277  
    ## groupedDXClinically Normal   0.9679     1.2600   0.768   0.4424  
    ## groupedDXsvPPA              -0.3900     1.6614  -0.235   0.8144  
    ## ---
    ## Signif. codes:  0 '***' 0.001 '**' 0.01 '*' 0.05 '.' 0.1 ' ' 1 
    ## 
    ## Number of iterations in BFGS optimization: 13 
    ## Log-likelihood: -74.75 on 8 Df

``` r
zinfnegb<-zeroinfl(violations ~groupedDX, data = violcount, dist = "negbin")
summary(zinfnegb)
```

    ## 
    ## Call:
    ## zeroinfl(formula = violations ~ groupedDX, data = violcount, dist = "negbin")
    ## 
    ## Pearson residuals:
    ##     Min      1Q  Median      3Q     Max 
    ## -1.4225 -0.8778 -0.3556  0.4389  1.7781 
    ## 
    ## Count model coefficients (negbin with log link):
    ##                            Estimate Std. Error z value Pr(>|z|)    
    ## (Intercept)                 1.23592    0.23423   5.277 1.32e-07 ***
    ## groupedDXbvFTD              0.23307    0.32201   0.724   0.4692    
    ## groupedDXClinically Normal  0.45005    0.37403   1.203   0.2289    
    ## groupedDXsvPPA             -0.05522    0.37088  -0.149   0.8816    
    ## Log(theta)                  1.92808    0.96675   1.994   0.0461 *  
    ## 
    ## Zero-inflation model coefficients (binomial with logit link):
    ##                            Estimate Std. Error z value Pr(>|z|)
    ## (Intercept)                 -1.9161     1.1762  -1.629    0.103
    ## groupedDXbvFTD              -0.5348     1.8920  -0.283    0.777
    ## groupedDXClinically Normal   1.1655     1.4719   0.792    0.428
    ## groupedDXsvPPA              -0.5425     2.3555  -0.230    0.818
    ## ---
    ## Signif. codes:  0 '***' 0.001 '**' 0.01 '*' 0.05 '.' 0.1 ' ' 1 
    ## 
    ## Theta = 6.8763 
    ## Number of iterations in BFGS optimization: 16 
    ## Log-likelihood: -73.64 on 9 Df

``` r
p <- ggplot(violcount, aes(x=violations, y=n, colour=groupedDX)) + 
  geom_jitter() 

dat <- layer_data(p)
p + stat_smooth(data = violcount, aes(violations, n, colour=groupedDX), 
                method="glm", se=TRUE)
```

    ## `geom_smooth()` using formula 'y ~ x'

![](GARP_correctedPlots_files/figure-gfm/unnamed-chunk-21-1.png)<!-- -->
