-- Explaratory Data Analysis

select*
from layoffs_staging2;

select max(total_laid_off), max(percentage_laid_off)
from layoffs_staging2;

select*
from layoffs_staging2
where percentage_laid_off = 1
order by funds_raised_millions desc;


select company, max(total_laid_off)
from layoffs_staging2
group by company
order by 2 desc;

select min(`date`), max(`date`)
from layoffs_staging2
;

select industry, max(total_laid_off)
from layoffs_staging2
group by industry
order by 2 desc;


select country, sum(total_laid_off)
from layoffs_staging2
group by country
order by 2 desc;


select year (`date`), sum(total_laid_off)
from layoffs_staging2
group by year (`date`)
order by 1 desc;



select stage, sum(total_laid_off)
from layoffs_staging2
group by stage
order by 2 desc;

select company, sum(percentage_laid_off)
from layoffs_staging2
group by company
order by 2 desc;

SELECT substring(`date`,1,7) AS 'MONTH', sum(total_laid_off)
FROM layoffs_staging2
WHERE  substring(`date`,1,7) IS NOT NULL
group by `MONTH`
ORDER BY 1 ASC
;


WITH Rolling_Total AS
(SELECT substring(`date`,1,7) AS 'MONTH', sum(total_laid_off) as total_off
FROM layoffs_staging2
WHERE  substring(`date`,1,7) IS NOT NULL
group by `MONTH`
ORDER BY 1 ASC

)

select  `MONTH`, total_off
 ,sum(total_off)  over(ORDER BY `MONTH`) as rolling_total
from Rolling_Total;

select company, sum(percentage_laid_off)
from layoffs_staging2
group by company
order by 2 desc;

select company,YEAR(`date`), sum(total_laid_off)
from layoffs_staging2
group by company,YEAR(`date`)
order by 3 desc;

WITH Company_Year ( Company, years, total_laid_off) AS
(select company,YEAR(`date`), sum(total_laid_off)
from layoffs_staging2
group by company,YEAR(`date`)
),Company_Year_Rank AS
(SELECT *,
dense_rank() OVER(partition by years order by total_laid_off desc) as Ranking
FROM Company_Year
where years is not null
)

SELECT *
from Company_Year_Rank
where Ranking <= 5
;





























































