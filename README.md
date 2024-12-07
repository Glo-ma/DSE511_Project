# DSE 511 Final Project

Welcome to the repository for the DSE 511 final project.

## Problem Description
This project focuses on predicting whether a student is experiencing depression or not. The implementation integrates multiple programming tools, including SQL, R, MATLAB, and Python, each contributing to different stages of the project. These stages include data preparation, analysis, Visualization, and modeling/prediction.

## Data
The dataset used in this project is the depression dataset from a kaggle competition.
The dataset contains 502 entries and 11 columns. 
Here's a summary of the columns:

* Gender: Categorical, with entries such as "Male" and "Female".
* Age: Numeric, representing the age of respondents.
* Academic Pressure: Numeric (float), likely a scale measuring pressure (e.g., 1–5).
* Study Satisfaction: Numeric (float), likely a scale measuring satisfaction (e.g., 1–5).
* Sleep Duration: Categorical, with values such as "7-8 hours", "5-6 hours", etc.
* Dietary Habits: Categorical, e.g., "Moderate", "Healthy", "Unhealthy".
* Have you ever had suicidal thoughts?: Categorical, with values "Yes" and "No".
* Study Hours: Numeric, representing daily study hours.
* Financial Stress: Numeric, representing stress levels (scale not specified).
* Family History of Mental Illness: Categorical, with values "Yes" and "No".
* Depression: Categorical, with values "Yes" and "No".

## Implementation Steps

## 1. Statistical/Exploratory Analysis (SQL)
Performed Statitical analysis using SQL queries to calculate descriptive statistics, identify missing values, and examine feature correlations to understand the dataset's structure and relationships.

## 2.  Visualization (R)
Created insightful visualizations, including correlation heatmaps, boxplots, and scatterplots, to analyze trends and relationships among features. Visualized the distribution of depression levels across various predictors.

![Gender](img/Rplots_Gender.png)


## 3. Data Cleaning and Preprocessing (Python)
Converted categorical variables (e.g., "Yes"/"No") to binary (0/1) for compatibility with models. Balanced the dataset using an autoencoder, ensuring fair representation of depression and non-depression cases.

## 4. Data Modeling and Prediction (MATLAB)
Implemented logistic regression (95% accuracy) and random forest (99% accuracy) classifiers. Generated confusion matrices, classification reports, and ROC curves for both models. Identified key features driving predictions through feature importance analysis.
  
