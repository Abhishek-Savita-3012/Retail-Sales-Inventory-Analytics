# Database Schema

This document describes the database schema for the **Retail Sales & Inventory Analytics** project. The database is designed using a normalized relational model (3NF) to efficiently manage customers, products, sales transactions, and inventory data.

---

# Entity Relationship Overview

```
Customers (1) --------< Sales >-------- (1) Products
                                   |
                                   |
                                   v
                              Inventory
```

- One customer can place multiple orders.
- One product can appear in multiple sales transactions.
- Each inventory record belongs to a product.

---

# 1. Customers Table

## Table Name
`customers`

### Description

Stores customer demographic and registration information.

### Schema

| Column | Data Type | Constraints | Description |
|---------|-----------|------------|-------------|
| CustomerID | INT | PRIMARY KEY | Unique customer identifier |
| CustomerName | VARCHAR(100) | NOT NULL | Customer's full name |
| Gender | VARCHAR(10) | NOT NULL | Gender of the customer |
| Age | INT | NOT NULL | Customer age |
| City | VARCHAR(50) | NOT NULL | Customer city |
| State | VARCHAR(50) | NOT NULL | Customer state |
| JoinDate | DATE | NOT NULL | Customer registration date |

### Business Questions

- How many customers does the company have?
- What are the customer demographics?
- Which customers are repeat buyers?
- Which cities have the highest number of customers?

---

# 2. Products Table

## Table Name
`products`

### Description

Stores product information including pricing and category details.

### Schema

| Column | Data Type | Constraints | Description |
|---------|-----------|------------|-------------|
| ProductID | INT | PRIMARY KEY | Unique product identifier |
| ProductName | VARCHAR(150) | NOT NULL | Product name |
| Category | VARCHAR(50) | NOT NULL | Main product category |
| SubCategory | VARCHAR(50) | NOT NULL | Product subcategory |
| CostPrice | DECIMAL(10,2) | NOT NULL | Product purchase cost |
| SellingPrice | DECIMAL(10,2) | NOT NULL | Product selling price |

### Business Questions

- Which products generate the highest sales?
- Which product categories perform the best?
- Which products have the highest profit margins?

---

# 3. Sales Table

## Table Name
`sales`

### Description

Stores individual customer purchase transactions. Each row represents one order item.

### Schema

| Column | Data Type | Constraints | Description |
|---------|-----------|------------|-------------|
| OrderID | INT | PRIMARY KEY | Unique order identifier |
| OrderDate | DATE | NOT NULL | Date of purchase |
| CustomerID | INT | FOREIGN KEY | References Customers table |
| ProductID | INT | FOREIGN KEY | References Products table |
| Quantity | INT | NOT NULL | Number of units sold |
| Discount | DECIMAL(5,2) | NOT NULL | Discount applied (%) |
| Sales | DECIMAL(10,2) | NOT NULL | Total sales amount |
| Profit | DECIMAL(10,2) | NOT NULL | Profit earned from the transaction |

### Business Questions

- What are the monthly sales trends?
- What are the daily sales trends?
- What is the total revenue generated?
- Which products generate the highest profit?
- Which customers purchase the most?
- Which products sell the most?

---

# 4. Inventory Table

## Table Name
`inventory`

### Description

Stores inventory information for each product across warehouses.

### Schema

| Column | Data Type | Constraints | Description |
|---------|-----------|------------|-------------|
| InventoryID | INT | PRIMARY KEY | Unique inventory record |
| ProductID | INT | FOREIGN KEY | References Products table |
| Warehouse | VARCHAR(50) | NOT NULL | Warehouse location |
| StockAvailable | INT | NOT NULL | Current stock quantity |
| ReorderLevel | INT | NOT NULL | Minimum stock threshold |
| LastRestocked | DATE | NOT NULL | Last inventory replenishment date |
| Supplier | VARCHAR(100) | NOT NULL | Supplier name |

### Business Questions

- Which products are running low on stock?
- What is the total inventory value?
- Which products should be reordered?
- How does inventory vary across warehouses?

---

# Table Relationships

| Parent Table | Child Table | Relationship |
|--------------|------------|--------------|
| Customers | Sales | One-to-Many |
| Products | Sales | One-to-Many |
| Products | Inventory | One-to-One (for this project) |

---

# Summary

This schema provides a strong foundation for performing:

- Sales Analysis
- Customer Segmentation
- Product Profitability Analysis
- Inventory Management
- ABC Analysis
- Sales Forecasting
- Inventory Forecasting
- Interactive Power BI Dashboards