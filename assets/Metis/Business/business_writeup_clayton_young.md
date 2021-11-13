---
title: Heart Disease Risk 
---

## Abstract

Heart disease is and has been the leading cause of death in the United States. Working with the [CDC's NHIS 2019 dataset](https://www.cdc.gov/nchs/nhis/2019nhis.htm), this project outlined demographic risk factors for heart disease as found in the [Tableau dashboard](https://public.tableau.com/views/cardiovascularhealthindicators/Nice?:language=en-US&:display_count=n&:origin=viz_share_link). Based on these findings, we propose the CDC partner with healthcare facilities to implement targeted interventions for those classified as high risk for poor cardiovascular health utilizing a decision tree model. 


## Design

Heart disease killed more than 600,000 people in the United States in 2019, once more remaining the lead cause of death. To address this longstanding issue, the CDC is taking a proactive approach in targeting individuals at high risk for poor cardiovascular health.

### Impact hypothesis

We hypothesize that interventions such as exercise and diet recommendations targeting those at high risk of poor cardiovascular health will decrease the number of heart disease-related deaths. 

**Primary impact:** Decrease heart disease-related deaths in the United States
**Secondary impact:** Improve overall health 


## Solution path

**Suggested:** Recommend targeted lifestyle changes for those classified as high risk using a decision tree segregating on:
- Age (65+)
- Sex
- BMI

**Other solution paths:**
- Recommend government subsidizes for programs known to benefit cardiovascular health

## Measures of success
**Technical:** Model accurately classifies individuals as high risk for poor cardiovascular health.  
**Non-technical:** Interventions recommended to those classified as high risk for poor cardiovascular health decrease the annual heart disease-related deaths by 1%. 

## Assumptions and risks
**Assumptions:** 
- Heart disease will remain the lead cause of death in the United States 
- There are demographic risk factors 

**Risks:**
- Other risk factors that aren’t in the dataset model will fail to account for
- High-risk groups may not be accounted for due to poor access to resources required in responding to NHIS and will therefore be unaccounted for in model. 
- Groups that have historically been subject to unethical treatment from governmental programs may be unlikely to respond to NHIS despite high risk for poor cardiovascular health and will therefore be unaccounted for in model. 
- Money spent on interventions is not guaranteed to improve cardiovascular health since lifestyle interventions cannot be implemented unwillingly. 

## Models
Using NHIS data, we'll build a tree model that'll classify individuals as at high risk for poor cardiovascular health based on the demographic features explored in this project. Since CDC doesn't have access to individual health data beyond the NHIS, models will need to be used at healthcare facilities for validation and testing, taking into account the region of the organization, as well as other factors seen to predict cardiovascular health. 

## Data
The 2019 NHIS dataset contains 31,997 data points with 534 features. A data dictionary describing the features included for the 2019 NHIS dataset can be found [here.](https://ftp.cdc.gov/pub/Health_Statistics/NCHS/Dataset_Documentation/NHIS/2019/adult-codebook.pdf) Features of interest included cardiovascular health and demographic features, such as age, poverty level, region, heart attack, etc.

## Algorithms
### Feature Engineering (Excel)
Because most NHIS data had been coded as numeric values that represented a category, those values were recoded to the text description in a sheet after filtering for columns of relevance/interest. We also collapsed the Angina, Heart Attack, Heart Disease, and High Cholesterol variables into a single variable representing overall cardiovascular health. This was used as the variable of interest moving forward. 

### Analysis (Excel and Tableau)
This data represented the uneven population sizes in the United States. Thus, we could not compare which groups made up a majority of those with poor cardiovascular health as this would've misrepresented what features contribute to a person being at risk. For example, since there's a larger sample of Non-Hispanic Whites in the dataset, we cannot conclude that Non-Hispanic Whites have higher rates of poor cardiovascular health by looking at the proportion of Non-Hispanic Whites in the total number of those with poor cardiovascular health. So instead, a better measure of demographic differences was used–we looked at the proportion of those with poor cardiovascular health *within* a feature of interest. 

Using the method above, we found that in the NHIS data, 57% of individuals over the age of 65 have poor cardiovascular health. Males also have higher rates, and there's a larger proportion of poor cardiovascular health at younger ages for high BMI groups. Although multiple aggregations were used, the ones kept in the dashboard include Age, Cardiovascular Health, Sex, Race, Region. 

## Tools

- Excel for data cleaning, feature engineering, and preliminary analysis
- Tableau for interactive visualizations


<iframe src="https://public.tableau.com/views/cardiovascularhealthindicators/Nice?:language=en-US&:display_count=n&:origin=viz_share_link" width = '650' height = '450'></iframe>
