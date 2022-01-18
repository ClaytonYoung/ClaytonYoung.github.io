GBD Payment Range
================
Clayton Young
7/10/2020

``` r
library(tidyverse)
```

``` r
# setup datafolder target
if (Sys.info()["sysname"] == "Windows") {
    repofolder <- paste("C:/Users/", Sys.getenv("USERNAME"), "/decisionlab/GBD/tasks/GBDPaymentRange/",
        sep = "")
    datafolder <- "R:/groups/chiong/GBD/Data/Qualtrics/"
    rdrivepath <- "R:/"
} else if (Sys.info()["sysname"] == "Darwin") {
    # not sure why MacOS is 'Darwin' but it is...
    repofolder <- "~/decisionlab/GBD/tasks/GBDPaymentRange/"
    datafolder <- "/Volumes/macdata/groups/chiong/GBD/Data/Qualtrics/"
    rdrivepath <- "/Volumes/macdata/"
}  # probably good to add another condition for Unix, later on...
knitr::opts_chunk$set(echo = TRUE)
knitr::opts_knit$set(root.dir = datafolder)
# comment out (see root.dir above): setwd(datafolder)
```

\#few thing I did here–I created a csv based on the data in the
intertemp task from qualtrics because I couldn’t find a file with data
used to create the task.

``` r
IntertempDev<-read_csv("Intertemp_Qualtrics.csv")
```

    ## Rows: 104 Columns: 13

    ## ── Column specification ────────────────────────────────────────────────────────
    ## Delimiter: ","
    ## chr (4): option1, option2, time, want
    ## dbl (9): trial, idkA, idkB, idkC, idkD, idkE, idkF, idkG, idkH

    ## 
    ## ℹ Use `spec()` to retrieve the full column specification for this data.
    ## ℹ Specify the column types or set `show_col_types = FALSE` to quiet this message.

``` r
FELA<-read_csv(paste("FELA.csv"))[-c(2,3),]
```

    ## Rows: 172 Columns: 503

    ## ── Column specification ────────────────────────────────────────────────────────
    ## Delimiter: ","
    ## chr (503): StartDate, EndDate, Status, IPAddress, Progress, Duration (in sec...

    ## 
    ## ℹ Use `spec()` to retrieve the full column specification for this data.
    ## ℹ Specify the column types or set `show_col_types = FALSE` to quiet this message.

``` r
#from the options available in the task, this filters out any non number itmems
IntertempDev$option1<-(gsub("[^0-9.-]", "", IntertempDev$option1))
IntertempDev$option2<-(gsub("[^0-9.-]", "", IntertempDev$option2))

#create list with the min and max from both options
intertemRange<-c(max(as.numeric(IntertempDev$option1), na.rm=T),
                 max(as.numeric(IntertempDev$option2), na.rm=T),
                 min(as.numeric(IntertempDev$option1), na.rm=T),
                 min(as.numeric(IntertempDev$option2), na.rm=T))
#round range output to nearest 5 because this task can be paid in walmart or target 
#gift cards that have to be rounded




##Intertemp Payout Range
(IntertempRange<-(intertempAdd5<-range(intertemRange)+5))
```

    ## [1]  7.5 45.0

``` r
#Manual colculation based on the Loss Aversion task in qualtrics max and min 
#trial--rounded range calculated

LA<-c(16+9, 16-15, 16+12, 16-5, 16+6, 16-10, 16+24, 16-10)
#round(range(LA)/5)*5

#Framing effects max and min gathered from the qualtrics instrument 
FE<-c(0.40,20)
#round(range(FE)/5)*5

#total range of FE/LA task
(FELARange<-round(range(LA)/5)*5+round(range(FE)/5)*5)
```

    ## [1]  0 60

``` r
##manual calculation of max values for Dictator task Self and Other 
#min is always ZERO
dictMaxS<-c(24, 72, 28, 84, 60, 20, 36, 18, 15, 30, 15, 30, 10, 50, 90, 45, 33, 33, 66, 30)

dictMaxO<-c(72, 24, 84, 28, 20, 60, 18, 36, 15, 15, 30, 10, 30, 50, 45, 90, 66, 33, 33, 30)

(dictRange<-c(0, max(dictMaxS/3)+max(dictMaxO/3)))
```

    ## [1]  0 60
