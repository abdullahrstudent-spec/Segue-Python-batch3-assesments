

-- DATABASE CREATION
DROP DATABASE IF EXISTS BankLoanDB;
CREATE DATABASE BankLoanDB;
USE BankLoanDB;


-- 1. CREATE TABLES


-- BRANCHES
CREATE TABLE branches (
    branch_id INT PRIMARY KEY,
    branch_name VARCHAR(100),
    city VARCHAR(100)
);

-- CUSTOMERS
CREATE TABLE customers (
    customer_id INT PRIMARY KEY,
    customer_name VARCHAR(100),
    city VARCHAR(100)
);

-- LOANS
CREATE TABLE loans (
    loan_id INT PRIMARY KEY,
    customer_id INT,
    branch_id INT,
    loan_amount DECIMAL(12,2),
    overdue_installments INT DEFAULT 0,
    loan_date DATE,
    FOREIGN KEY (customer_id) REFERENCES customers(customer_id),
    FOREIGN KEY (branch_id) REFERENCES branches(branch_id)
);

-- GUARANTORS
CREATE TABLE guarantors (
    guarantor_id INT PRIMARY KEY,
    loan_id INT,
    guarantor_customer_id INT,
    FOREIGN KEY (loan_id) REFERENCES loans(loan_id),
    FOREIGN KEY (guarantor_customer_id) REFERENCES customers(customer_id)
);

-- REPAYMENTS
CREATE TABLE repayments (
    repayment_id INT PRIMARY KEY,
    loan_id INT,
    repayment_amount DECIMAL(12,2),
    repayment_date DATE,
    FOREIGN KEY (loan_id) REFERENCES loans(loan_id)
);


-- 2. INSERT SAMPLE DATA


INSERT INTO branches VALUES
(1, 'Chennai Main Branch', 'Chennai'),
(2, 'Bangalore Branch', 'Bangalore'),
(3, 'Hyderabad Branch', 'Hyderabad'),
(4, 'Mumbai Branch', 'Mumbai'),
(5, 'Delhi Branch', 'Delhi'),
(6, 'Kolkata Branch', 'Kolkata');

INSERT INTO customers VALUES
(1, 'Abdullah', 'Chennai'),
(2, 'Hashini', 'Bangalore'),
(3, 'Rahul', 'Hyderabad'),
(4, 'Priya', 'Mumbai'),
(5, 'Karthik', 'Delhi'),
(6, 'Sara', 'Chennai'),
(7, 'Arun', 'Bangalore'),
(8, 'Divya', 'Mumbai'),
(9, 'Vijay', 'Hyderabad');

INSERT INTO loans VALUES
(101, 1, 1, 500000, 4, '2026-01-10'),
(102, 1, 2, 300000, 1, '2026-02-15'),
(103, 2, 1, 800000, 0, '2026-03-10'),
(104, 3, 2, 400000, 5, '2026-01-20'),
(105, 3, 3, 600000, 2, '2026-04-12'),
(106, 4, 3, 900000, 4, '2026-02-18'),
(107, 5, 1, 200000, 0, '2026-05-05'),
(108, 6, 2, 700000, 3, '2026-03-22'),
(109, 7, 3, 350000, 1, '2026-06-01'),
(110, 8, 4, 1000000, 6, '2026-01-15'),
(111, 9, 4, 450000, 0, '2026-06-20');

INSERT INTO guarantors VALUES
(1, 101, 2),
(2, 103, 1),
(3, 104, 5),
(4, 106, 7),
(5, 110, 3);

INSERT INTO repayments VALUES
(1, 101, 20000, '2026-11-05'),
(2, 101, 15000, '2026-10-05'),
(3, 102, 10000, '2026-11-10'),
(4, 103, 25000, '2026-10-20'),
(5, 104, 12000, '2026-08-01'),
(6, 105, 18000, '2026-11-12'),
(7, 106, 30000, '2026-07-15'),
(8, 107, 8000, '2026-11-01'),
(9, 108, 22000, '2026-09-10'),
(10, 109, 11000, '2026-11-15'),
(11, 110, 35000, '2026-08-15'),
(12, 111, 14000, '2026-10-25');


-- TASK 1: TEN BUSINESS QUESTIONS


-- Q1. Find loans overdue by more than 3 installments.
-- INNER JOIN

SELECT
    l.loan_id,
    c.customer_name,
    b.branch_name,
    l.loan_amount,
    l.overdue_installments
FROM loans l
INNER JOIN customers c
    ON l.customer_id = c.customer_id
INNER JOIN branches b
    ON l.branch_id = b.branch_id
WHERE l.overdue_installments > 3;


-- Q2. Find customers who have loans in more than one branch.

SELECT
    c.customer_id,
    c.customer_name,
    COUNT(DISTINCT l.branch_id) AS total_branches
FROM customers c
INNER JOIN loans l
    ON c.customer_id = l.customer_id
GROUP BY c.customer_id, c.customer_name
HAVING COUNT(DISTINCT l.branch_id) > 1;


