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

SELECT ROUND(AVG(Sales),2) AS AverageOrderValue
FROM sales;

-- =====================================================
-- Lesson 6 - Business Analysis Queries
-- =====================================================

-- What is our Total Revenue?
SELECT
    ROUND(SUM(Sales),2) AS TotalRevenue
FROM sales;

-- What is our Total Profit?
SELECT
    ROUND(SUM(Profit),2) AS TotalProfit
FROM sales;

-- How many orders do we have?
SELECT
    COUNT(*) AS TotalOrders
FROM sales;

-- How many customers?
SELECT
    COUNT(*) AS TotalCustomers
FROM customers;

-- How many products?
SELECT
    COUNT(*) AS TotalProducts
FROM products;

-- Average Order Value
SELECT
    ROUND(AVG(Sales),2) AS AverageOrderValue
FROM sales;

-- Average Profit Per Order
SELECT
    ROUND(AVG(Profit),2) AS AverageProfit
FROM sales;

-- Top 10 Best Selling Products
SELECT
    p.ProductName,
    SUM(s.Quantity) AS UnitsSold,
    ROUND(SUM(s.Sales),2) AS Revenue
FROM sales s
JOIN products p
ON s.ProductID = p.ProductID
GROUP BY p.ProductName
ORDER BY Revenue DESC
LIMIT 10;

-- Top 10 Most Profitable Products
SELECT
    p.ProductName,
    ROUND(SUM(s.Profit),2) AS TotalProfit
FROM sales s
JOIN products p
ON s.ProductID = p.ProductID
GROUP BY p.ProductName
ORDER BY TotalProfit DESC
LIMIT 10;

-- Top 10 Customers
SELECT
    c.CustomerName,
    ROUND(SUM(s.Sales),2) AS TotalSpent
FROM sales s
JOIN customers c
ON s.CustomerID = c.CustomerID
GROUP BY c.CustomerName
ORDER BY TotalSpent DESC
LIMIT 10;

-- Sales by Category
SELECT
    p.Category,
    ROUND(SUM(s.Sales),2) AS Revenue,
    ROUND(SUM(s.Profit),2) AS Profit
FROM sales s
JOIN products p
ON s.ProductID = p.ProductID
GROUP BY p.Category
ORDER BY Revenue DESC;

-- Quantity Sold by Category
SELECT
    p.Category,
    SUM(s.Quantity) AS TotalUnits
FROM sales s
JOIN products p
ON s.ProductID = p.ProductID
GROUP BY p.Category
ORDER BY TotalUnits DESC;

-- Average Discount by Category
SELECT
    p.Category,
    ROUND(AVG(s.Discount),2) AS AverageDiscount
FROM sales s
JOIN products p
ON s.ProductID = p.ProductID
GROUP BY p.Category
ORDER BY AverageDiscount DESC;

-- Products Never Sold
SELECT
    p.ProductID,
    p.ProductName
FROM products p
LEFT JOIN sales s
ON p.ProductID = s.ProductID
WHERE s.ProductID IS NULL;

-- Highest Inventory Products
SELECT
    p.ProductName,
    i.StockAvailable
FROM inventory i
JOIN products p
ON i.ProductID = p.ProductID
ORDER BY i.StockAvailable DESC
LIMIT 10;

-- Low Stock Products
SELECT
    p.ProductName,
    i.StockAvailable,
    i.ReorderLevel
FROM inventory i
JOIN products p
ON i.ProductID = p.ProductID
WHERE i.StockAvailable <= i.ReorderLevel
ORDER BY i.StockAvailable;

-- Revenue by State
SELECT
    c.State,
    ROUND(SUM(s.Sales),2) AS Revenue
FROM sales s
JOIN customers c
ON s.CustomerID = c.CustomerID
GROUP BY c.State
ORDER BY Revenue DESC;

-- Revenue by City
SELECT
    c.City,
    ROUND(SUM(s.Sales),2) AS Revenue
FROM sales s
JOIN customers c
ON s.CustomerID = c.CustomerID
GROUP BY c.City
ORDER BY Revenue DESC
LIMIT 20;

-- Average Customer Age
SELECT
    ROUND(AVG(Age),1) AS AverageAge
FROM customers;

-- Customer Distribution by Gender
SELECT
    Gender,
    COUNT(*) AS Customers
FROM customers
GROUP BY Gender;

-- =====================================================
-- Lesson 7 - Advanced SQL Analytics
-- =====================================================

-- Monthly Sales Trend
SELECT
    YEAR(OrderDate) AS Year,
    MONTH(OrderDate) AS Month,
    ROUND(SUM(Sales),2) AS Revenue
FROM sales
GROUP BY
    YEAR(OrderDate),
    MONTH(OrderDate)
ORDER BY
    Year,
    Month;
    
