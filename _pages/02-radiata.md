---
layout: page
title: Radiata
permalink: /radiata/
position: 02
---

<a href="https://radiata.ai/" target="_blank" rel="noopener noreferrer">Introducing our brain biomarker engine.</a> By uploading neuroimaging data to our platform, users benefit from our advanced pipelines that format and harmonize their data with our extensive curated sources. This process boosts the effectiveness of the models users build in real-time. 

As part of a two-person team, I was responsible for several critical aspects of our platform's development and deployment:

## Application Containerization & Deployment

#### Containerization: 

- Utilized Docker to containerize the application, ensuring consistency across development and production environments.

#### AWS Deployment: 
- Deployed the containerized application to AWS Elastic Container Service (ECS), enabling scalable and reliable infrastructure management.

## Database Management

#### PostgreSQL Setup: 
- Configured and managed the PostgreSQL database, optimizing it for performance and reliability to handle complex neuroimaging data.

## CI/CD Pipeline Implementation

#### Automation: 
- Established a robust Continuous Integration/Continuous Deployment (CI/CD) pipeline using GitHub Actions, streamlining the development process and facilitating rapid deployments.

## Authentication & Security
#### User Login & Authentication: 

- Implemented django-allauth user authentication systems, ensuring that user data is protected and access is properly managed.

## Full-Stack Development Enhancements

#### Frontend Tweaks: 

- Improved the user interface and user experience through various frontend optimizations, making the platform more intuitive and responsive. Set up data upload functionality and formatted the about page using Tailwind CSS and React.js.

#### Backend Tweaks: 

- Enhanced backend functionalities to support better data processing and integration with curated datasets, contributing to the overall performance of the biomarker engine. Managed backend and frontend communication by serving presigned URLs, logging user uploads & logins, and handling model querying. Configured the Django Admin panel to modify and monitor data and user access.

## Machine Learning & Data Management

#### Data Conversion: 

- Converted CSV and TXT files to PostgreSQL tables and Parquet files stored in Amazon S3.

## Infrastructure & Networking

#### AWS Route 53: 
- Set up Route 53 for domain management.

#### Load Balancer: 
- Configured a load balancer to manage API calls efficiently.

#### NAT Gateway: 
- Implemented a NAT Gateway to prevent direct public access to subnets.

#### Bastion Host: 
- Established a bastion host to securely access the private RDS database locally using a PGAdmin Docker image.

## Key Achievements
#### Scalable Infrastructure: 
- Successfully deployed a scalable application infrastructure on AWS ECS, accommodating growing user demands and ensuring high availability.

#### Enhanced Data Processing: 
- Streamlined data formatting and harmonization processes, resulting in improved model performance and user satisfaction.

#### Automated Deployments: 
- Reduced deployment times and minimized errors through the implementation of an efficient CI/CD pipeline.

## Technical Skills Utilized

#### Containerization & Orchestration: 
- Docker, AWS ECS

#### Cloud Services: 
- Amazon Web Services (AWS) including Route 53, Load Balancer, NAT Gateway

#### Databases: 
- PostgreSQL, Amazon RDS

#### CI/CD Tools: 
- GitHub Actions

#### Authentication:
- django-allauth

#### Frontend Technologies: 
- React.js, Tailwind CSS

#### Backend Technologies: 
- Django, Python

#### Data Management: 
- Amazon S3, Parquet, PGAdmin