-- Q3. Find guarantors who are also borrowers.
-- SELF JOIN using customers and loans.

SELECT DISTINCT
    g.guarantor_customer_id,
    guarantor.customer_name AS guarantor_name,
    borrower.customer_name AS borrower_name,
    l.loan_id
FROM guarantors g
INNER JOIN customers guarantor
    ON g.guarantor_customer_id = guarantor.customer_id
INNER JOIN loans l
    ON g.loan_id = l.loan_id
INNER JOIN customers borrower
    ON l.customer_id = borrower.customer_id
INNER JOIN loans borrower_loan
    ON borrower.customer_id = borrower_loan.customer_id;


-- Q4. Find branches with no loans.
-- LEFT JOIN

SELECT
    b.branch_id,
    b.branch_name
FROM branches b
LEFT JOIN loans l
    ON b.branch_id = l.branch_id
WHERE l.loan_id IS NULL;


-- Q5. CORRELATED SUBQUERY
-- Find customers whose total loan exposure in a branch
-- exceeds the average customer exposure in that branch.

WITH customer_branch_exposure AS (
    SELECT
        customer_id,
        branch_id,
        SUM(loan_amount) AS total_exposure
    FROM loans
    GROUP BY customer_id, branch_id
)
SELECT
    c.customer_name,
    b.branch_name,
    e.total_exposure
FROM customer_branch_exposure e
INNER JOIN customers c
    ON e.customer_id = c.customer_id
INNER JOIN branches b
    ON e.branch_id = b.branch_id
WHERE e.total_exposure > (
    SELECT AVG(e2.total_exposure)
    FROM customer_branch_exposure e2
    WHERE e2.branch_id = e.branch_id
);


-- Q6. UNCORRELATED SUBQUERY
-- Same requirement using an uncorrelated subquery
-- and a derived table containing branch averages.

SELECT
    c.customer_name,
    b.branch_name,
    exposure.total_exposure,
    averages.average_exposure
FROM (
    SELECT
        customer_id,
        branch_id,
        SUM(loan_amount) AS total_exposure
    FROM loans
    GROUP BY customer_id, branch_id
) exposure
INNER JOIN customers c
    ON exposure.customer_id = c.customer_id
INNER JOIN branches b
    ON exposure.branch_id = b.branch_id
INNER JOIN (
    SELECT
        branch_id,
        AVG(customer_exposure) AS average_exposure
    FROM (
        SELECT
            customer_id,
            branch_id,
            SUM(loan_amount) AS customer_exposure
        FROM loans
        GROUP BY customer_id, branch_id
    ) branch_customers
    GROUP BY branch_id
) averages
    ON exposure.branch_id = averages.branch_id
WHERE exposure.total_exposure > averages.average_exposure;


-- Q7. EXISTS AND NOT EXISTS
-- Find customers with a loan but no repayment
-- in the last 60 days.

SELECT
    c.customer_id,
    c.customer_name
FROM customers c
WHERE EXISTS (
    SELECT 1
    FROM loans l
    WHERE l.customer_id = c.customer_id
)
AND NOT EXISTS (
    SELECT 1
    FROM loans l
    INNER JOIN repayments r
        ON l.loan_id = r.loan_id
    WHERE l.customer_id = c.customer_id
      AND r.repayment_date >= DATE_SUB(CURDATE(), INTERVAL 60 DAY)
      AND r.repayment_date <= CURDATE()
);


-- Q8. Find total loan exposure of every customer.

SELECT
    c.customer_id,
    c.customer_name,
    COALESCE(SUM(l.loan_amount), 0) AS total_loan_exposure
FROM customers c
LEFT JOIN loans l
    ON c.customer_id = l.customer_id
GROUP BY c.customer_id, c.customer_name;


-- Q9. Display loan repayment statistics.

SELECT
    l.loan_id,
    c.customer_name,
    l.loan_amount,
    COUNT(r.repayment_id) AS total_repayments,
    COALESCE(SUM(r.repayment_amount), 0) AS total_repaid
FROM loans l
INNER JOIN customers c
    ON l.customer_id = c.customer_id
LEFT JOIN repayments r
    ON l.loan_id = r.loan_id
GROUP BY
    l.loan_id,
    c.customer_name,
    l.loan_amount;


-- Q10. NESTED SUBQUERY
-- Find branches whose highest loan is greater than
-- the bank-wide average of branch maximum loan amounts.

SELECT
    b.branch_id,
    b.branch_name,
    (
        SELECT MAX(l.loan_amount)
        FROM loans l
        WHERE l.branch_id = b.branch_id
    ) AS highest_loan
FROM branches b
WHERE (
    SELECT MAX(l.loan_amount)
    FROM loans l
    WHERE l.branch_id = b.branch_id
) > (
    SELECT AVG(branch_maximum)
    FROM (
        SELECT
            MAX(loan_amount) AS branch_maximum
        FROM loans
        GROUP BY branch_id
    ) AS branch_averages
);


