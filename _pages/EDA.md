
# MTA Food Truck Foot Traffic 

## Abstract
One of this dataset's strengths is our ability to see where and when people are entering and exiting each MTA station. Therefore, I thought to utilize this data to increase potential sales by capitalizing on exiting foot traffic on different days at different times. Specifically, I wanted to build a food truck stop schedule informed by finding the highest average exiting foot traffic by week, day, and hour in the Bronx. After cleaning my data and thinking about how best to approach this problem, I created plots for each day of the week that informed the schedule created for my client.

## Design
A Bronx-based food truck owner wants to increase potential sales by capitalizing on MTA turnstile data. The metric of interest is the exiting foot traffic in the Bronx (because, well, who wants to eat when they're on the subway?). Since the only restriction to Bronx mobile food vendors is only one street, my client can move about the Bronx freely, targeting any station to increase potential sales. We opted to use the median as our measure of central tendency to find which stations on each day during each time interval had the highest exiting foot traffic.

## Data
Using all data from the year 2021, we began with 6488049 rows of data and 12 columns. However, after selecting each of the 59 MTA stations located inside the Bronx, we were left with 543581 rows of data. We selected stations by a combination of station and line name due to two stations having the same station name. I corrected for line name being reversed for some Yankee Stadium station data. Turnstile combinations of C/A, UNIT, SCP, STATION, LINENAME were treated as unique turnstiles.
After calculating the central tendency for each station's turnstile per-hourly (~4) basis, the highest median was 272 mean (570). Due to the central tendencies and visualization, we set the counter limit to 5K per hourly data, per turnstile. Hourly exits were measured by subtracting a turnstile's exit data with the exit data that came immediately before. If the difference was negative, we took the absolute difference as the hourly exits. If the counter exceeded 5K, we set the hourly exits to whichever value (exits or previous exits) as the hourly exit. If the data were still above 5k, we set the exit to zero. Following this, we were left with 539912 rows × 13 columns. Looking at the unfiltered data, we saw that the hourly exits exceeding 5K were below .0007%.

## Algorithms
- Consolidating turnstiles to stations by summing hourly exits for each station, line, and date_time combination.
- Calculating the median hourly exits for each station for all of 2021.
- Calculating average hourly exits per week for each station.
- Calculating average hourly exits per day for each station.
- Indexing the station and line combination by the highest median hourly exits per day of the week and hour of day.
- Merging highest median hourly exits to station line combination with the highest hourly exits per day of the week and hour of day.
- Counting the number of times stations had the highest median hourly exits per day of the week and hour of day.
- Averaged the median hourly exits by weekday to come up with single plot to represent weekdays.
![image](/projects/python/EDA/images/dots.png)
![image](/projects/python/EDA/images/weekmean.png)


## Findings
- 3 AV-149 ST busiest station in the Bronx as measured by the median of hourly exits (973) for 2021.
- 3 AV-149 ST has the highest weekly average of hourly exits (981.09).
- 3 AV-149 ST has the highest weekly average of hourly exits (1164.88).
- Parkchester has the highest hourly average of hourly exits (1192.43).
- 3 AV-149 ST has the most number of highest median hourly exits (59) by each hour of each day of the week. Parkchester is second (45).
- During the weekdays, 3 AV-149 ST has an earlier busy peak, and Parkchester gets busier in the afternoon. Weekends follow a similar pattern.

## Tools
- DB Browser for SQLite for querying
- pandas for manipulation
- datetime to convert data into datetime and select days of week/hours
- matplotlib and seaborn for visualization


![image](/projects/python/EDA/images/EDA_calendar_Clayton_Young.png)


