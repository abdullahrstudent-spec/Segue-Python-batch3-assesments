



CREATE DATABASE IF NOT EXISTS RetailInventoryDB;
USE RetailInventoryDB;

-- 1. CREATE TABLES


CREATE TABLE IF NOT EXISTS Products (
    ProductID INT PRIMARY KEY,
    ProductName VARCHAR(100) NOT NULL,
    Category VARCHAR(50) NOT NULL,
    Stock INT NOT NULL,
    Price DECIMAL(10,2) NOT NULL
) ENGINE=InnoDB;

CREATE TABLE IF NOT EXISTS Orders (
    OrderID INT AUTO_INCREMENT PRIMARY KEY,
    CustomerID INT NOT NULL,
    OrderDate DATETIME DEFAULT CURRENT_TIMESTAMP,
    OrderStatus VARCHAR(30) DEFAULT 'Placed'
) ENGINE=InnoDB;

CREATE TABLE IF NOT EXISTS OrderLines (
    OrderLineID INT AUTO_INCREMENT PRIMARY KEY,
    OrderID INT NOT NULL,
    ProductID INT NOT NULL,
    Quantity INT NOT NULL,
    UnitPrice DECIMAL(10,2) NOT NULL,

    FOREIGN KEY (OrderID) REFERENCES Orders(OrderID),
    FOREIGN KEY (ProductID) REFERENCES Products(ProductID)
) ENGINE=InnoDB;


-- 2. INSERT SAMPLE PRODUCTS


INSERT IGNORE INTO Products VALUES
(1, 'Laptop', 'Electronics', 20, 50000),
(2, 'Mobile', 'Electronics', 15, 25000),
(3, 'Headphones', 'Electronics', 5, 2000),
(4, 'Keyboard', 'Electronics', 30, 1500),
(5, 'Mouse', 'Electronics', 8, 800),
(6, 'T-Shirt', 'Clothing', 40, 700),
(7, 'Jeans', 'Clothing', 25, 1500),
(8, 'Jacket', 'Clothing', 10, 3000),
(9, 'Shoes', 'Clothing', 18, 2500),
(10, 'Watch', 'Accessories', 12, 4000);


-- TASK 1: STOCK RESERVATION TRANSACTION
-- DECREMENT STOCK + INSERT ORDER + ORDER LINE


DELIMITER //

CREATE PROCEDURE PlaceOrder(
    IN p_CustomerID INT,
    IN p_ProductID INT,
    IN p_Quantity INT
)
BEGIN

    DECLARE v_Stock INT;
    DECLARE v_Price DECIMAL(10,2);
    DECLARE v_OrderID INT;
    DECLARE v_Found INT DEFAULT 1;

    DECLARE CONTINUE HANDLER FOR NOT FOUND
        SET v_Found = 0;

    DECLARE EXIT HANDLER FOR SQLEXCEPTION
    BEGIN
        ROLLBACK;
        RESIGNAL;
    END;

    START TRANSACTION;

    -- Validate quantity
    IF p_Quantity <= 0 THEN
        SIGNAL SQLSTATE '45000'
        SET MESSAGE_TEXT = 'Invalid quantity';
    END IF;

    -- Lock product row
    SELECT Stock, Price
    INTO v_Stock, v_Price
    FROM Products
    WHERE ProductID = p_ProductID
    FOR UPDATE;

    IF v_Found = 0 THEN
        SIGNAL SQLSTATE '45000'
        SET MESSAGE_TEXT = 'Product does not exist';
    END IF;

    -- Check stock availability
    IF v_Stock < p_Quantity THEN
        SIGNAL SQLSTATE '45000'
        SET MESSAGE_TEXT = 'Insufficient stock';
    END IF;

    -- Create order
    INSERT INTO Orders(CustomerID, OrderStatus)
    VALUES(p_CustomerID, 'Placed');

    SET v_OrderID = LAST_INSERT_ID();

    -- Decrement stock
    UPDATE Products
    SET Stock = Stock - p_Quantity
    WHERE ProductID = p_ProductID
      AND Stock >= p_Quantity;

    -- Insert order line
    INSERT INTO OrderLines
    (OrderID, ProductID, Quantity, UnitPrice)
    VALUES
    (v_OrderID, p_ProductID, p_Quantity, v_Price);

    COMMIT;

    SELECT
        'Order placed successfully' AS Result,
        v_OrderID AS OrderID;

