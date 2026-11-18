

-- SET 1: LOGISTICS SHIPMENT ANALYSIS
-- MySQL - advanced_reports.sql


DROP DATABASE IF EXISTS LogisticsDB;
CREATE DATABASE LogisticsDB;
USE LogisticsDB;

-- 1. HUBS
CREATE TABLE hubs (
    hub_id INT PRIMARY KEY,
    hub_name VARCHAR(100),
    city VARCHAR(100)
);

-- 2. EMPLOYEES
CREATE TABLE employees (
    employee_id INT PRIMARY KEY,
    employee_name VARCHAR(100),
    hub_id INT,
    supervisor_id INT,
    FOREIGN KEY (hub_id) REFERENCES hubs(hub_id),
    FOREIGN KEY (supervisor_id) REFERENCES employees(employee_id)
);

-- 3. CARRIERS
CREATE TABLE carriers (
    carrier_id INT PRIMARY KEY,
    carrier_name VARCHAR(100)
);

-- 4. CUSTOMERS
CREATE TABLE customers (
    customer_id INT PRIMARY KEY,
    customer_name VARCHAR(100),
    city VARCHAR(100)
);

-- 5. SHIPMENTS
CREATE TABLE shipments (
    shipment_id INT PRIMARY KEY,
    customer_id INT,
    hub_id INT,
    carrier_id INT,
    shipping_cost DECIMAL(10,2),
    shipment_date DATE,
    expected_delivery DATE,
    actual_delivery DATE,
    FOREIGN KEY (customer_id) REFERENCES customers(customer_id),
    FOREIGN KEY (hub_id) REFERENCES hubs(hub_id),
    FOREIGN KEY (carrier_id) REFERENCES carriers(carrier_id)
);

-- 6. DELIVERY EVENTS
CREATE TABLE delivery_events (
    event_id INT PRIMARY KEY,
    shipment_id INT,
    event_type VARCHAR(100),
    event_date DATE,
    description VARCHAR(255),
    FOREIGN KEY (shipment_id) REFERENCES shipments(shipment_id)
);
- ==========================================
-- INSERT SAMPLE DATA
-- ==========================================
INSERT INTO hubs VALUES
(1, 'Chennai Hub', 'Chennai'),
(2, 'Bangalore Hub', 'Bangalore'),
(3, 'Hyderabad Hub', 'Hyderabad'),
(4, 'Mumbai Hub', 'Mumbai'),
(5, 'Delhi Hub', 'Delhi');

INSERT INTO employees VALUES
(1, 'Arun', 1, NULL),
(2, 'Bala', 1, 1),
(3, 'Charan', 2, 1),
(4, 'Divya', 3, 2),
(5, 'Esha', 4, 2);

INSERT INTO carriers VALUES
(1, 'BlueDart'),
(2, 'DHL'),
(3, 'FedEx'),
(4, 'DTDC');

INSERT INTO customers VALUES
(1, 'Abdullah', 'Chennai'),
(2, 'Hashini', 'Bangalore'),
(3, 'Rahul', 'Hyderabad'),
(4, 'Priya', 'Mumbai'),
(5, 'Karthik', 'Delhi'),
(6, 'Sara', 'Chennai');

INSERT INTO shipments VALUES
(101, 1, 1, 1, 500, '2026-01-01', '2026-01-03', '2026-01-07'),
(102, 1, 2, 2, 800, '2026-01-02', '2026-01-04', '2026-01-04'),
(103, 1, 3, 3, 600, '2026-01-03', '2026-01-05', '2026-01-09'),
(104, 1, 4, 1, 900, '2026-01-04', '2026-01-06', '2026-01-06'),
(105, 1, 5, 2, 700, '2026-01-05', '2026-01-07', '2026-01-07'),

(106, 2, 1, 2, 450, '2026-01-06', '2026-01-08', '2026-01-08'),
(107, 2, 2, 3, 750, '2026-01-07', '2026-01-09', '2026-01-13'),
(108, 3, 1, 3, 550, '2026-01-08', '2026-01-10', '2026-01-15'),
(109, 3, 3, 4, 650, '2026-01-09', '2026-01-11', '2026-01-11'),
(110, 4, 2, 1, 1000, '2026-01-10', '2026-01-12', '2026-01-17'),
(111, 4, 4, 4, 1200, '2026-01-11', '2026-01-13', '2026-01-13'),
(112, 5, 3, 2, 400, '2026-01-12', '2026-01-14', '2026-01-14'),
(113, 6, 1, 1, 300, '2026-01-13', '2026-01-15', '2026-01-20'),
(114, 6, 2, 2, 850, '2026-01-14', '2026-01-16', '2026-01-16');

INSERT INTO delivery_events VALUES
(1, 101, 'Picked Up', '2026-01-01', 'Shipment collected'),
(2, 101, 'In Transit', '2026-01-02', 'Shipment moving'),
(3, 101, 'Delivered', '2026-01-07', 'Delivered late'),
(4, 102, 'Delivered', '2026-01-04', 'Delivered on time'),
(5, 103, 'Delayed', '2026-01-07', 'Weather conditions'),
(6, 103, 'Delivered', '2026-01-09', 'Delivered late'),
(7, 107, 'Delayed', '2026-01-12', 'Vehicle breakdown'),
(8, 107, 'Delivered', '2026-01-13', 'Delivered late'),
(9, 108, 'Delayed', '2026-01-13', 'Sorting issue'),
(10, 108, 'Delivered', '2026-01-15', 'Delivered late'),
(11, 110, 'Delayed', '2026-01-15', 'Traffic delay'),
(12, 110, 'Delivered', '2026-01-17', 'Delivered late'),
(13, 113, 'Delivered', '2026-01-20', 'Delivered late');


