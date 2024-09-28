
# Layoffs Data Analysis and Insights

## Overview

This project presents a comprehensive analysis of company layoffs, aiming to uncover trends, identify the most affected industries and countries, and understand the temporal distribution of layoffs. By meticulously cleaning and analyzing the dataset using SQL, we extract meaningful insights that highlight the economic impacts across various sectors.

## Dataset Description

The dataset comprises records of company layoffs with the following key attributes:

- **company**
- **location**
- **industry**
- **total_laid_off**
- **percentage_laid_off**
- **date**
- **stage**
- **country**
- **funds_raised_millions**

## Data Cleaning Process

To ensure the reliability and accuracy of the analysis, the data underwent a thorough cleaning process:

### 1. Removing Duplicates

- **Staging Table Creation**: Cloned the original data into a staging table (`layoffs_stagging2`) for safe manipulation.
- **Duplicate Identification**: Used `ROW_NUMBER()` with `PARTITION BY` on key columns to detect duplicates.
- **Duplicate Removal**: Deleted records where the `row_num` was greater than 1, effectively removing duplicates.

### 2. Standardizing Data

- **Company Names**: Trimmed extra spaces using `TRIM()` to ensure consistency.
- **Industry Names**: Unified variations (e.g., all variations of "Crypto" standardized to "Crypto").
- **Country Names**: Fixed inconsistencies like 'United States.' to 'United States' by trimming trailing periods.

### 3. Formatting Dates

- **Date Conversion**: Transformed date strings into proper `DATE` format using `STR_TO_DATE()`.
- **Data Type Alteration**: Changed the `date` column's data type from `TEXT` to `DATE` for accurate temporal analysis.

### 4. Handling Null and Blank Values

- **Industry Field**: Populated missing `industry` entries by referencing other records of the same company.
- **Irrelevant Records**: Removed entries where both `total_laid_off` and `percentage_laid_off` were null, as they didn't contribute meaningful information.

## Data Analysis

Utilizing SQL queries, the cleaned dataset was analyzed to extract actionable insights:

### Companies with 100% Layoffs

- **Objective**: Identify companies that laid off their entire workforce.
- **Method**: Selected records where `percentage_laid_off = 1`.
- **Insight**: These companies likely shut down or underwent complete restructuring.

### Multiple Layoff Rounds

- **Objective**: Find companies with multiple layoff events.
- **Method**: Aggregated `total_laid_off` by `company`.
- **Insight**: Highlighted companies facing prolonged financial difficulties.

### Industry Impact Assessment

- **Objective**: Determine which industries were most affected.
- **Method**: Summed `total_laid_off` grouped by `industry`.
- **Insight**: Revealed sectors under significant economic pressure.

### Country-wise Analysis

- **Objective**: Identify countries with the highest layoffs.
- **Method**: Calculated total layoffs per `country`.
- **Insight**: The United States was the most affected, indicating regional economic challenges.

### Temporal Trends

- **Objective**: Uncover patterns over time.
- **Method**: Analyzed layoffs by extracting `YEAR(date)` and `MONTH(date)`.
- **Insight**: Detected spikes corresponding to global economic events.

### Company Stage Analysis

- **Objective**: Assess layoffs based on company maturity.
- **Method**: Summed `total_laid_off` grouped by `stage`.
- **Insight**: Early-stage companies were more vulnerable to layoffs.

### Rolling Totals Over Time

- **Objective**: Visualize cumulative layoffs.
- **Method**: Computed rolling sums using window functions.
- **Insight**: Illustrated the progression and acceleration of layoffs over months.

### Top Companies Per Year

- **Objective**: Rank companies by layoffs annually.
- **Method**: Employed `DENSE_RANK()` to order companies per year based on `total_laid_off`.
- **Insight**: Identified the most impacted companies each year.

## Key Findings

- **Industries Most Affected**: Technology and Retail sectors experienced the highest layoffs.
- **Geographical Impact**: The United States led in total layoffs, highlighting significant economic stress.
- **Layoff Trends**: Significant increases in layoffs aligned with global economic downturns.
- **Company Vulnerability**: Startups and early-stage companies were more susceptible to large-scale layoffs.
- **Complete Workforce Reductions**: Some companies completely eliminated their workforce, indicating severe financial distress or operational shutdowns.

## Conclusion

Through meticulous data cleaning and in-depth analysis, this project sheds light on the profound effects of layoffs across different industries and regions. The insights gained not only highlight past economic challenges but also serve as a valuable resource for predicting and mitigating future impacts. Understanding these patterns is crucial for stakeholders, policymakers, and businesses aiming to navigate economic uncertainties effectively.

