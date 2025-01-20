-- ---------------------------- BANK LOAN PROBLEM STATEMENT EXPLORATORY DATA ANALISIS ----------------------------
-- Bank loans from year 2021
-- MoM: Month over month
-- MTD: Month to date


-- 1. TOTAL LOAN APPLICATIONS
-- Total applications recived
select count(*) Total_Applications
from bank_loan; -- 38,576

-- MTD total applications
select count(*) December_total_apls
from bank_loan
where month(issue_date) = 12; -- 4,314 (MTD)

-- Previous MTD total applications
select count(*) November_total_apls
from bank_loan
where month(issue_date) = 11; -- 4,035 (Previous MTD)

-- MoM total loan applications change
WITH monthly_totals AS (
    SELECT 	YEAR(issue_date) AS year,
			MONTH(issue_date) AS month,
            count(*) AS Total_apls
    FROM bank_loan
    GROUP BY YEAR(issue_date), MONTH(issue_date)
), MoM_diff AS (
    SELECT year, month, Total_apls, 
    LAG(Total_apls) OVER (ORDER BY year, month) AS previous_month_applications
    FROM monthly_totals
)
SELECT Year, Month, Total_apls, Previous_month_applications, (Total_apls - previous_month_applications) AS MoM_apls_change
FROM MoM_diff;


-- 2. TOTAL FUNDED AMOUNT
-- Total amount of founds
select sum(loan_amount) Total_amount_funded
from bank_loan; -- $435,757,075

-- MTD total amount funded
select sum(loan_amount) December_amount_funded
from bank_loan
where month(issue_date) = 12; -- $53,981,425 (MTD)

-- Previous MTD total amount funded
select sum(loan_amount) November_amount_funded
from bank_loan
where month(issue_date) = 11; -- $47,754,825 (Previous MTD)

-- MoM funded amount change
WITH monthly_totals AS (
    SELECT YEAR(issue_date) AS year, MONTH(issue_date) AS month, SUM(loan_amount) AS total_funded
    FROM bank_loan
    GROUP BY YEAR(issue_date), MONTH(issue_date)
), MoM_diff AS (
    SELECT year, month, total_funded, 
    LAG(total_funded) OVER (ORDER BY year, month) AS previous_month_funded
    FROM monthly_totals
)
SELECT Year, Month, Total_funded, Previous_month_funded, (total_funded - previous_month_funded) AS MoM_difference
FROM MoM_diff;


-- 3. TOTAL AMOUNT RECEIVED
-- Total amount received
select sum(total_payment) Total_amount_received
from bank_loan; -- $473,070,933

-- MTD total amount received
select sum(total_payment) December_amount_received
from bank_loan
where month(issue_date) = 12; -- $58,074,380 (MTD)

-- Previous MTD total amount received
select sum(total_payment) November_amount_received
from bank_loan
where month(issue_date) = 11; -- $50,132,030 (Previous MTD)

-- MoM amount received change
WITH monthly_totals AS (
    SELECT YEAR(issue_date) AS year, MONTH(issue_date) AS month, SUM(total_payment) AS total_received
    FROM bank_loan
    GROUP BY YEAR(issue_date), MONTH(issue_date)
), MoM_diff AS (
    SELECT year, month, total_received, 
    LAG(total_received) OVER (ORDER BY year, month) AS previous_month_received
    FROM monthly_totals
)
SELECT Year, Month, Total_received, Previous_month_received, (total_received - previous_month_received) AS MoM_difference
FROM MoM_diff;


-- 4. AVERAGE INTEREST RATE
-- Avg interest rate on loans
select round(AVG(int_rate)*100,2) Avg_interest_rate
from bank_loan; -- 12.05%

-- Avg MTD interest rate
select round(AVG(int_rate)*100,2) December_AVG_interest_rate
from bank_loan
where month(issue_date) = 12; -- 12.36% (MTD)

-- Previous Avg MTD interest date
select round(AVG(int_rate)*100,2) November_AVG_interest_date
from bank_loan
where month(issue_date) = 11; -- 11.94% (Previous MTD)

-- MoM avg interest rate
WITH monthly_totals AS (
    SELECT YEAR(issue_date) AS year, MONTH(issue_date) AS month, round(AVG(int_rate)*100,2) AS AVG_int_rate
    FROM bank_loan
    GROUP BY YEAR(issue_date), MONTH(issue_date)
), MoM_diff AS (
    SELECT year, month, AVG_int_rate, 
    LAG(AVG_int_rate) OVER (ORDER BY year, month) AS previous_month_AVG_int_rate
    FROM monthly_totals
)
SELECT Year, Month, AVG_int_rate, Previous_month_AVG_int_rate, round((AVG_int_rate - previous_month_AVG_int_rate),4) AS MoM_difference
FROM MoM_diff;


-- 5. AVERAGE DEBT-TO-INCOME RATIO (DTI)
-- Avg DTI
select round(AVG(dti)*100,2) Avg_DTI
from bank_loan; -- 13.33%

-- Avg MTD DTI
select round(AVG(dti)*100,2) December_Avg_DTI
from bank_loan
where month(issue_date) = 12; -- 13.67% (MTD)

