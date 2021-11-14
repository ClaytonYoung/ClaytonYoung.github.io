---
title: Regression
---

# Goal Predictions

## Abstract

Utilizing the FBref website data, I landed on the idea of predicting the number of goals a player scores in a single Premier League season. Beyond individual player stats, I thought it'd also be interesting to scrape country GDP as a predictor since the PL is known for attracting players from across the world. Ultimately, I was left with only a handful of predictors that, when transformed, allowed the model to outcompete others with more variables.


## Design

My metric of interest is the number of non-penalty goals scored in a PL season. I decided upon non-penalty goals since it's a better representation of player skill and ability. I considered which variables available would accurately predict the number of goals a player scores in a season to target this metric. Aiming not to use predictor variables that had this answer within itself (e.g., conversion rate). I sought to use proxies for underlying characteristics (e.g., red cards for aggression). Additionally, I used player country data to see differences in player performance, as measured by the number of non-penalty goals scored, by country/region.


## Data

First, I scraped all PL league data from the inception of the league to the present. However, as my project question shifted, I began scraping player data for each season. This included four pages of data per season (1992-present), and in total, ~65 columns of data per player, per season, located inside a dictionary with a key representing the year. Filtering included selecting data from the 2017-2018 season to 2021. This was due to missing data from the previous seasons. Pulling from Wikipedia and YourDicitonary, I matched country abbreviations in FBRef to each player's data, and after matching country, I scraped GDP data and matched it to each player.

Although I was interested in county/continent and GDP and created an interaction variable, this proved detrimental to the model and was therefore dropped. Ultimately, I only kept 2091 rows and six columns for my entire dataset. The features kept were shots, position, team (also collapsed), and the interaction variable for positionXshots.

![image](/assets/Metis/Regression/interaction.png)

## Sources:
- FBRef
- YourDictionary
- Wikipedia

## Algorithms
- Web scraping links using Selenium from FBRef and saving links to list for further webscraping of dataframes
- Saving scraped dataframes to dictionary and appending to master dataframe
- Collapsing country, position, team data
- Feature engineering collapsed continent data to continentXGDP
- Feature engineering shotXposition data using engineered position data
- Engineering dummy variabels for linear regression using Pandas
- Transforming predictor and dependent variables using BoxCox transformation using sklearn
- Plotting interaction terms to verify different slopes using Seaborn
- Pairplotting using Seaborn to understand distrubutions of variables of interest
- linear modeling using statsmodels
- calculating cook's d to check influence of outliers (statsmodels)
- calculating VIF for independent variable correlations (statsmodels)
- cross validation(KFold) of basic linear, ridge, lasso, elastic net models
- averaging CV scores
- transforming to polynomial features
- plotting LARS path for lasso model
- scaling data for regularization
- calculating MSE and MAE
- plotting residuals, QQ plot

![image](/assets/Metis/Regression/qq.png)


## Findings

linear model with polynomial features outpeforms others:

- R^2: 0.788
- MSE: 2.020
- MAE: 0.871

- linear model not suited for this type of count-like (integer) data
- continent is not a good predictor of number of goals scored
- GDP is not a good predictor or number of goals scored

![image](/assets/Metis/Regression/scatter.png)

## Tools
- Selenium for web scraping
- request for static web scraping (opted for Selenium after)
- BeautfulSoup for formatting scraped data
- Pandas for data transformation
- pickle for storing data
- numpy for transformation (log didn't work too well for this data)
- matplotlib for plotting
- scipy stats for tranformation
- sklearn for modeling
- seaborn for plotting