END //

DELIMITER ;

-- Successful order
CALL PlaceOrder(101, 1, 2);

-- ROLLBACK DEMONSTRATION
-- INSUFFICIENT STOCK


SELECT Stock AS BeforeStock
FROM Products
WHERE ProductID = 3;

-- Only 5 headphones available.
-- Requesting 10 should fail and roll back.

CALL PlaceOrder(102, 3, 10);

-- Verify stock remains unchanged
SELECT Stock AS AfterStock
FROM Products
WHERE ProductID = 3;

-- Verify no order was created for failed request
SELECT * FROM Orders;

SELECT * FROM OrderLines;


-- TASK 2: CORRELATED SUBQUERY
-- PRODUCTS BELOW CATEGORY AVERAGE STOCK


SELECT
    P.ProductID,
    P.ProductName,
    P.Category,
    P.Stock

FROM Products P

WHERE P.Stock < (
    SELECT AVG(P2.Stock)
    FROM Products P2
    WHERE P2.Category = P.Category
);


-- TASK 3: CTE + ROW_NUMBER + PARTITION BY
-- TOP 3 PRODUCTS BY SALES PER CATEGORY


WITH ProductSales AS
(
    SELECT
        P.ProductID,
        P.ProductName,
        P.Category,

        COALESCE(SUM(OL.Quantity), 0) AS TotalSales

    FROM Products P

    LEFT JOIN OrderLines OL
        ON P.ProductID = OL.ProductID

    LEFT JOIN Orders O
        ON OL.OrderID = O.OrderID
       AND O.OrderStatus = 'Placed'

    GROUP BY
        P.ProductID,
        P.ProductName,
        P.Category
),

RankedProducts AS
(
    SELECT
        ProductID,
        ProductName,
        Category,
        TotalSales,

        ROW_NUMBER() OVER (
            PARTITION BY Category
            ORDER BY TotalSales DESC, ProductID
        ) AS SalesRank

    FROM ProductSales
)

SELECT
    ProductID,
    ProductName,
    Category,
    TotalSales,
    SalesRank

FROM RankedProducts

WHERE SalesRank <= 3

ORDER BY Category, SalesRank;


-- TASK 4: MONTHLY SALES REPORT


WITH MonthlySales AS
(
    SELECT
        OL.ProductID,
        P.ProductName,

        DATE_FORMAT(O.OrderDate, '%Y-%m') AS SalesMonth,

        SUM(OL.Quantity * OL.UnitPrice) AS MonthlyRevenue

    FROM OrderLines OL

    JOIN Orders O
        ON OL.OrderID = O.OrderID

    JOIN Products P
        ON OL.ProductID = P.ProductID

    WHERE O.OrderStatus = 'Placed'

    GROUP BY
        OL.ProductID,
        P.ProductName,
        DATE_FORMAT(O.OrderDate, '%Y-%m')
),

SalesComparison AS
(
    SELECT
        ProductID,
        ProductName,
        SalesMonth,
        MonthlyRevenue,

        LAG(MonthlyRevenue) OVER (
            PARTITION BY ProductID
            ORDER BY SalesMonth
        ) AS PreviousMonthSales,

        LEAD(MonthlyRevenue) OVER (
            PARTITION BY ProductID
            ORDER BY SalesMonth
        ) AS NextMonthSales

    FROM MonthlySales
)

SELECT
    ProductID,
    ProductName,
    SalesMonth,
    MonthlyRevenue,
    PreviousMonthSales,
    NextMonthSales,

    MonthlyRevenue -
    COALESCE(PreviousMonthSales, 0) AS SalesChange

FROM SalesComparison

ORDER BY ProductID, SalesMonth;



SELECT * FROM Products;

SELECT * FROM Orders;

SELECT * FROM OrderLines;
