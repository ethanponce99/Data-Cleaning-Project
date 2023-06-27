SQL Data Cleaning Project (Audible Dataset)

Introduction

This repository contains the code and documentation for the data cleaning process of the Audible dataset. The goal of this project is to put in practice the knowledge acquired in SQL by cleaning the dataset which provides information about audiobooks available in that service.


Dataset Source and Overview

The Audible dataset used in this project was obtained from Kaggle.

The original Audible dataset contains 89K+ records of audiobook data. Each record represents a unique audiobook and includes various attributes such as name, author, narrator, language, release date, stars, and price.
Issues found in the data.

During the initial exploration and analysis of the audible dataset, several issues were identified including:
•	Special characters – There were several records displaying special characters instead of accents, making the record difficult to understand.
•	Inconsistent formatting - This was observed across different columns making it necessary to standardize the data for consistency. 


•	Tools Used
For the data cleaning project, the following tools were used:
Power Query to fix special characters problems.
SQL Server to do the remaining cleaning process.
•	Splitting columns.
•	Standardize data.
•	Extracting strings.
•	Modifying columns data types.
•	Creating columns with new data types to perform aggregations.


Data Cleaning Process
The data cleaning process involved the following steps:
1.	Data Understanding - The dataset was thoroughly examined to understand the structure, columns and their meanings.
2.	Data Exploration - Exploratory Data Analysis was performed to gain insights into the data, identify patterns and uncover anomalies.
3.	Handling special characters – My first approach to this problem was to use COALESCE function in SQL however this only works to remove accents, in this dataset the accents were replaced by special characters. The answer to this problem was to use Power Query, importing the data and then choosing UNICODE (UTF-8) in the process.
4.	Standardizing formatting - Inconsistent formatting issues, in column language UPPER and LOWER were used to standardize names, starting with Upper case and the rest in lower case. Column “time” had records indicating how long the audiobook was in hours and minutes, or only minutes. I decided to standardize this column by transforming all record to minutes, a combination of SUBSTRING AND PATINDEX was used to extract numbers only to then perform pertinent calculations.
5.	Extracting strings and splitting columns – A combination of SUBSTRING and CHARINDEX was used to extract the name in columns “author” and “narrator”, this was also implemented for stars column to separate stars from ratings to make further analysis and calculations easier.
6.	Validation and quality checks - The cleaned dataset went under rigorous validation to ensure the quality, accuracy, and integrity of the data.


Documentation

For detailed information about the data cleaning process, please refer to the SQL file provided in the repository. It contains step by step code and documentation showing each stage of the data cleaning process. 

You can also see both the uncleaned and cleaned version of the dataset.