-- Avg Previous MTD DTI
select round(AVG(dti)*100,2) November_Avg_DTI
from bank_loan
where month(issue_date) = 11; -- 13.30% (Previous MTD)

-- MoM avg DTI
WITH monthly_totals AS (
    SELECT YEAR(issue_date) AS year, MONTH(issue_date) AS month, round(AVG(dti)*100,2) AS AVG_DTI
    FROM bank_loan
    GROUP BY YEAR(issue_date), MONTH(issue_date)
), MoM_diff AS (
    SELECT year, month, AVG_DTI, 
    LAG(AVG_DTI) OVER (ORDER BY year, month) AS previous_month_AVG_DTI
    FROM monthly_totals
)
SELECT Year, Month, AVG_DTI, Previous_month_AVG_DTI, round((AVG_DTI - previous_month_AVG_DTI),4) AS MoM_difference
FROM MoM_diff;



-- GOOD LOAN KPIS
-- Good Loan Application Percentage
SELECT 
    ROUND((COUNT(CASE WHEN loan_status IN ('Fully Paid', 'Current') THEN 1 END) * 100.0 / COUNT(*)),2) AS `Good_loan_percenatge (%)`
FROM bank_loan; -- 86.18%

-- Good Loan Applications
SELECT COUNT(*) Good_loan_applications
FROM bank_loan
WHERE loan_status IN ('Fully Paid', 'Current'); -- 33,243

-- Good Loan Funded Amount
SELECT SUM(loan_amount) Good_loan_funded_amount
FROM bank_loan
WHERE loan_status = 'Fully Paid' OR loan_status = 'Current'; -- $370,224,850

-- Good Loan Total Received Amount
SELECT SUM(total_payment) Good_loan_amount_recived
FROM bank_loan
WHERE loan_status IN ('Fully Paid', 'Current'); -- $435,786,170


-- BAD LOAN KPI´S
-- Bad Loan Application Percentage
SELECT 
    ROUND((COUNT(CASE WHEN loan_status = 'Charged Off' THEN 1 END) * 100.0 / COUNT(*)),2) AS `Bad_loan_percenatge (%)`
FROM bank_loan; -- 13.82%

-- Bad Loan Applications
SELECT COUNT(*) Bad_loan_applications
FROM bank_loan
WHERE loan_status IN ('Charged Off'); -- 5,333

-- Bad Loan Funded Amount
SELECT SUM(loan_amount) Bad_loan_funded_amount
FROM bank_loan
WHERE loan_status = 'Charged Off'; -- $65,532,225

-- Bad Loan Total Received Amount
SELECT SUM(total_payment) Bad_loan_amount_recived
FROM bank_loan
WHERE loan_status IN ('Charged Off'); -- $37,284,763



-- Calculating the loan count, total amount received, total funded amount, interest rate, DTI, on the basis of the loan status
SELECT
	loan_status,
    count(*) Loan_Applications,
    sum(loan_amount) Total_amount_funded,
    sum(total_payment) Total_amount_received,
    round(avg(int_rate*100),2) `AVG_interest_rate (%)`,
    round(avg(dti*100),2) `AVG_DTI_ratio (%)`
FROM bank_loan
GROUP BY loan_status;

-- Calculating MTD Total amount received, MTD Total funded amount basis of loan status
SELECT
	loan_status,
    sum(loan_amount) MTD_Total_amount_funded,
    sum(total_payment) MTD_Total_amount_received
FROM bank_loan
WHERE MONTH(issue_date) = 12
GROUP BY loan_status;



-- BANK LOAN REPORT
-- Monthly Trends by Issue Date
SELECT
	month(issue_date) Month_num,
    monthname(issue_date) Month,
    count(*) Loan_Applications,
    sum(loan_amount) Total_amount_funded,
    sum(total_payment) Total_amount_received
FROM bank_loan
GROUP BY 1, monthname(issue_date)
ORDER BY 1, monthname(issue_date);

-- Regional Analysis by State
SELECT
	address_state State,
    count(*) Loan_Applications,
    sum(loan_amount) Total_amount_funded,
    sum(total_payment) Total_amount_received
FROM bank_loan
GROUP BY 1
ORDER BY 1;

--  Loan Term Analysis
SELECT
	term Term,
    count(*) Loan_Applications,
    sum(loan_amount) Total_amount_funded,
    sum(total_payment) Total_amount_received
FROM bank_loan
GROUP BY 1
ORDER BY 1;

-- Employee Length Analysis
SELECT
	emp_length Employee_length,
    count(*) Loan_Applications,
    sum(loan_amount) Total_amount_funded,
    sum(total_payment) Total_amount_received
FROM bank_loan
GROUP BY 1;

--  Loan Purpose Breakdown
SELECT
	purpose Purpose,
    count(*) Loan_Applications,
    sum(loan_amount) Total_amount_funded,
    sum(total_payment) Total_amount_received
FROM bank_loan
GROUP BY 1
ORDER BY 1;

-- Home Ownership Analysis
SELECT
	home_ownership Home_ownership,
    count(*) Loan_Applications,
    sum(loan_amount) Total_amount_funded,
    sum(total_payment) Total_amount_received
FROM bank_loan
GROUP BY 1;