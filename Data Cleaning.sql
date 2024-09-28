-- Data Cleaning
SET SQL_SAFE_UPDATES = 0;
-- Take a look at the data using a generic select statment
Select *
from layoffs;

-- remove any duplicates if it has any 
-- sandardize data 
-- look at null or blank values (What to do with them )
-- remove any any uncessary cclomumns (Working with large data we can get rid of some extra data)

-- if unsure as to if you want to remove data you can make a copy of it like below for stagging and then decide
create table layoffs_stagging
like layoffs;

-- lets see how the table is like now
select *
from layoffs_stagging;

-- its empty so we need to insert the data into as such 
Insert layoffs_stagging
select * 
from layoffs;
-- at this point both tables should look the same
-- we are doing this to get the unique row numbers based on the rows in the over
select *,
row_number() over(Partition By company,industry,total_laid_off,'date') as row_num
from layoffs_stagging;

-- we can save this query as a CTE for future use 
with dup_cte as (
select *,
row_number() over(Partition By company,location,
industry, total_laid_off ,percentage_laid_off,'date', stage, country,funds_raised_millions) as row_num
from layoffs_stagging
)
select *
from dup_cte
where row_num > 1;

-- We can see that this CTE needs to have all the rows in order to properly work
select *
from layoffs_stagging
where company ='Oda';
select *
from layoffs_stagging0
where company ='Casper';
-- update CCTE to  have all the rows
-- CTE cant be used to delete a table. So we are going to have to create another copy of the table 
CREATE TABLE `layoffs_stagging2` (
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

-- once we have created this table we can now intert the data from the CTE into this table which we can now manilulate
insert into layoffs_stagging2
select *,
row_number() over(Partition By company,location,
industry, total_laid_off ,percentage_laid_off,'date', stage, country,funds_raised_millions) as row_num
from layoffs_stagging;
-- now that we have the table data lets see if it worked
select * 
from layoffs_stagging2;
-- it did so now lets the dup rows
select *
from layoffs_stagging2
where row_num > 1;
-- Now that we can see that the rows that are updes lets delete the 
delete
from layoffs_stagging2
where row_num > 1;
-- run the select again to verify the delete happened
select *
from layoffs_stagging2
where row_num > 1;
-- there are none


-- SO nows lets move onto standardizing the data. So lets take a look at the companu column 
select distinct( company )
from layoffs_stagging2;
-- there is a exyta spacce in the company so just to confirm lets view the comapny and a trimmed version side by side
select company, trim(company)
from layoffs_stagging2;
-- so in order to fix it lets update the column. 
update layoffs_stagging2
set company = trim(company);
-- lets view the result
select *
from layoffs_stagging2;
-- let take a look at the other columns 
select  distinct industry 
from layoffs_stagging2
 order by 1;
-- There are some empty onnes and some whichc are the same but with slight varitions
-- when we do anlysis down the line they need to be grouped together so lets take care of that (Note only crypto is the one thta has more than one varation)
-- before we procced lets see what all the columns for all crypto varations
select distinct industry
from layoffs_stagging2
where industry like 'Crypto%';
-- lets ypdate all of these varitions to just be crypto
update layoffs_stagging2
set industry = 'Crypto'
where industry like 'Crypto%';
-- now at this poing it has been updated. Lets take a look at location now
select distinct location 
from layoffs_stagging2
order by 1;
-- this looks all good not lets move onto country

select distinct country 
from layoffs_stagging2
order by 1;
-- We can see that there are two varations of UNited States so lets take care of it
Select distinct country, trim(trailing '.' from country) as fixedversion
from layoffs_stagging2
order by 1;
-- this fixes the issue. We used trailing to find the . from contry and trim it to fix any contries with smilar issues to US one
-- Now lets update it
update layoffs_stagging2
set country = trim(trailing '.' from country)
where country like 'United States%';
-- this has not been updated 
-- Date looks good but when we imported it it was set to text. If we want to any alaysis with it we are going to need to change it
select `date`
from layoffs_stagging2;

select `date`,
str_to_date(`date`,'%m/%d/%Y')
from layoffs_stagging2;
-- now that we see that this is how the date should as non text
update layoffs_stagging2
set `date` = str_to_date(`date`,'%m/%d/%Y');

select `date`
from layoffs_stagging2;
-- now that the format is good lets change column from text to date

Alter table layoffs_stagging2
modify column `date` DATE;
-- Now we need to take care of null and blank values 
-- lets take a look at the null colmns using a select statment 
Select *
from layoffs_stagging2
where total_laid_off is null
and percentage_laid_off is null;

select *
from layoffs_stagging2
where industry is null or industry = '';
-- after runningn we ccan see that some of the industry are empty lets see if there are other rows that have data for the same ccompany
select *
from layoffs_stagging2
where company ='Airbnb';
-- we can see we have two rows for airbob and trhe industry is travel so we can populate the industry 
select * 
from layoffs_stagging2 t1
join layoffs_stagging2 t2
	on t1.company = t2.company
Where (t1.industry is null or t1.industry = '')
and t2.industry is not null;
-- with this select we can see that each one of the ccompanies that are in table have a industry that is empty and one that is not for the same 
-- so we can just update it
-- before we update it lets make sur we take care of the blanks so it only takes info from the poulaed industries
update layoffs_stagging2
set industry = null
where industry = '';

update layoffs_stagging2 t1
join layoffs_stagging2 t2
	on t1.company = t2.company
set t1.industry = t2.industry 
where t1.industry is null
and t2.industry is not null;
-- airbnb does not have a blank industry row any more
select *
from layoffs_stagging2
where company like 'Bally%';
-- there is just one row where the industry is null but it did  not cchange beccause there is no second row
-- for the rows where the total or preccentagt laid off is null lets ingore. Lets fouccus on the rows where both are null
select *
from layoffs_stagging2 
where total_laid_off is null
and percentage_laid_off is null;
-- lets get rid of it since I dont think we need this information 

delete
from layoffs_stagging2 
where total_laid_off is null
and percentage_laid_off is null;
-- Now that we are done we can remove the row_num ccoumn as for the anlysis part it is not needed and we dont have dupes 
-- anymore 
alter table layoffs_stagging2
drop column row_num;
