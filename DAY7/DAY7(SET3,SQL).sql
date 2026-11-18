
DROP DATABASE IF EXISTS ReturnsRefundsDB;
CREATE DATABASE ReturnsRefundsDB;
USE ReturnsRefundsDB;

-- CREATE TABLES

CREATE TABLE products (
    product_id INT PRIMARY KEY,
    product_name VARCHAR(100),
    category VARCHAR(100)
);

CREATE TABLE customers (
    customer_id INT PRIMARY KEY,
    customer_name VARCHAR(100),
    city VARCHAR(100)
);

CREATE TABLE stores (
    store_id INT PRIMARY KEY,
    store_name VARCHAR(100),
    region VARCHAR(100)
);

CREATE TABLE employees (
    employee_id INT PRIMARY KEY,
    employee_name VARCHAR(100),
    store_id INT,
    manager_id INT,
    FOREIGN KEY (store_id) REFERENCES stores(store_id),
    FOREIGN KEY (manager_id) REFERENCES employees(employee_id)
);

CREATE TABLE sales (
    sale_id INT PRIMARY KEY,
    product_id INT,
    customer_id INT,
    store_id INT,
    quantity_sold INT,
    sale_amount DECIMAL(12,2),
    sale_date DATE,
    FOREIGN KEY (product_id) REFERENCES products(product_id),
    FOREIGN KEY (customer_id) REFERENCES customers(customer_id),
    FOREIGN KEY (store_id) REFERENCES stores(store_id)
);

CREATE TABLE returns (
    return_id INT PRIMARY KEY,
    sale_id INT,
    product_id INT,
    customer_id INT NULL,
    store_id INT,
    employee_id INT,
    return_quantity INT,
    return_reason VARCHAR(200),
    return_date DATE,
    FOREIGN KEY (sale_id) REFERENCES sales(sale_id),
    FOREIGN KEY (product_id) REFERENCES products(product_id),
    FOREIGN KEY (customer_id) REFERENCES customers(customer_id),
    FOREIGN KEY (store_id) REFERENCES stores(store_id),
    FOREIGN KEY (employee_id) REFERENCES employees(employee_id)
);

CREATE TABLE refunds (
    refund_id INT PRIMARY KEY,
    return_id INT,
    refund_amount DECIMAL(12,2),
    refund_date DATE,
    FOREIGN KEY (return_id) REFERENCES returns(return_id)
);

CREATE TABLE returns_feedback (
    feedback_id INT PRIMARY KEY,
    return_id INT,
    rating INT,
    feedback_comment VARCHAR(255),
    FOREIGN KEY (return_id) REFERENCES returns(return_id)
);

-- INSERT DATA

INSERT INTO products VALUES
(1,'Laptop','Electronics'),
(2,'Mobile Phone','Electronics'),
(3,'Headphones','Accessories'),
(4,'Keyboard','Accessories'),
(5,'Monitor','Electronics'),
(6,'Mouse','Accessories'),
(7,'Smart Watch','Electronics');

INSERT INTO customers VALUES
(1,'Abdullah','Chennai'),
(2,'Hashini','Bangalore'),
(3,'Rahul','Hyderabad'),
(4,'Priya','Mumbai'),
(5,'Karthik','Delhi'),
(6,'Sara','Chennai'),
(7,'Arun','Bangalore');

INSERT INTO stores VALUES
(1,'Chennai Central','South'),
(2,'Bangalore Store','South'),
(3,'Hyderabad Store','South'),
(4,'Mumbai Store','West'),
(5,'Delhi Store','North'),
(6,'Kolkata Store','East');

INSERT INTO employees VALUES
(1,'Arun Manager',1,NULL),
(2,'Bala',1,1),
(3,'Charan',2,1),
(4,'Divya Manager',3,NULL),
(5,'Esha',3,4),
(6,'Farhan Manager',4,NULL),
(7,'Gokul',4,6),
(8,'Hari',5,NULL);

INSERT INTO sales VALUES
(101,1,1,1,10,500000,'2026-10-01'),
(102,2,2,1,20,400000,'2026-10-02'),
(103,3,3,2,50,150000,'2026-10-03'),
(104,4,4,2,100,200000,'2026-10-04'),
(105,5,5,3,20,600000,'2026-10-05'),
(106,6,6,3,100,100000,'2026-10-06'),
(107,1,7,4,15,750000,'2026-10-07'),
(108,2,1,4,30,600000,'2026-10-08'),
(109,3,2,5,40,120000,'2026-10-09'),
(110,4,3,5,80,160000,'2026-10-10'),
(111,5,4,1,10,300000,'2026-10-11'),
(112,6,5,2,60,60000,'2026-10-12'),
(113,7,6,3,25,250000,'2026-10-13'),
(114,7,7,4,20,200000,'2026-10-14');

