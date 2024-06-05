-- SQL Data Cleaning Project
-- Dataset: https://www.kaggle.com/datasets/swaptr/layoffs-2022

-- Step 1: Create a staging table to work on and preserve the original data
CREATE TABLE world_layoffs.layoffs_staging LIKE world_layoffs.layoffs;

INSERT INTO world_layoffs.layoffs_staging
SELECT * FROM world_layoffs.layoffs;

-- Step 2: Remove duplicates
-- Identify duplicate records
WITH DELETE_CTE AS (
    SELECT company, location, industry, total_laid_off, percentage_laid_off, `date`, stage, country, funds_raised_millions, 
           ROW_NUMBER() OVER (PARTITION BY company, location, industry, total_laid_off, percentage_laid_off, `date`, stage, country, funds_raised_millions ORDER BY (SELECT NULL)) AS row_num
    FROM world_layoffs.layoffs_staging
)
-- Delete duplicate records
DELETE FROM world_layoffs.layoffs_staging
WHERE (company, location, industry, total_laid_off, percentage_laid_off, `date`, stage, country, funds_raised_millions, row_num) IN (
    SELECT company, location, industry, total_laid_off, percentage_laid_off, `date`, stage, country, funds_raised_millions, row_num
    FROM DELETE_CTE
) AND row_num > 1;

-- Step 3: Standardize data
-- Set empty strings to NULL for easier handling
UPDATE world_layoffs.layoffs_staging
SET industry = NULL
WHERE industry = '';

-- Populate NULL industry values based on other rows with the same company
UPDATE world_layoffs.layoffs_staging t1
JOIN world_layoffs.layoffs_staging t2
ON t1.company = t2.company
SET t1.industry = t2.industry
WHERE t1.industry IS NULL
AND t2.industry IS NOT NULL;

-- Standardize industry names to 'Crypto'
UPDATE world_layoffs.layoffs_staging
SET industry = 'Crypto'
WHERE industry IN ('Crypto Currency', 'CryptoCurrency');

-- Correct country names by removing trailing periods
UPDATE world_layoffs.layoffs_staging
SET country = TRIM(TRAILING '.' FROM country);

-- Convert date format to standard DATE type
UPDATE world_layoffs.layoffs_staging
SET `date` = STR_TO_DATE(`date`, '%m/%d/%Y');

ALTER TABLE world_layoffs.layoffs_staging
MODIFY COLUMN `date` DATE;

-- Step 4: Handle null values and remove unnecessary rows
-- Remove rows where both 'total_laid_off' and 'percentage_laid_off' are NULL
DELETE FROM world_layoffs.layoffs_staging
WHERE total_laid_off IS NULL
AND percentage_laid_off IS NULL;

-- Final check on the cleaned data
SELECT * 
FROM world_layoffs.layoffs_staging;
