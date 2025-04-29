-- ================================================
-- 👥 Customer Purchase Behavior Report
-- Objective: Analyze customer acquisition, retention, and spending behavior
-- ================================================

-- 🔍 1. Number of new customers acquired each month
WITH FirstPurchase AS (
    SELECT 
        c.Customer_Key,
        c.Name,
        MIN(s.Order_Date) AS First_Purchase_Date
    FROM Gold.fact_Sales s
    LEFT JOIN Gold.dim_Customers c ON s.Customer_Key = c.Customer_Key
    GROUP BY c.Customer_Key, c.Name
)
SELECT 
    FORMAT(First_Purchase_Date, 'yyyy-MM') AS Acquisition_Month,
    COUNT(*) AS New_Customers
FROM FirstPurchase
GROUP BY FORMAT(First_Purchase_Date, 'yyyy-MM')
ORDER BY Acquisition_Month;

-- 🔍 2. Total lifetime spend per customer
SELECT 
    c.Customer_Key,
    c.Name,
    FORMAT(SUM(s.Sales_USD), 'C0', 'en-US') AS Lifetime_Spend
FROM Gold.fact_Sales s
LEFT JOIN Gold.dim_Customers c ON s.Customer_Key = c.Customer_Key
GROUP BY c.Customer_Key, c.Name
ORDER BY SUM(s.Sales_USD) DESC;

-- 🔍 3. Segment customers by total spend
-- Segments: VIP (> $30,000), Regular ($10,000–$30,000), Low-Value (< $10,000)
SELECT 
    c.Customer_Key,
    c.Name,
    FORMAT(SUM(s.Sales_USD), 'C0', 'en-US') AS Total_Spend,
    CASE 
        WHEN SUM(s.Sales_USD) > 30000 THEN 'VIP'
        WHEN SUM(s.Sales_USD) BETWEEN 10000 AND 30000 THEN 'Regular'
        ELSE 'Low-Value'
    END AS Customer_Segment
FROM Gold.fact_Sales s
LEFT JOIN Gold.dim_Customers c ON s.Customer_Key = c.Customer_Key
GROUP BY c.Customer_Key, c.Name
ORDER BY SUM(s.Sales_USD) DESC;

-- 🔍 4. Average quantity of products purchased per customer
SELECT 
    c.Customer_Key, 
    c.Name, 
    AVG(s.Quantity) AS Average_Quantity_Purchased
FROM Gold.fact_Sales s
LEFT JOIN Gold.dim_Customers c ON s.Customer_Key = c.Customer_Key
GROUP BY c.Customer_Key, c.Name
ORDER BY Average_Quantity_Purchased DESC;

-- ================================================
-- 🔍 Helper Queries: Explore Dimensional/Fact Tables
-- ================================================
SELECT * FROM Gold.dim_Stores;
SELECT * FROM Gold.fact_Sales;
SELECT * FROM Gold.dim_Products;
SELECT * FROM Gold.dim_Customers;