INSERT INTO returns VALUES
(201,101,1,1,1,2,3,'Damaged product','2026-10-15'),
(202,102,2,2,1,2,4,'Wrong item','2026-10-16'),
(203,103,3,3,2,3,8,'Defective','2026-10-17'),
(204,104,4,4,2,3,5,'Changed mind','2026-10-18'),
(205,105,5,5,3,5,5,'Damaged product','2026-10-19'),
(206,106,6,6,3,5,2,'Wrong item','2026-10-20'),
(207,107,1,7,4,7,2,'Defective','2026-10-21'),
(208,108,2,1,4,7,6,'Damaged product','2026-10-22'),
(209,109,3,2,5,8,3,'Changed mind','2026-10-23'),
(210,110,4,3,5,8,4,'Defective','2026-10-24'),
(211,111,5,4,1,2,1,'Wrong item','2026-10-25'),
(212,112,6,5,2,3,5,'Damaged product','2026-10-26'),
(213,113,7,6,3,5,3,'Defective','2026-10-27'),
(214,114,7,7,4,7,2,'Wrong item','2026-10-28'),
(215,101,1,1,1,2,1,'Damaged product','2026-10-29'),
(216,102,2,1,1,2,1,'Wrong item','2026-10-30'),
(217,103,3,2,2,3,1,'Defective','2026-10-31'),
(218,104,4,2,2,3,1,'Changed mind','2026-11-01'),
(219,105,5,3,3,5,1,'Damaged product','2026-11-02'),
(220,106,6,3,3,5,1,'Wrong item','2026-11-03'),
(221,107,1,NULL,4,7,1,'Anonymous return','2026-11-04');

INSERT INTO refunds VALUES
(301,201,150000,'2026-10-16'),
(302,202,80000,'2026-10-17'),
(303,203,24000,'2026-10-18'),
(304,204,10000,'2026-10-19'),
(305,205,150000,'2026-10-20'),
(306,207,100000,'2026-10-22'),
(307,208,120000,'2026-10-23'),
(308,209,9000,'2026-10-24'),
(309,210,8000,'2026-10-25'),
(310,211,30000,'2026-10-26'),
(311,213,30000,'2026-10-28'),
(312,215,50000,'2026-10-30'),
(313,217,3000,'2026-11-01'),
(314,219,30000,'2026-11-03');

INSERT INTO returns_feedback VALUES
(401,201,2,'Product arrived damaged'),
(402,202,3,'Incorrect product delivered'),
(403,203,1,'Very poor quality'),
(404,204,4,'Return process was easy'),
(405,205,2,'Product was broken'),
(406,207,3,'Replacement preferred'),
(407,208,1,'Not satisfied'),
(408,210,4,'Good customer support'),
(409,213,2,'Defective item');

-- Q1 PRODUCTS WITH RETURN RATE ABOVE 10 PERCENT

SELECT p.product_id,p.product_name,
       s.total_sold,
       COALESCE(r.total_returned,0) AS total_returned,
       ROUND(COALESCE(r.total_returned,0)*100.0/
       NULLIF(s.total_sold,0),2) AS return_rate
FROM products p
JOIN (
    SELECT product_id,SUM(quantity_sold) AS total_sold
    FROM sales GROUP BY product_id
) s ON p.product_id=s.product_id
LEFT JOIN (
    SELECT product_id,SUM(return_quantity) AS total_returned
    FROM returns GROUP BY product_id
) r ON p.product_id=r.product_id
WHERE COALESCE(r.total_returned,0)*100.0/
NULLIF(s.total_sold,0)>10;

-- Q2 CUSTOMERS WITH RETURNS BUT NO REFUNDS

SELECT c.customer_id,c.customer_name
FROM customers c
WHERE EXISTS (
    SELECT 1 FROM returns r
    WHERE r.customer_id=c.customer_id
)
AND NOT EXISTS (
    SELECT 1
    FROM returns r
    JOIN refunds f ON r.return_id=f.return_id
    WHERE r.customer_id=c.customer_id
);

-- Q3 STORES WITH HIGHEST REFUND VALUE

SELECT st.store_id,st.store_name,
       SUM(f.refund_amount) AS total_refund
FROM stores st
JOIN returns r ON st.store_id=r.store_id
JOIN refunds f ON r.return_id=f.return_id
GROUP BY st.store_id,st.store_name
HAVING SUM(f.refund_amount)=(
    SELECT MAX(total_refund)
    FROM (
        SELECT SUM(f2.refund_amount) AS total_refund
        FROM returns r2
        JOIN refunds f2 ON r2.return_id=f2.return_id
        GROUP BY r2.store_id
    ) x
);

-- Q4 EMPLOYEES AND THEIR MANAGERS (SELF JOIN)

SELECT e.employee_name AS employee,
       m.employee_name AS manager,
       s.store_name
