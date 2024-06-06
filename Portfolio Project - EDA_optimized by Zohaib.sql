-- Explore the data in the layoffs_staging2 table
SELECT * 
FROM world_layoffs.layoffs_staging2;

-- Find the maximum number of layoffs in a single record
SELECT MAX(total_laid_off)
FROM world_layoffs.layoffs_staging2;

-- Analyze the percentage of layoffs
-- Find the maximum and minimum percentage of layoffs
SELECT MAX(percentage_laid_off), MIN(percentage_laid_off)
FROM world_layoffs.layoffs_staging2
WHERE percentage_laid_off IS NOT NULL;

-- Identify companies with 100% layoffs
SELECT *
FROM world_layoffs.layoffs_staging2
WHERE percentage_laid_off = 1;

-- Identify companies with 100% layoffs and sort them by funds raised
SELECT *
FROM world_layoffs.layoffs_staging2
WHERE percentage_laid_off = 1
ORDER BY funds_raised_millions DESC;

-- Top companies with the biggest single layoff events
SELECT company, total_laid_off
FROM world_layoffs.layoffs_staging2
ORDER BY total_laid_off DESC
LIMIT 5;

-- Companies with the most total layoffs across all records
SELECT company, SUM(total_laid_off) AS total_laid_off
FROM world_layoffs.layoffs_staging2
GROUP BY company
ORDER BY total_laid_off DESC
LIMIT 10;

-- Total layoffs by location
SELECT location, SUM(total_laid_off) AS total_laid_off
FROM world_layoffs.layoffs_staging2
GROUP BY location
ORDER BY total_laid_off DESC
LIMIT 10;

-- Total layoffs by country
SELECT country, SUM(total_laid_off) AS total_laid_off
FROM world_layoffs.layoffs_staging2
GROUP BY country
ORDER BY total_laid_off DESC;

-- Total layoffs per year
SELECT YEAR(date) AS year, SUM(total_laid_off) AS total_laid_off
FROM world_layoffs.layoffs_staging2
GROUP BY YEAR(date)
ORDER BY year ASC;

-- Total layoffs by industry
SELECT industry, SUM(total_laid_off) AS total_laid_off
FROM world_layoffs.layoffs_staging2
GROUP BY industry
ORDER BY total_laid_off DESC;

-- Total layoffs by company stage
SELECT stage, SUM(total_laid_off) AS total_laid_off
FROM world_layoffs.layoffs_staging2
GROUP BY stage
ORDER BY total_laid_off DESC;

-- Companies with the most layoffs per year
WITH Company_Year AS 
(
  SELECT company, YEAR(date) AS year, SUM(total_laid_off) AS total_laid_off
  FROM world_layoffs.layoffs_staging2
  GROUP BY company, YEAR(date)
),
Company_Year_Rank AS 
(
  SELECT company, year, total_laid_off, DENSE_RANK() OVER (PARTITION BY year ORDER BY total_laid_off DESC) AS ranking
  FROM Company_Year
)
SELECT company, year, total_laid_off, ranking
FROM Company_Year_Rank
WHERE ranking <= 3
ORDER BY year ASC, total_laid_off DESC;

-- Rolling total of layoffs per month
SELECT SUBSTRING(date, 1, 7) AS month, SUM(total_laid_off) AS total_laid_off
FROM world_layoffs.layoffs_staging2
GROUP BY month
ORDER BY month ASC;

-- Cumulative total of layoffs per month
WITH DATE_CTE AS 
(
  SELECT SUBSTRING(date, 1, 7) AS month, SUM(total_laid_off) AS total_laid_off
  FROM world_layoffs.layoffs_staging2
  GROUP BY month
  ORDER BY month ASC
)
SELECT month, SUM(total_laid_off) OVER (ORDER BY month ASC) AS rolling_total_layoffs
FROM DATE_CTE
ORDER BY month ASC;
