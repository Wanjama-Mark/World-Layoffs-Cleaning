-- Cleaning Data


select *
from layoffs;

CREATE TABLE layoffs_staging
LIKE layoffs
;

select *
from layoffs_staging;

INSERT layoffs_staging
SELECT*
FROM layoffs;

select *,
ROW_NUMBER() OVER(
PARTITION BY company, industry, total_laid_off, percentage_laid_off,`date`) AS row_num
from layoffs_staging;


WITH duplicate_cte AS
(
select *,
ROW_NUMBER() OVER(
PARTITION BY company, location, industry, total_laid_off, percentage_laid_off,`date`,stage, country,funds_raised_millions) AS row_num
from layoffs_staging
)

SELECT *
FROM duplicate_cte
WHERE row_num > 1;

select *
from layoffs_staging
WHERE company = 'casper'
;

WITH duplicate_cte AS
(
select *,
ROW_NUMBER() OVER(
PARTITION BY company, location, industry, total_laid_off, percentage_laid_off,`date`,stage, country,funds_raised_millions) AS row_num
from layoffs_staging
)

DELETE
FROM duplicate_cte
WHERE row_num > 1;


CREATE TABLE `layoffs_staging2` (
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

select *
from layoffs_staging2
WHERE row_num > 1;


INSERT INTO layoffs_staging2
select *,
ROW_NUMBER() OVER(
PARTITION BY company, location, industry, total_laid_off, percentage_laid_off,`date`,stage, country,funds_raised_millions) AS row_num
from layoffs_staging;

DELETE 
from layoffs_staging2
WHERE row_num > 1;

select*
from layoffs_staging2
;




SET SQL_SAFE_UPDATES = 0;

-- Standardizing Data

select DISTINCT(company), TRIM(company)
from layoffs_staging2
;

UPDATE layoffs_staging2
SET company = TRIM(company);



select distinct industry
from layoffs_staging2
;

UPDATE  layoffs_staging2
SET industry ='Crypto'
WHERE industry LIKE 'Crypto%';

select distinct country, trim(TRAILING'.' FROM country)
from layoffs_staging2
order by 1
;

UPDATE  layoffs_staging2
SET country = trim(TRAILING'.' FROM country)
WHERE country LIKE 'United States%';


select `date`date
from layoffs_staging2
;

UPDATE layoffs_staging2
SET `date` = str_to_date(`date`, '%m/%d/%Y');


ALTER TABLE layoffs_staging2
MODIFY COLUMN `date` DATE;

SELECT *
from layoffs_staging2
WHERE total_laid_off IS NULL
AND percentage_laid_off IS NULL ;

UPDATE layoffs_staging2
set industry =null
where industry = '';

SELECT *
from layoffs_staging2
WHERE industry IS NULL
OR industry = '' ;

SELECT *
from layoffs_staging2
WHERE company like 'Bally%';

select t1.industry, t2.industry
from layoffs_staging2 t1
join layoffs_staging2 t2
on t1.company= t2.company
and t1.location = t2.location
where (t1.industry IS NULL or t1.industry = '')
and t2.industry is not null;


UPDATE layoffs_staging2 t1
join layoffs_staging2 t2
on t1.company= t2.company
set t1.industry = t2.industry
where (t1.industry IS NULL or t1.industry = '')
and t2.industry is not null;

select *
from layoffs_staging2;


SELECT *
from layoffs_staging2
WHERE total_laid_off IS NULL
AND percentage_laid_off IS NULL ;


delete
from layoffs_staging2
WHERE total_laid_off IS NULL
AND percentage_laid_off IS NULL ;

SELECT *
from layoffs_staging2;


alter table layoffs_staging2
drop column row_num;



SELECT *
from layoffs_staging2;
















