-- ============================================
-- Basic Validation Queries
-- ============================================

USE retail_analytics;

SELECT COUNT(*) FROM customers;
SELECT COUNT(*) FROM products;
SELECT COUNT(*) FROM sales;
SELECT COUNT(*) FROM inventory;

-- Preview Data

SELECT * FROM customers LIMIT 10;
SELECT * FROM products LIMIT 10;
SELECT * FROM sales LIMIT 10;
SELECT * FROM inventory LIMIT 10;

-- Business KPIs

SELECT ROUND(SUM(Sales),2) AS TotalSales
FROM sales;

SELECT ROUND(SUM(Profit),2) AS TotalProfit
FROM sales;

SELECT COUNT(*) AS TotalCustomers
FROM customers;

SELECT COUNT(*) AS TotalProducts
FROM products;

SELECT ROUND(AVG(Sales),2) AS AverageOrderValue
FROM sales;