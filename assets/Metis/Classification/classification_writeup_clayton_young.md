---
title: Dementia Classification
---

## Abstract
My goal with this project was to classify an individual's dementia status. Using data from UCSF's Memory and Aging Center, I pulled four different data sets, including demographics, clinical dementia rating, and two others containing neuropsych testing. The features I used in my final merged dataset was the Mini-Mental Status Exam data, age at testing, gender, handedness, and education. Using F2 as my performance metric, I was able to get hyperparameters from GridSearchCV for a Random Forest model that outperformed the rest, testing for a dementia status derived from a binarized clinical dementia rating (CDR) at a 0.5 threshold. I decided on F2 as the metric of model performance, emphasizing recall over precision since we'd want to minimize false negatives. 

## Design
Early diagnosis of dementia allows both the patient and their loved ones to prepare and seek treatment, extending their current quality of life. Neuropsychologists, Neurologists, and other healthcare providers work together to diagnose and formulate a treatment plan. Unfortunately, this is often an extensive, time-consuming process involving a plethora of tests. Thus, using the MMSE alongside the patient's demographic information to classify an individual's dementia status would save time and money. 



## Data
Starting with the four longitudinal datasets, each with 16,000-32,000 data points, I filtered down only those who had CDR score, demographic information, and a full MMSE test on file, ending with 4476 data points and 33 features, including the CDR score, which I binarized and used as the target feature. The MMSE data contained binary data and a total score, ranging from 0-30 as discrete values. 

## Algorithms
### Feature Engineering

- Binarizing CDR scores 0.5 and above as 1, indicating dementia
- Calculating age at testing 


## Models

kNN, Logistic Regression, Random Forest, XGBoost, Ensemble Validation, Stacking, and Naive Bayes were all assessed for their F2 score. I performed baseline tests will all features of interest and found that logistic regression performed the best. After using Grid/RandomizedSearchCV, I found hyperparameters for a Random Forest model that outperformed the rest. I also tried to use oversampling, smote, and weighing. However, these decreased model performance since my imbalance contained more individuals with the positive target feature (dementia). I also tried feature selection after looking at feature performance and found a slight decrease in F2. Hence, I went with the Random Forest model on the hyperparameters suggested by GridSearchCV. 

## Model Evaluation and Selection

I set aside 20% of my data for testing (900). Although I used Grid/RandomizedSearchCV to tune my models, I also set aside 25% of my training data (900 data points) for validation after Grid/RandomizedSearchCV. Across these sets, my Random Forest model obtained a training f2 score of 0.882, validation f2 of 0.874, and test validation f2 of 0.872. It also achieved the highest ROC AUC score at 0.856. 

## Tools


Numpy and Pandas for data manipulation
Scikit-learn for modeling
Matplotlib, Seaborn, Bokeh, and selenium for plotting
datatime for date features
mlxtend for stacking model
xgboost for boosted model
pickle for saving and reading files


![image](https://github.com/ClaytonYoung/ClaytonYoung.github.io/blob/master/assets/Metis/Classification/forest_confusion.png)
