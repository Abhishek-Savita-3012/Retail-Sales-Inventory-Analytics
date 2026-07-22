-- =====================================================
-- Retail Sales & Inventory Analytics Database Schema
-- =====================================================

DROP DATABASE IF EXISTS retail_analytics;

CREATE DATABASE retail_analytics;

USE retail_analytics;

-- =====================================================
-- Customers Table
-- =====================================================

CREATE TABLE customers (
    CustomerID INT PRIMARY KEY,
    CustomerName VARCHAR(100) NOT NULL,
    Gender VARCHAR(10) NOT NULL,
    Age INT NOT NULL,
    City VARCHAR(50) NOT NULL,
    State VARCHAR(50) NOT NULL,
    JoinDate DATE NOT NULL
);

DESCRIBE customers;

-- =====================================================
-- Products Table
-- =====================================================

CREATE TABLE products (
    ProductID INT PRIMARY KEY,
    ProductName VARCHAR(150) NOT NULL,
    Category VARCHAR(50) NOT NULL,
    SubCategory VARCHAR(50) NOT NULL,
    CostPrice DECIMAL(10,2) NOT NULL,
    SellingPrice DECIMAL(10,2) NOT NULL
);

DESCRIBE products;

-- =====================================================
-- Sales Table
-- =====================================================

CREATE TABLE sales (
    OrderID INT PRIMARY KEY,
    OrderDate DATE NOT NULL,
    CustomerID INT NOT NULL,
    ProductID INT NOT NULL,
    Quantity INT NOT NULL,
    Discount DECIMAL(5,2) DEFAULT 0,
    Sales DECIMAL(10,2) NOT NULL,
    Profit DECIMAL(10,2) NOT NULL,

    CONSTRAINT fk_sales_customer
        FOREIGN KEY (CustomerID)
        REFERENCES customers(CustomerID),

    CONSTRAINT fk_sales_product
        FOREIGN KEY (ProductID)
        REFERENCES products(ProductID)
);

DESCRIBE sales;

-- =====================================================
-- Inventory Table
-- =====================================================

CREATE TABLE inventory (
    InventoryID INT PRIMARY KEY,
    ProductID INT NOT NULL,
    Warehouse VARCHAR(50) NOT NULL,
    StockAvailable INT NOT NULL,
    ReorderLevel INT NOT NULL,
    LastRestocked DATE NOT NULL,
    Supplier VARCHAR(100) NOT NULL,

    CONSTRAINT fk_inventory_product
        FOREIGN KEY (ProductID)
        REFERENCES products(ProductID)
);

DESCRIBE inventory;

-- =====================================================
-- Indexes
-- =====================================================

CREATE INDEX idx_sales_customer
ON sales(CustomerID);

CREATE INDEX idx_sales_product
ON sales(ProductID);

CREATE INDEX idx_sales_orderdate
ON sales(OrderDate);

CREATE INDEX idx_inventory_product
ON inventory(ProductID);

CREATE INDEX idx_products_category
ON products(Category);

-- View All Tables
SHOW TABLES;

-- Check Foreign Keys
SELECT
    TABLE_NAME,
    COLUMN_NAME,
    CONSTRAINT_NAME,
    REFERENCED_TABLE_NAME,
    REFERENCED_COLUMN_NAME
FROM information_schema.KEY_COLUMN_USAGE
WHERE TABLE_SCHEMA = 'retail_analytics'
AND REFERENCED_TABLE_NAME IS NOT NULL;

-- Verify Row Counts
SELECT COUNT(*) AS TotalCustomers
FROM customers;

SELECT COUNT(*) AS TotalProducts
FROM products;

SELECT COUNT(*) AS TotalSales
FROM sales;

SELECT COUNT(*) AS TotalInventory
FROM inventory;

-- Preview Data
SELECT *
FROM customers
LIMIT 10;

SELECT *
FROM products
LIMIT 10;

SELECT *
FROM sales
LIMIT 10;

SELECT *
FROM inventory
LIMIT 10;

-- Verify Foreign Keys
-- Check Customer IDs
SELECT COUNT(*)
FROM sales s
LEFT JOIN customers c
ON s.CustomerID = c.CustomerID
WHERE c.CustomerID IS NULL;

-- Check Product IDs in Sales
SELECT COUNT(*)
FROM sales s
LEFT JOIN products p
ON s.ProductID = p.ProductID
WHERE p.ProductID IS NULL;

-- Check Product IDs in Inventory
SELECT COUNT(*)
FROM inventory i
LEFT JOIN products p
ON i.ProductID = p.ProductID
WHERE p.ProductID IS NULL;

-- Check for Duplicates
SELECT CustomerID,
       COUNT(*) AS Total
FROM customers
GROUP BY CustomerID
HAVING COUNT(*) > 1;

SELECT ProductID,
       COUNT(*) AS Total
FROM products
GROUP BY ProductID
HAVING COUNT(*) > 1;

SELECT OrderID,
       COUNT(*) AS Total
FROM sales
GROUP BY OrderID
HAVING COUNT(*) > 1;

-- Check for NULL Values
SELECT *
FROM customers
WHERE CustomerName IS NULL
   OR Gender IS NULL
   OR Age IS NULL
   OR City IS NULL
   OR State IS NULL
   OR JoinDate IS NULL;