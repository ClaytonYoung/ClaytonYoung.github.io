---
layout: page
title: Topic modeling r/CryptoCurrency
permalink: /metis/unsupervisednlp/
---

## Abstract

Having been around r/Wallstreetbets during the Gamestop saga, it was easy to find myself sucked into another subreddit while out sick during Thanksgiving break. Whether it's a fad or life-changing technology, I grew fascinated by the movement within the cryptocurrency sphere (cryptosphere?) and wanted to check it out.  Using Reddit's API and PRAW to gather all the comments and posts for October and November, I topic modeled some of the commonly mentioned cryptos and ran sentiment analysis using Vader and Deeopmoji. I found a few topics unique to some cryptos and found Algorand was pretty well-liked compared to others, at least for November. 

## Design

I gathered all data from October to December from r/CryptoCurrency and performed topic modeling for a few different cryptos to see what topics were discussed for each. To do this, I created a dictionary where keys are the names of cryptos and any comment that **only** mentions that crypto was saved to that key, allowing me to topic model and perform sentiment analysis for each crypto.

## Data

In total, I had over 2 million comments from Oct 1 to Dec 12. However, once I filtered out duplicate comments (bots or otherwise meaningless) and those without any votes (not popular, not representative), I was left with only a few thousand in total. From there, I created the dictionaries, saving the crypto's shorthand as the key and any comment that mentions only that crypto as a value inside the key. Initially, I performed preprocessing with NLTK and ran topic modeling with PCA; however, the results weren't as interesting as I would've liked. From there, I used spaCy to tag all nouns and adjectives, as these would be most relevant. I also combined the dfs in the dict together and created a count vectorizer which allowed me to find the most common words across *all* cryptos–these offered nothing to the topic modeling, so I added these to the stopwords, which contained all names of all cryptos (pulled from coinmarketcap using Selenium). Finally, I decided to keep only a few cryptos, in which comments ranged from ~3K to 20K+. 

## Sources:
- Reddit API
- coinmarketcap
- Deepmoji

## Algorithms
- Web scraping crypto names using Selenium from coinmarketcap
- Reddit API data collection
- Count vect, tfidf vect
- regex searching
- PCA/TSVD
- NLTK preprocessing
- Vader sentiment, deepmoji
- spaCy processing
- Emojiclouds
- PCA finding how many components to capture 80% variance
- others, I'm sure

## Findings

![image](/projects/python/NLP/images/topics.png)
- Based on sentiment, Algorand is a fan favorite. 


## Tools
- Selenium for web scraping
- BeautfulSoup for formatting scraped data
- Pandas for data transformation
- pickle for storing data
- numpy for transformation
- deepmoji sentiment analysis
- NLTK processing 
- sklearn for modeling
- contractions to remove contractions
- spaCy for parts of speech tagging
- vader for sentiment analysis
- praw for data collection
