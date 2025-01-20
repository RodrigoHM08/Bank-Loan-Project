-- ---------------------------- BANK LOAN DATA CLEANING ----------------------------
SELECT * FROM bank_loan;

-- check if there are any duplicates and remove them
SELECT id, address_state, application_type, emp_length, emp_title, grade, home_ownership, issue_date, last_credit_pull_date,
last_payment_date, loan_status, next_payment_date, member_id, purpose, sub_grade, term, verification_status, annual_income,
dti, installment, int_rate, loan_amount, total_acc, total_payment, COUNT(*) AS QUANTITY
FROM bank_loan
GROUP BY id, address_state, application_type, emp_length, emp_title, grade, home_ownership, issue_date, last_credit_pull_date,
last_payment_date, loan_status, next_payment_date, member_id, purpose, sub_grade, term, verification_status, annual_income,
dti, installment, int_rate, loan_amount, total_acc, total_payment
HAVING QUANTITY > 1;

/*	In this case we don´t have any duplicate rows but in case we had them we could use the next query

DELETE FROM bank_loan
WHERE id NOT IN (
    SELECT id
    FROM (
        SELECT MIN(id) AS id
        FROM bank_loan
        GROUP BY id, address_state, application_type, emp_length, emp_title, grade, home_ownership, issue_date, last_credit_pull_date,
		last_payment_date, loan_status, next_payment_date, member_id, purpose, sub_grade, term, verification_status, annual_income,
		dti, installment, int_rate, loan_amount, total_acc, total_payment
    ) AS subquery
);

*/

-- check data in every column in order to normalize it if necessary
SELECT DISTINCT emp_title
FROM bank_loan
ORDER BY 1; 

SELECT emp_title, TRIM(emp_title)
FROM bank_loan
WHERE emp_title = ' %';

UPDATE bank_loan
SET emp_title = TRIM(emp_title);	-- delete blank spaces from the beginning and end from a string

-- We should set the blanks to nulls since those are typically easier to work with
UPDATE bank_loan
SET emp_title = NULL
WHERE emp_title = '';

-- Change the 'D' to 'd' in every debt consolidation puspose to match the other purposes format
UPDATE bank_loan
SET purpose = 'debt consolidation'
WHERE purpose = 'Debt consolidation';

-- Delete blank spaces in 'term' column
UPDATE bank_loan
SET term = TRIM(term);

SELECT DISTINCT total_payment
FROM bank_loan
ORDER BY 1;

-- change the necessary columns format from text to date
-- --------- 1. Column 'issue_date'
SELECT issue_date, STR_TO_DATE(issue_date, '%d-%m-%Y')
FROM bank_loan;

UPDATE bank_loan
SET issue_date = STR_TO_DATE(issue_date, '%d-%m-%Y');

ALTER TABLE bank_loan MODIFY COLUMN issue_date DATE;

--  ---------2. Column 'last_credit_pull_date'
SELECT last_credit_pull_date, STR_TO_DATE(last_credit_pull_date, '%d-%m-%Y')
FROM bank_loan;

UPDATE bank_loan
SET last_credit_pull_date = STR_TO_DATE(last_credit_pull_date, '%d-%m-%Y');

ALTER TABLE bank_loan MODIFY COLUMN last_credit_pull_date DATE;

-- --------- 3. Column 'last_payment_date'
SELECT last_payment_date, STR_TO_DATE(last_payment_date, '%d-%m-%Y')
FROM bank_loan;

UPDATE bank_loan
SET last_payment_date = STR_TO_DATE(last_payment_date, '%d-%m-%Y');

ALTER TABLE bank_loan MODIFY COLUMN last_payment_date DATE;

-- --------- 4. Column 'next_payment_date'
SELECT next_payment_date, STR_TO_DATE(next_payment_date, '%d-%m-%Y')
FROM bank_loan;

UPDATE bank_loan
SET next_payment_date = STR_TO_DATE(next_payment_date, '%d-%m-%Y');

ALTER TABLE bank_loan MODIFY COLUMN next_payment_date DATE;