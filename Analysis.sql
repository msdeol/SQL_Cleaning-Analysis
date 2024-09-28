select *
from layoffs_stagging2;
--  we now have this cleaned data

select max(total_laid_off), max(percentage_laid_off)
from layoffs_stagging;
-- Lets take a look at the lay off where the percentage is 1 meaning everyone is gone 
-- proablly because the company got shut down 
select *
from layoffs_stagging2
where percentage_laid_off = 1
order by total_laid_off;

select *
from layoffs_stagging2
where percentage_laid_off = 1
order by funds_raised_millions desc;
-- lets see companies that may have add more then one round of layoffs
select company, sum(total_laid_off)
from layoffs_stagging2
group by company
order by 2 desc;
-- lets see which industry was hit the most 
select industry, sum(total_laid_off)
from layoffs_stagging2
group by industry
order by 2 desc;
-- how about country I think it should be the us
select country, sum(total_laid_off)
from layoffs_stagging2
group by country
order by 2 desc;
-- by far tyhe US was hit the hardest 
-- lets look at the dater range of the layoffs within this data
select min(`date`),min(`date`)
from layoffs_stagging2;

-- lets see per year how many lay offs there were 

select year(`date`), sum(total_laid_off)
from layoffs_stagging2
group by year(`date`)
order by 1 desc;

select stage, sum(total_laid_off)
from layoffs_stagging2
group by stage
order by 2 desc;

select substring(`date`,1,7) as `Month`, sum(total_laid_off)
from layoffs_stagging2
where substring(`date`,1,7) is not null
group by `Month`
order by 1;

with rolling_total as 
(
select substring(`date`,1,7) as `Month`, sum(total_laid_off) as total_off
from layoffs_stagging2
where substring(`date`,1,7) is not null
group by `Month`
order by 1
)
select `Month`, total_off,
sum(total_off) over(order by  `Month`)
from rolling_total;


select company, sum(total_laid_off)
from layoffs_stagging2
group by company
order by 2 desc;


select company,Year(`date`) ,sum(total_laid_off)
from layoffs_stagging2
group by company, year(`date`)
order by 3 desc;

with company_year (company, years,  total_laid_off) as
(
select company,Year(`date`) ,sum(total_laid_off)
from layoffs_stagging2
group by company, year(`date`)
), company_year_rank as (
select *, dense_rank() over (partition by years order by total_laid_off desc) as ranking
from company_year
where years is not null
) 
select *
from company_year_rank
where ranking <=5;

