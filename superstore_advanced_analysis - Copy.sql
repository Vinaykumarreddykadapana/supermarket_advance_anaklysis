
-- Superstore Sales Advanced SQL Insights

-- 1. Monthly Sales, Profit, and Order Volume
SELECT 
  DATE_FORMAT(STR_TO_DATE(`Order Date`, '%m/%d/%Y'), '%Y-%m') AS Month,
  ROUND(SUM(Sales), 2) AS TotalSales,
  ROUND(SUM(Profit), 2) AS TotalProfit,
  COUNT(DISTINCT `Order ID`) AS Orders
FROM Superstore
GROUP BY Month
ORDER BY Month;

-- 2. Top 10 Most Profitable Products
SELECT `Product Name`, 
       ROUND(SUM(Profit), 2) AS TotalProfit
FROM Superstore
GROUP BY `Product Name`
ORDER BY TotalProfit DESC
LIMIT 10;

-- 3. Sales by Region and Category
SELECT Region, Category, 
       ROUND(SUM(Sales), 2) AS TotalSales
FROM Superstore
GROUP BY Region, Category
ORDER BY Region, TotalSales DESC;

-- 4. Customers with High Profit Contribution
SELECT `Customer Name`, 
       ROUND(SUM(Profit), 2) AS TotalProfit
FROM Superstore
GROUP BY `Customer Name`
ORDER BY TotalProfit DESC
LIMIT 10;

-- 5. Average Shipping Delay by Ship Mode
SELECT `Ship Mode`,
       ROUND(AVG(DATEDIFF(STR_TO_DATE(`Ship Date`, '%m/%d/%Y'), STR_TO_DATE(`Order Date`, '%m/%d/%Y'))), 2) AS AvgShippingDelay
FROM Superstore
GROUP BY `Ship Mode`;

-- 6. Discount Impact on Profit
SELECT ROUND(Discount, 2) AS DiscountRate,
       ROUND(AVG(Profit), 2) AS AvgProfit
FROM Superstore
GROUP BY DiscountRate
ORDER BY DiscountRate;

-- 7. Return-Like Loss Detection (Negative Profits)
SELECT `Order ID`, `Product Name`, Sales, Profit
FROM Superstore
WHERE Profit < 0
ORDER BY Profit ASC;
