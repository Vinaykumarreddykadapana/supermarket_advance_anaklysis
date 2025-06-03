
-- Retail Sales Analytics Project (SQL Only)

-- 1. Create Tables

CREATE TABLE Customers (
    CustomerID INT PRIMARY KEY,
    CustomerName VARCHAR(100),
    Region VARCHAR(50)
);

CREATE TABLE Products (
    ProductID INT PRIMARY KEY,
    Category VARCHAR(50),
    SubCategory VARCHAR(50),
    ProductName VARCHAR(100),
    Price DECIMAL(10,2)
);

CREATE TABLE Orders (
    OrderID INT PRIMARY KEY,
    OrderDate DATE,
    CustomerID INT,
    ProductID INT,
    Quantity INT,
    FOREIGN KEY (CustomerID) REFERENCES Customers(CustomerID),
    FOREIGN KEY (ProductID) REFERENCES Products(ProductID)
);

-- 2. Insert Sample Data

-- Customers
INSERT INTO Customers VALUES
(1, 'Alice', 'London'),
(2, 'Bob', 'Manchester'),
(3, 'Charlie', 'Birmingham'),
(4, 'Diana', 'Leeds');

-- Products
INSERT INTO Products VALUES
(101, 'Electronics', 'Mobile', 'iPhone 13', 999.99),
(102, 'Electronics', 'Laptop', 'Dell XPS 13', 1199.99),
(103, 'Home', 'Kitchen', 'Toaster', 49.99),
(104, 'Home', 'Living', 'Lamp', 29.99);

-- Orders
INSERT INTO Orders VALUES
(1001, '2024-01-15', 1, 101, 1),
(1002, '2024-01-16', 2, 102, 1),
(1003, '2024-02-01', 1, 103, 2),
(1004, '2024-02-03', 3, 104, 1),
(1005, '2024-03-10', 4, 101, 1),
(1006, '2024-03-15', 1, 102, 1);

-- 3. Business Queries

-- Total Sales Revenue
SELECT SUM(o.Quantity * p.Price) AS TotalRevenue
FROM Orders o
JOIN Products p ON o.ProductID = p.ProductID;

-- Monthly Sales Trend
SELECT DATE_FORMAT(OrderDate, '%Y-%m') AS Month, 
       SUM(o.Quantity * p.Price) AS MonthlyRevenue
FROM Orders o
JOIN Products p ON o.ProductID = p.ProductID
GROUP BY Month
ORDER BY Month;

-- Top 3 Selling Products
SELECT p.ProductName, SUM(o.Quantity) AS UnitsSold
FROM Orders o
JOIN Products p ON o.ProductID = p.ProductID
GROUP BY p.ProductName
ORDER BY UnitsSold DESC
LIMIT 3;

-- Region-wise Sales
SELECT c.Region, SUM(o.Quantity * p.Price) AS RegionRevenue
FROM Orders o
JOIN Customers c ON o.CustomerID = c.CustomerID
JOIN Products p ON o.ProductID = p.ProductID
GROUP BY c.Region
ORDER BY RegionRevenue DESC;

-- Repeat Customers
SELECT o.CustomerID, COUNT(DISTINCT o.OrderID) AS OrderCount
FROM Orders o
GROUP BY o.CustomerID
HAVING OrderCount > 1;

-- 4. View for Dashboard
CREATE VIEW SalesDashboard AS
SELECT o.OrderID, o.OrderDate, c.CustomerName, c.Region, 
       p.ProductName, p.Category, o.Quantity, 
       (o.Quantity * p.Price) AS TotalPrice
FROM Orders o
JOIN Customers c ON o.CustomerID = c.CustomerID
JOIN Products p ON o.ProductID = p.ProductID;



--- 5. Profitability Analysis by Product Category
SELECT 
    Category,
    Sub_Category,
    SUM(Sales) AS Total_Sales,
    SUM(Profit) AS Total_Profit,
    (SUM(Profit)/SUM(Sales)) AS Profit_Margin,
    COUNT(DISTINCT Product_ID) AS Unique_Products,
    SUM(Quantity) AS Total_Units_Sold
FROM 
    Superstore
GROUP BY 
    Category, Sub_Category
ORDER BY 
    Profit_Margin DESC;

---6. Customer Segmentation by Profitability
WITH CustomerStats AS (
    SELECT 
        Customer_ID,
        Customer_Name,
        Segment,
        SUM(Sales) AS Total_Sales,
        SUM(Profit) AS Total_Profit,
        COUNT(DISTINCT Order_ID) AS Order_Count,
        SUM(Quantity) AS Total_Items_Purchased
    FROM 
        Superstore
    GROUP BY 
        Customer_ID, Customer_Name, Segment
)
SELECT 
    *,
    CASE 
        WHEN Total_Profit > 1000 THEN 'High Value'
        WHEN Total_Profit > 500 THEN 'Medium Value'
        WHEN Total_Profit > 0 THEN 'Low Value'
        ELSE 'Negative Value'
    END AS Customer_Value_Segment
FROM 
    CustomerStats
ORDER BY 
    Total_Profit DESC;

---7. Regional Performance Analysis
SELECT 
    Region,
    State,
    SUM(Sales) AS Total_Sales,
    SUM(Profit) AS Total_Profit,
    (SUM(Profit)/SUM(Sales)) AS Profit_Margin,
    COUNT(DISTINCT Customer_ID) AS Unique_Customers,
    COUNT(DISTINCT Order_ID) AS Order_Count
FROM 
    Superstore
GROUP BY 
    Region, State
ORDER BY 
    Region, Profit_Margin DESC;

---8. SELECT 
    Region,
    State,
    SUM(Sales) AS Total_Sales,
    SUM(Profit) AS Total_Profit,
    (SUM(Profit)/SUM(Sales)) AS Profit_Margin,
    COUNT(DISTINCT Customer_ID) AS Unique_Customers,
    COUNT(DISTINCT Order_ID) AS Order_Count
FROM 
    Superstore
GROUP BY 
    Region, State
ORDER BY 
    Region, Profit_Margin DESC;

--9. Shipping Mode Efficiency Analysis
SELECT 
    Ship_Mode,
    AVG(DATEDIFF(day, Order_Date, Ship_Date)) AS Avg_Shipping_Time,
    SUM(Sales) AS Total_Sales,
    SUM(Profit) AS Total_Profit,
    (SUM(Profit)/SUM(Sales)) AS Profit_Margin,
    COUNT(*) AS Order_Count
FROM 
    Superstore
GROUP BY 
    Ship_Mode
ORDER BY 
    Avg_Shipping_Time;

--10.Time Series Sales Analysis with Seasonality
SELECT 
    YEAR(Order_Date) AS Year,
    MONTH(Order_Date) AS Month,
    SUM(Sales) AS Monthly_Sales,
    SUM(Profit) AS Monthly_Profit,
    COUNT(DISTINCT Order_ID) AS Order_Count,
    SUM(Quantity) AS Total_Units_Sold
FROM 
    Superstore
GROUP BY 
    YEAR(Order_Date), MONTH(Order_Date)
ORDER BY 
    Year, Month;