FROM employees e
LEFT JOIN employees m ON e.manager_id=m.employee_id
LEFT JOIN stores s ON e.store_id=s.store_id;

-- Q5 STORES WITH NO RETURNS

SELECT s.store_id,s.store_name
FROM stores s
LEFT JOIN returns r ON s.store_id=r.store_id
WHERE r.return_id IS NULL;

-- Q6 IN SUBQUERY

SELECT customer_id,customer_name
FROM customers
WHERE customer_id IN (
    SELECT customer_id FROM returns
    WHERE customer_id IS NOT NULL
);

-- Q7 NOT IN NULL PITFALL DEMONSTRATION

SELECT customer_id,customer_name
FROM customers
WHERE customer_id NOT IN (
    SELECT customer_id FROM returns
);

-- CORRECTED USING NOT EXISTS

SELECT c.customer_id,c.customer_name
FROM customers c
WHERE NOT EXISTS (
    SELECT 1 FROM returns r
    WHERE r.customer_id=c.customer_id
);

-- Q8 ANY: STORE REFUNDS VS OTHER STORES IN SAME REGION

SELECT s.store_id,s.store_name,
       COALESCE(SUM(f.refund_amount),0) AS total_refund
FROM stores s
LEFT JOIN returns r ON s.store_id=r.store_id
LEFT JOIN refunds f ON r.return_id=f.return_id
GROUP BY s.store_id,s.store_name,s.region
HAVING COALESCE(SUM(f.refund_amount),0)>ANY (
    SELECT COALESCE(SUM(f2.refund_amount),0)
    FROM stores s2
    LEFT JOIN returns r2 ON s2.store_id=r2.store_id
    LEFT JOIN refunds f2 ON r2.return_id=f2.return_id
    WHERE s2.region=s.region
      AND s2.store_id<>s.store_id
    GROUP BY s2.store_id
);

-- Q9 ALL: STORE REFUNDS VS EVERY OTHER STORE IN SAME REGION

SELECT s.store_id,s.store_name,
       COALESCE(SUM(f.refund_amount),0) AS total_refund
FROM stores s
LEFT JOIN returns r ON s.store_id=r.store_id
LEFT JOIN refunds f ON r.return_id=f.return_id
GROUP BY s.store_id,s.store_name,s.region
HAVING COALESCE(SUM(f.refund_amount),0)>ALL (
    SELECT COALESCE(SUM(f2.refund_amount),0)
    FROM stores s2
    LEFT JOIN returns r2 ON s2.store_id=r2.store_id
    LEFT JOIN refunds f2 ON r2.return_id=f2.return_id
    WHERE s2.region=s.region
      AND s2.store_id<>s.store_id
    GROUP BY s2.store_id
);

-- Q10 RETURNS WITH CUSTOMER, PRODUCT, STORE AND FEEDBACK

SELECT r.return_id,c.customer_name,p.product_name,
       s.store_name,rf.rating,rf.feedback_comment
FROM returns r
LEFT JOIN customers c ON r.customer_id=c.customer_id
JOIN products p ON r.product_id=p.product_id
JOIN stores s ON r.store_id=s.store_id
LEFT JOIN returns_feedback rf ON r.return_id=rf.return_id;

-- NESTED SUBQUERY 1: PRODUCTS ABOVE AVERAGE RETURN QUANTITY

SELECT p.product_id,p.product_name,
       (SELECT COALESCE(SUM(r.return_quantity),0)
        FROM returns r
        WHERE r.product_id=p.product_id) AS total_returned
FROM products p
WHERE (
    SELECT COALESCE(SUM(r.return_quantity),0)
    FROM returns r
    WHERE r.product_id=p.product_id
) > (
    SELECT AVG(product_returns)
    FROM (
        SELECT SUM(return_quantity) AS product_returns
        FROM returns
        GROUP BY product_id
    ) x
);

-- NESTED SUBQUERY 2: STORES ABOVE AVERAGE REFUND VALUE

SELECT s.store_id,s.store_name,
       (SELECT COALESCE(SUM(f.refund_amount),0)
        FROM returns r
        JOIN refunds f ON r.return_id=f.return_id
        WHERE r.store_id=s.store_id) AS total_refund
FROM stores s
WHERE (
    SELECT COALESCE(SUM(f.refund_amount),0)
    FROM returns r
    JOIN refunds f ON r.return_id=f.return_id
    WHERE r.store_id=s.store_id
) > (
    SELECT AVG(store_total)
    FROM (
        SELECT COALESCE(SUM(f.refund_amount),0) AS store_total
        FROM stores s2
        LEFT JOIN returns r2 ON s2.store_id=r2.store_id
        LEFT JOIN refunds f ON r2.return_id=f.return_id
        GROUP BY s2.store_id
    ) x
);
