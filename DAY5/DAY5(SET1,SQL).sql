CREATE DATABASE RetailInventoryDB;
USE RetailInventoryDB;
SELECT DATABASE();
CREATE TABLE Categories (
    category_id INT PRIMARY KEY,
    category_name VARCHAR(100) NOT NULL UNIQUE
);

-- 2. Suppliers
CREATE TABLE Suppliers (
    supplier_id INT PRIMARY KEY,
    supplier_name VARCHAR(100) NOT NULL,
    supplier_phone VARCHAR(15) NOT NULL UNIQUE
);

-- 3. Warehouses
CREATE TABLE Warehouses (
    warehouse_id INT PRIMARY KEY,
    warehouse_name VARCHAR(100) NOT NULL UNIQUE,
    location VARCHAR(100) NOT NULL
);

-- 4. Products
CREATE TABLE Products (
    sku VARCHAR(20) PRIMARY KEY,
    product_name VARCHAR(100) NOT NULL,
    category_id INT NOT NULL,
    supplier_id INT NOT NULL,

    FOREIGN KEY (category_id)
        REFERENCES Categories(category_id),

    FOREIGN KEY (supplier_id)
        REFERENCES Suppliers(supplier_id)
);

-- 5. Inventory
CREATE TABLE Inventory (
    inventory_id INT PRIMARY KEY,
    sku VARCHAR(20) NOT NULL,
    warehouse_id INT NOT NULL,
    quantity INT NOT NULL DEFAULT 0,
    reorder_level INT NOT NULL DEFAULT 10,

    CONSTRAINT chk_quantity CHECK (quantity >= 0),
    CONSTRAINT chk_reorder CHECK (reorder_level >= 0),
    CONSTRAINT uq_sku_warehouse UNIQUE (sku, warehouse_id),

    FOREIGN KEY (sku)
        REFERENCES Products(sku)
        ON DELETE CASCADE,

    FOREIGN KEY (warehouse_id)
        REFERENCES Warehouses(warehouse_id)
);
SHOW TABLES;

USE RetailInventoryDB;

-- 1. Categories
INSERT INTO Categories VALUES
(1,'Electronics'),
(2,'Clothing'),
(3,'Furniture'),
(4,'Books'),
(5,'Groceries'),
(6,'Sports'),
(7,'Footwear'),
(8,'Beauty'),
(9,'Kitchen'),
(10,'Accessories');

-- 2. Suppliers
INSERT INTO Suppliers VALUES
(1,'ABC Suppliers','9876543210'),
(2,'Global Traders','9876543211'),
(3,'Tech World','9876543212'),
(4,'Fashion Hub','9876543213'),
(5,'Home Needs','9876543214'),
(6,'Book House','9876543215'),
(7,'Fresh Mart','9876543216'),
(8,'Sports Zone','9876543217'),
(9,'Style Point','9876543218'),
(10,'Daily Essentials','9876543219');

-- 3. Warehouses
INSERT INTO Warehouses VALUES
(1,'Chennai Central','Chennai'),
(2,'Bangalore Store','Bangalore'),
(3,'Mumbai Depot','Mumbai'),
(4,'Delhi Warehouse','Delhi'),
(5,'Hyderabad Hub','Hyderabad'),
(6,'Pune Store','Pune'),
(7,'Kochi Depot','Kochi'),
(8,'Coimbatore Hub','Coimbatore'),
(9,'Madurai Store','Madurai'),
(10,'Salem Warehouse','Salem');

-- 4. Products
INSERT INTO Products VALUES
('P101','Laptop',1,3),
('P102','T-Shirt',2,4),
('P103','Office Chair',3,5),
('P104','SQL Book',4,6),
('P105','Rice Bag',5,7),
('P106','Football',6,8),
('P107','Running Shoes',7,9),
('P108','Face Wash',8,10),
('P109','Mixer Grinder',9,5),
('P110','Smart Watch',1,1);

-- 5. Inventory
INSERT INTO Inventory VALUES
(1,'P101',1,50,10),
(2,'P102',2,100,20),
(3,'P103',3,30,5),
(4,'P104',4,75,15),
(5,'P105',5,200,30),
(6,'P106',6,40,10),
(7,'P107',7,60,12),
(8,'P108',8,90,15),
(9,'P109',9,25,5),
(10,'P110',10,45,10);
SELECT * FROM Categories;
SELECT * FROM Suppliers;
SELECT * FROM Warehouses;
SELECT * FROM Products;
SELECT * FROM Inventory;
SELECT COUNT(*) FROM Categories;
SELECT COUNT(*) FROM Suppliers;
SELECT COUNT(*) FROM Warehouses;
SELECT COUNT(*) FROM Products;
SELECT COUNT(*) FROM Inventory;
INSERT INTO Categories
VALUES (1, 'Duplicate Electronics');
INSERT INTO Products
VALUES ('P999', 'Gaming Mouse', 999, 1);
INSERT INTO Inventory
VALUES (11, 'P101', 1, -50, 10);
INSERT INTO Suppliers
VALUES (11, NULL, '9123456780');
SELECT * FROM Suppliers
WHERE supplier_id = 1;
UPDATE Suppliers
SET supplier_phone = '9123456780'
WHERE supplier_id = 1;
SELECT * FROM Suppliers
WHERE supplier_id = 1;
SELECT * FROM Products
WHERE sku = 'P110';

SELECT * FROM Inventory
WHERE sku = 'P110';

DELETE FROM Products
WHERE sku = 'P110';
