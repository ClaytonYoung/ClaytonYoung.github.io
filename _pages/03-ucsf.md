---
layout: page
title: UCSF Memory and Aging Center
permalink: /UCSFMAC/
position: 3
---

Academic research data is messy–this is a function of the high-turnover roles used to collect, organize, and analyze data. During the second half of my time at UCSF, I was brought in to make this process a little less painful for users of the data–I also wanted this process to be democratized. Out of the several goals during this project. 

I'm most proud of creating a system that users can use to build a new dataset or add on to an existing dataset. This stores versions of datasets and their source data, checks if the schema of incoming data is correct, and logs changes to the dataset(s). This also includes an application users can use to download specific instruments or columns from the wide format dataset. There's also a dictionary that's built and appended too if new cols or instruments are present. Every part of the dataset building is versioned. I trained researchers how to use this tool and documented all parts. 

There were different parts to this process:

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

  Here's the tutorial:

  <object data="../assets/Dataset-Builder-Guide.pdf" width="1000" height="1000" type='application/pdf'></object>
  
  
I was given a list of instruments users of the data wanted which differed from the instruments found in the prior dataset. Tracking all of this down looked like this:

[lol](/_pages/02_dataset_generation.html)






