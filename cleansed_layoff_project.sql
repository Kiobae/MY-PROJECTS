-- Data cleaning project --

-- Removed duplicates
-- standardize the data
-- null values or blank values
-- remove any columns


-- FIRST [REMOVE DUPLICATES]

SELECT*
FROM layoffs
;

CREATE TABLE cleansed_layoffs
LIKE layoffs
;

SELECT *
FROM cleansed_layoffs
;

INSERT INTO cleansed_layoffs
SELECT *
FROM layoffs
;

SELECT *
FROM cleansed_layoffs
;

-- create a defining facor

SELECT *, row_number() OVER(PARTITION BY company, location, industry, total_laid_off, percentage_laid_off, `date`, stage, country, funds_raised_millions) AS row_num
FROM cleansed_layoffs
;

WITH defining_fact AS
(SELECT *, row_number() OVER(PARTITION BY company, location, industry, total_laid_off, percentage_laid_off, `date`, stage, country, funds_raised_millions) AS row_num
FROM cleansed_layoffs)
select *
FROM defining_fact
WHERE row_num > 1
;

-- creating a new table to delete duplicaes

CREATE TABLE `cleansed_layoffs2` (
  `company` text,
  `location` text,
  `industry` text,
  `total_laid_off` int DEFAULT NULL,
  `percentage_laid_off` text,
  `date` text,
  `stage` text,
  `country` text,
  `funds_raised_millions` int DEFAULT NULL,
  `row_num` INT
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

SELECT*
FROM cleansed_layoffs2
;

INSERT INTO cleansed_layoffs2
SELECT *, row_number() OVER(PARTITION BY company, location, industry, total_laid_off, percentage_laid_off, `date`, stage, country, funds_raised_millions) AS row_num
FROM cleansed_layoffs
;

-- DELETING THE DUPLICATES

DELETE 
FROM cleansed_layoffs2
WHERE row_num > 1
;

SELECT *
FROM cleansed_layoffs2
WHERE row_num > 1
;

-- STANDORNIZE THE DATA

SELECT*
FROM cleansed_layoffs2
;

SELECT DISTINCT(country)
FROM cleansed_layoffs2
ORDER BY 1 desc
;

SELECT DISTINCT(country), TRIM(country)
FROM cleansed_layoffs2
order by 1 desc
;

UPDATE cleansed_layoffs2
SET country = TRIM(country)
;

UPDATE cleansed_layoffs2
SET country = TRIM(trailing '.' FROM country)
WHERE country LIKE 'United States%' 
;

SELECT DISTINCT(industry)
FROM cleansed_layoffs2
ORDER BY 1 desc
;

UPDATE cleansed_layoffs2
SET industry = 'Crypto'
WHERE industry LIKE '%Crypto%'
;

SELECT `date`
FROM cleansed_layoffs2
;

UPDATE cleansed_layoffs2
SET `date` = str_to_date(`date`,'%m/%d/%Y')
;

ALTER TABLE cleansed_layoffs2
MODIFY COLUMN `date` date
;

-- TAKING CARE OF NULL VALUES & BLANK VALUES

SELECT*
FROM cleansed_layoffs2
;

SELECT *
fROM cleansed_layoffs2
WHERE industry IS NULL
	OR industry =  ''
;

SELECT *
FROM cleansed_layoffs2
WHERE company = 'airbnb'
;


UPDATE cleansed_layoffs2 
SET industry = NULL
WHERE industry = ''
;

UPDATE cleansed_layoffs2 t1
JOIN cleansed_layoffs2 t2
	ON t1.company = t2.company
SET T1.industry = t2.industry
WHERE t1.industry IS NULL
AND t2.industry IS NOT NULL
;

SELECT *
FROM cleansed_layoffs2
WHERE total_laid_off IS NULL
AND percentage_laid_off IS NULL
;

DELETE 
FROM cleansed_layoffs2
WHERE total_laid_off IS NULL
AND percentage_laid_off IS NULL
;

SELECT *
FROM cleansed_layoffs2
;


-- REMOVE ANY COLUMNS

ALTER TABLE cleansed_layoffs2
DROP COLUMN row_num
;

SELECT *
FROM cleansed_layoffs2
;

-- OVER VIEW

#starting table
SELECT*
FROM layoffs
;

#cleansed table
SELECT*
FROM cleansed_layoffs2
;