-- TASK 1: TEN BUSINESS QUESTIONS USING JOINS


-- Q1. Find shipments delayed by more than 2 days
-- Display customer, carrier and hub names.
-- INNER JOIN

SELECT
    s.shipment_id,
    cu.customer_name,
    ca.carrier_name,
    h.hub_name,
    DATEDIFF(s.actual_delivery, s.expected_delivery) AS delay_days
FROM shipments s
INNER JOIN customers cu ON s.customer_id = cu.customer_id
INNER JOIN carriers ca ON s.carrier_id = ca.carrier_id
INNER JOIN hubs h ON s.hub_id = h.hub_id
WHERE DATEDIFF(s.actual_delivery, s.expected_delivery) > 2;


-- Q2. Find hubs with no outbound shipments.
-- LEFT JOIN

SELECT
    h.hub_id,
    h.hub_name
FROM hubs h
LEFT JOIN shipments s ON h.hub_id = s.hub_id
WHERE s.shipment_id IS NULL;


-- Q3. Display employees and their supervisors.
-- SELF JOIN

SELECT
    e.employee_name AS employee,
    sup.employee_name AS supervisor
FROM employees e
LEFT JOIN employees sup
ON e.supervisor_id = sup.employee_id;


-- Q4. Display complete shipment details with customer,
-- carrier, hub and delivery event information.
-- INNER JOIN

SELECT
    s.shipment_id,
    cu.customer_name,
    ca.carrier_name,
    h.hub_name,
    de.event_type,
    de.description
FROM shipments s
INNER JOIN customers cu ON s.customer_id = cu.customer_id
INNER JOIN carriers ca ON s.carrier_id = ca.carrier_id
INNER JOIN hubs h ON s.hub_id = h.hub_id
LEFT JOIN delivery_events de ON s.shipment_id = de.shipment_id;


-- Q5. FULL OUTER JOIN equivalent in MySQL.
-- Display all hubs and shipments, including unmatched rows.

SELECT
    h.hub_name,
    s.shipment_id
FROM hubs h
LEFT JOIN shipments s ON h.hub_id = s.hub_id

UNION

SELECT
    h.hub_name,
    s.shipment_id
FROM hubs h
RIGHT JOIN shipments s ON h.hub_id = s.hub_id;


-- Q6. Find customers who have shipped to every hub.
-- GROUP BY and HAVING

SELECT
    cu.customer_id,
    cu.customer_name
FROM customers cu
INNER JOIN shipments s ON cu.customer_id = s.customer_id
GROUP BY cu.customer_id, cu.customer_name
HAVING COUNT(DISTINCT s.hub_id) = (
    SELECT COUNT(*) FROM hubs
);


-- Q7. Find carriers whose average delay is above
-- the overall average delay.
-- Subquery with ALL

SELECT
    ca.carrier_name,
    AVG(DATEDIFF(s.actual_delivery, s.expected_delivery))
        AS average_delay
FROM carriers ca
INNER JOIN shipments s ON ca.carrier_id = s.carrier_id
GROUP BY ca.carrier_id, ca.carrier_name
HAVING AVG(DATEDIFF(s.actual_delivery, s.expected_delivery))
>
ALL (
    SELECT AVG(DATEDIFF(actual_delivery, expected_delivery))
    FROM shipments
    GROUP BY carrier_id
);


-- Q8. Find customers who have shipped to Chennai Hub.
-- IN subquery

SELECT customer_name
FROM customers
WHERE customer_id IN (
    SELECT customer_id
    FROM shipments
    WHERE hub_id IN (
        SELECT hub_id
        FROM hubs
        WHERE city = 'Chennai'
    )
);


-- Q9. Find hubs that have at least one shipment.
-- EXISTS subquery

SELECT
    h.hub_name
FROM hubs h
WHERE EXISTS (
    SELECT 1
    FROM shipments s
    WHERE s.hub_id = h.hub_id
);


-- Q10. Find shipments whose shipping cost is greater
-- than ANY shipment cost handled by BlueDart.

SELECT
    shipment_id,
    shipping_cost
FROM shipments
WHERE shipping_cost > ANY (
    SELECT s.shipping_cost
    FROM shipments s
    INNER JOIN carriers c
    ON s.carrier_id = c.carrier_id
    WHERE c.carrier_name = 'BlueDart'
);


-- TASK 2: REWRITE TWO SUBQUERIES AS JOINS


-- Original: Customers who shipped to Chennai Hub
-- JOIN version

SELECT DISTINCT
    cu.customer_name
FROM customers cu
INNER JOIN shipments s ON cu.customer_id = s.customer_id
INNER JOIN hubs h ON s.hub_id = h.hub_id
WHERE h.city = 'Chennai';


-- Original: Hubs with at least one shipment
-- JOIN version

SELECT DISTINCT
    h.hub_name
FROM hubs h
INNER JOIN shipments s ON h.hub_id = s.hub_id;


-- The JOIN version may require DISTINCT to avoid duplicates.



-- TASK 3: NESTED SUBQUERY
-- SECOND-HIGHEST SHIPPING COST PER HUB


SELECT
    h.hub_name,
    (
        SELECT MAX(s1.shipping_cost)
        FROM shipments s1
        WHERE s1.hub_id = h.hub_id
        AND s1.shipping_cost < (
            SELECT MAX(s2.shipping_cost)
            FROM shipments s2
            WHERE s2.hub_id = h.hub_id
        )
    ) AS second_highest_shipping_cost
FROM hubs h;


