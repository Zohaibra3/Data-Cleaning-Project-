# Data-Cleaning-Project-
Below is a simple and clear README file that explains the project for a common audience.

---

# Layoffs Data Cleaning Project

## Overview
This project involves cleaning and standardizing a dataset of global layoffs in 2022. The goal is to prepare the data for accurate analysis by addressing common data quality issues such as duplicates, inconsistent formatting, and missing values.

## Steps and Methods

### 1. Create a Staging Table
We start by creating a temporary copy of the original data to work on. This ensures the original dataset remains unchanged in case of any errors during the cleaning process.

### 2. Remove Duplicates
Duplicate records can distort analysis results. We identify and remove any duplicate entries in the dataset to ensure each record is unique.

### 3. Standardize Data
Data consistency is crucial for analysis. We standardize:
- **Industry Names**: Ensuring all variations of industry names are unified (e.g., all variations of 'Crypto' are standardized to 'Crypto').
- **Country Names**: Correcting inconsistencies such as trailing periods.
- **Dates**: Converting all dates to a standard format.

### 4. Handle Missing Values
Missing values can cause issues in analysis. We:
- Replace empty industry fields with NULL for easier handling.
- Populate NULL industry values based on other records with the same company name.

### 5. Remove Unnecessary Data
Rows with missing crucial information (like both 'total_laid_off' and 'percentage_laid_off' being NULL) are removed, as they do not provide useful data for analysis.

## Final Output
After cleaning, the dataset is reliable, consistent, and ready for detailed analysis. This project demonstrates essential data cleaning practices to enhance data quality.

## How to Use
1. **Clone the Repository**: 
   ```bash
   git clone Portfolio Project - Data Cleaning_Optimized_by_Zohaib.sql
   ```
2. **Navigate to the Directory**:
   ```bash
   cd layoffs-data-cleaning
   ```
3. **Run the SQL Script**: 
   Execute the SQL script provided in the repository using your preferred SQL environment (e.g., MySQL Workbench).

This project is a great example of how data cleaning can significantly improve the quality and usability of a dataset.

---
