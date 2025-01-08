---
layout: page
title: UCSF Memory and Aging Center
permalink: /UCSFMAC/
position: 3
---
# Building a Comprehensive Dataset Management System at UCSF

Academic research data can be messy due to the high turnover among those collecting, organizing, and analyzing it. In the latter half of my time at UCSF, I was asked to improve this process for researchers, with the goal of making data usage less painful and more accessible (i.e., “democratizing” the process). Among the various objectives of the project, I'm particularly proud of creating a system that allows users to build a new dataset or augment an existing one. [Here's an interactive markdown of the code and process.](/assets/02_dataset_generation.html)

This system:

- Stores different versions of datasets and their source data
- Checks if incoming data matches an expected schema
- Logs changes made to the dataset(s)
- Provides an application where users can download only the instruments or columns they need from a wide-format dataset
- Includes a dynamic data dictionary that updates whenever new columns or instruments are added
- Everything in the dataset building process is versioned, and I trained researchers on how to use this tool and included documentation.

## Key Components of the Process

### Discovery of User Needs & Data Archaeology

- Explored a shared drive, organizational database, data collection sources, and older datasets
- Identified missing IDs and created a [tutorial](/assets/Qualtrics_distributions.html) for addressing the root cause 

### Collaboration with Users

- Defined each data point together and implemented the corresponding logic
- Quality Checks
  - Created a system that stores the expected dataframe schema and outputs any inconsistencies
  - Guided data owners through these inconsistencies with interactive examples and integrated corrected data
    
### Data Downloader Application and Data Dictionary

- Built a user-friendly tool for non-superusers to download data
  - [This is an example of the app](https://clayton-young.shinyapps.io/data_downloader/)
  - [Here's an example dataset](/assets/test_dataset_2023-10-23.csv) to upload and test. 

- [Living, Interactive Data Dictionary](/assets/04_data_dictionary.html)
  - Maintains up-to-date documentation as new columns or instruments emerge. Built with user input.

### Teaching 

- Illustrated the importance of version control and [created a GitHub basics tutorial](/assets/github_tutorial.nb.html)
- Hosted training sessions to teach researchers how to use the tooling I created, including video and written documentation:
  <object data="../assets/Dataset-Builder-Guide.pdf" width="1000" height="1000" type='application/pdf'></object>


## Explore the Tools
Full Dataset Builder Tutorial
- [Interactive markdown with most code](/assets/02_dataset_generation.html)


- Discovery of user needs and data archaeology
    - Combing through a shared drive, the org database, data collection sources, and prior datasets 
    - Identifying missing IDs
      - Addressed root cause, created and shared [tutorial](/assets/Qualtrics_distributions.html) for fixing this
- Collaboration with users in defining a datapoint and implementing this logic
- Quality checks-surfacing inconsistencies in the incoming data
  - Created a system that stores expected dataframe schema and outputs
  - Walked data owners through inconsitencies with interactive examples and integrated fixed data
- Built out a datadownloader application for non-superusers of the tool
- Built a living, interactive data dictionary
- Taught researchers the importance and [basics of version control](/assets/github_tutorial.nb.html)

  Here's the full dataset builder tutorial:



[link to the interactive markdown with most code](/assets/02_dataset_generation.html)

[And here is the data downloader application](https://clayton-young.shinyapps.io/data_downloader/)
  
I was given a list of instruments users of the data wanted which differed from the instruments found in the prior dataset. Tracking all of this down looked like this:








