SELECT * 
FROM layoffs_stage2;

#max layoffs

select max(total_laid_off) from layoffs_stage2;

#max and min percent of layoffs

select max(percentage_laid_off), min(percentage_laid_off)
from layoffs_stage2;

#findings the companies who went full layoffs of their employees
select company from layoffs_stage2
where percentage_laid_off =1;
-- these are mostly startups it looks like who all went out of business during this time

#now lets find who have more fundings who fired their whole employess
select company, funds_raised_millions from layoffs_stage2
where percentage_laid_off=1
order by funds_raised_millions desc;
#'Britishvolt' they raised 2.4 billions 

#now just see comapanies who laidoff their employess
select company,total_laid_off
from layoffs_stage2
order by total_laid_off desc;
# its just on single day

#now lets find by totla layoffs
select company, sum(total_laid_off) total
from layoffs_stage2
group by company
order by total desc;

# now lets check with country 
select country, sum(total_laid_off) total
from layoffs_stage2
group by country
order by total desc;

#now lets check with location
select location, sum(total_laid_off) total
from layoffs_stage2
group by location
order by total desc;

#now lets see what year had most layoffs
select year(date), sum(total_laid_off) total
from layoffs_stage2
group by year(date)
order by total desc;

#now see per month
select month(date), sum(total_laid_off) total
from layoffs_stage2
group by month(date)
order by total desc;
#nan this shows whole month of different year lets try different

select substring(date,1,7), sum(total_laid_off) total
from layoffs_stage2
group by substring(date,1,7)
order by total desc;

#now see industry who has most layoffs
select industry, sum(total_laid_off) total
from layoffs_stage2
group by industry
order by total desc;

#lets see company year wise layoffs and rank them
WITH Company_Year AS 
(
  SELECT company, YEAR(date) AS years, SUM(total_laid_off) AS total_laid_off
  FROM layoffs_stage2
  GROUP BY company, YEAR(date)
)
, Company_Year_Rank AS (
  SELECT company, years, total_laid_off, DENSE_RANK() OVER (PARTITION BY years ORDER BY total_laid_off DESC) AS ranking
  FROM Company_Year
)
SELECT company, years, total_laid_off, ranking
FROM Company_Year_Rank
WHERE ranking <= 3
AND years IS NOT NULL
ORDER BY years ASC, total_laid_off DESC;

# I think what i explored what comes into my mind lets wrap it 

