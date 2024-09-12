select * from layoffs;
create table layoffs_stage1
like layoffs;



select * from layoffs_stage1;

#cleaning
# removing duplicates
select * , row_number() over( partition by  company, location, industry, total_laid_off, percentage_laid_off, 'date', stage, country, funds_raised_millions) 
as row_num
from layoffs_stage1;

with dup_cte as
(
select * , row_number() over( partition by  company, location, industry, total_laid_off, percentage_laid_off, 'date', stage, country, funds_raised_millions) 
as row_num
from layoffs_stage1
)select * from dup_cte
where row_num >1;

#create stage2 table
CREATE TABLE `layoffs_stage2` (
  `company` text,
  `location` text,
  `industry` text,
  `total_laid_off` int DEFAULT NULL,
  `percentage_laid_off` text,
  `date` text,
  `stage` text,
  `country` text,
  `funds_raised_millions` int DEFAULT NULL,
  `row_num` int
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
select * from layoffs_stage2;

insert into layoffs_stage2
select * , row_number() over( partition by  company, location, industry, total_laid_off, percentage_laid_off, 'date', stage, country, funds_raised_millions) 
as row_num
from layoffs_stage1;

select * from layoffs_stage2
where row_num>1;

delete from layoffs_stage2
where row_num >1;

#standard
select * from layoffs_stage2;

select distinct company , trim(company) from layoffs_stage2;

update layoffs_stage2
set company = trim(company);

select distinct industry from layoffs_stage2 
order by industry;

select distinct industry from layoffs_stage2 
where industry  like 'Cry%';

update layoffs_stage2
set industry = 'Crypto'
where industry like 'Cry%';

select * from layoffs_stage2;

select distinct country from layoffs_stage2 order by country;

update layoffs_stage2
set country = 'United States'
where country like 'United States%';

select * from layoffs_stage2;

select `date`,str_to_date(`date`, '%m/%d/%Y') from layoffs_stage2;

update layoffs_stage2
set `date`= str_to_date(`date`, '%m/%d/%Y') ;

alter table layoffs_stage2
modify column `date` date;

# now dealing with null and empty values

select distinct total_laid_off, percentage_laid_off from layoffs_stage2 
order by total_laid_off;

select * from layoffs_stage2
where total_laid_off is null and percentage_laid_off is null;

delete from layoffs_stage2
where total_laid_off is null and percentage_laid_off is null;

select * from layoffs_stage2;

update layoffs_stage2
set industry = null
where industry ='';



select t1.industry,t2.industry from layoffs_stage2 t1
join layoffs_stage2 t2
	on t1.company=t2.company
    and t1.location=t2.location
where t1.industry is null and t2.industry is not null;    

update layoffs_stage2 t1
join layoffs_stage2 t2
	on t1.company=t2.company
    and t1.location=t2.location
set t1.industry = t2.industry    
where t1.industry is null and t2.industry is not null;

select * from layoffs_stage2;

alter table layoffs_stage2
drop column row_num;