-- Monthly Profit Trend
SELECT
    YEAR(OrderDate) AS Year,
    MONTH(OrderDate) AS Month,
    ROUND(SUM(Profit),2) AS Profit
FROM sales
GROUP BY
    YEAR(OrderDate),
    MONTH(OrderDate)
ORDER BY
    Year,
    Month;
    
-- Top 5 Products in Every Category
WITH ProductRevenue AS (
SELECT
    p.Category,
    p.ProductName,
    ROUND(SUM(s.Sales),2) AS Revenue
FROM sales s
JOIN products p
ON s.ProductID=p.ProductID
GROUP BY
    p.Category,
    p.ProductName
)
SELECT *
FROM (
SELECT *,
ROW_NUMBER() OVER(
PARTITION BY Category
ORDER BY Revenue DESC
) AS RowNum
FROM ProductRevenue
) Ranked
WHERE RowNum<=5;

-- Rank Products by Revenue
SELECT
    p.ProductName,
    ROUND(SUM(s.Sales),2) AS Revenue,
    RANK() OVER(
        ORDER BY SUM(s.Sales) DESC
    ) AS ProductRank
FROM sales s
JOIN products p
ON s.ProductID=p.ProductID
GROUP BY p.ProductName;

-- Dense Rank Products
SELECT
    p.ProductName,
    ROUND(SUM(s.Sales),2) AS Revenue,
    DENSE_RANK() OVER(
        ORDER BY SUM(s.Sales) DESC
    ) AS DenseRank
FROM sales s
JOIN products p
ON s.ProductID=p.ProductID
GROUP BY p.ProductName;

-- Running Total Revenue
WITH MonthlySales AS (
SELECT
YEAR(OrderDate) AS Year,
MONTH(OrderDate) AS Month,
SUM(Sales) AS Revenue
FROM sales
GROUP BY
YEAR(OrderDate),
MONTH(OrderDate)
)
SELECT
*,
SUM(Revenue)
OVER(
ORDER BY Year,Month
) AS RunningRevenue
FROM MonthlySales;

-- Month-over-Month Growth
WITH MonthlySales AS (
SELECT
YEAR(OrderDate) AS Year,
MONTH(OrderDate) AS Month,
ROUND(SUM(Sales),2) AS Revenue
FROM sales
GROUP BY
YEAR(OrderDate),
MONTH(OrderDate)
)
SELECT
*,
LAG(Revenue)
OVER(
ORDER BY Year,Month
) AS PreviousMonthRevenue,
ROUND(
Revenue-
LAG(Revenue)
OVER(
ORDER BY Year,Month
),2
) AS RevenueGrowth
FROM MonthlySales;

-- Average Sales Per Customer
SELECT
CustomerID,
ROUND(AVG(Sales),2) AS AveragePurchase
FROM sales
GROUP BY CustomerID
ORDER BY AveragePurchase DESC
LIMIT 20;

-- Customer Lifetime Revenue
SELECT
c.CustomerName,
ROUND(SUM(s.Sales),2) AS LifetimeRevenue
FROM sales s
JOIN customers c
ON s.CustomerID=c.CustomerID
GROUP BY c.CustomerName
ORDER BY LifetimeRevenue DESC
LIMIT 20;

-- Product Performance
SELECT
p.ProductName,
SUM(s.Quantity) AS UnitsSold,
ROUND(SUM(s.Sales),2) AS Revenue,
ROUND(SUM(s.Profit),2) AS Profit
FROM sales s
JOIN products p
ON s.ProductID=p.ProductID
GROUP BY p.ProductName
ORDER BY Revenue DESC;

-- Inventory Value
SELECT
Warehouse,
ROUND(
SUM(
StockAvailable*
p.CostPrice
),2
) AS InventoryValue
FROM inventory i
JOIN products p
ON i.ProductID=p.ProductID
GROUP BY Warehouse;

-- Products Below Reorder Level
SELECT
p.ProductName,
Warehouse,
StockAvailable,
ReorderLevel
FROM inventory i
JOIN products p
ON i.ProductID=p.ProductID
WHERE StockAvailable<ReorderLevel;

-- Top Revenue States
SELECT
c.State,
ROUND(SUM(s.Sales),2) AS Revenue,
RANK()
OVER(
ORDER BY SUM(s.Sales) DESC
) AS StateRank
FROM sales s
JOIN customers c
ON s.CustomerID=c.CustomerID
GROUP BY c.State;

-- Sales Contribution %
SELECT
p.Category,
ROUND(SUM(s.Sales),2) AS Revenue,
ROUND(
SUM(s.Sales)*100/
(
SELECT SUM(Sales)
FROM sales
)
,2)
AS RevenuePercentage
FROM sales s
JOIN products p
ON s.ProductID=p.ProductID
GROUP BY p.Category;

-- Top 10 Orders
SELECT
OrderID,
CustomerID,
Sales
FROM sales
ORDER BY Sales DESC
LIMIT 10;