---
layout: page
title: UCSF Memory and Aging Center
permalink: /UCSFMAC/
position: 3
---
# Building a Comprehensive Dataset Management System at UCSF

Academic research data can be messy due to the high turnover among those collecting, organizing, and analyzing it. In the latter half of my time at UCSF, I was asked to improve this process for researchers, with the goal of making data usage less painful and more accessible (i.e., “democratizing” the process). Among the various objectives of the project, I'm particularly proud of creating a system that allows users to build a new dataset or augment an existing one. 

[Here's an interactive markdown of the code and process.](/assets/02_dataset_generation.html)

This system:

- Stores different versions of datasets and their source data
- Checks if incoming data matches an expected schema
- Logs changes made to the dataset(s)
- Provides an application where users can download only the instruments or columns they need from a wide-format dataset
- Includes a dynamic data dictionary that updates whenever new columns or instruments are added

## Key Components of the Process

### Discovery of User Needs & Data Archaeology

- Explored a shared drive, organizational database, data collection sources, and older datasets
- Identified missing IDs and created a [tutorial](/assets/Qualtrics_distributions.html) for addressing the root cause 

### Collaboration with Users

- Defined each data point together and implemented the corresponding logic
- [Living, Interactive Data Dictionary](/assets/04_data_dictionary.html)
  - Maintains up-to-date documentation as new columns or instruments emerge.

### Quality Checks System
  - Stores the expected dataframe schema and outputs any incoming data inconsistencies
  - Compares new and existing values, with options to keep or overwrite
  - Versions incoming data, instrument level data (new and existing), and final datasets
  - Guided data owners through these inconsistencies with interactive examples and integrated corrected data
    
### Data Downloader Application and Data Dictionary

- Built a user-friendly tool for non-superusers to download data
  - [This is an example of the app](https://clayton-young.shinyapps.io/data_downloader/)
  - [Here's an example dataset](/assets/test_dataset_2023-10-23.csv) to upload and test. 

### Teaching 

- Illustrated the importance of version control and [created a GitHub basics tutorial](/assets/github_tutorial.nb.html)
- Hosted training sessions to teach researchers how to use the tooling I created, including video and written documentation:
  <object data="../assets/Dataset-Builder-Guide.pdf" width="1000" height="1000" type='application/pdf'></object>





