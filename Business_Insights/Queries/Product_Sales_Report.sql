-- ================================================
-- 🛍️ Product Sales and Pricing Report
-- Objective: Understand top-performing products, categories, brands, and pricing patterns
-- ================================================

-- 🔍 1. Top 10 best-selling products (by revenue)
SELECT * FROM (
    SELECT 
        p.Product_Key,
        p.Product_Name,
        FORMAT(SUM(s.Sales_USD), 'C0', 'en-US') AS Total_Sales,
        RANK() OVER (ORDER BY SUM(s.Sales_USD) DESC) AS Rank
    FROM Gold.fact_Sales s
    LEFT JOIN Gold.dim_Products p ON s.Product_Key = p.Product_Key
    GROUP BY p.Product_Key, p.Product_Name
) AS Ranked
WHERE Rank <= 10;

-- 🔍 2. Average selling price by product category
SELECT 
    Category,
    FORMAT(AVG(TRY_CAST(UnitPriceUSD AS DECIMAL(18,2))), 'C0', 'en-US') AS Average_Price
FROM Gold.dim_Products
GROUP BY Category
ORDER BY AVG(TRY_CAST(UnitPriceUSD AS DECIMAL(18,2))) DESC;

-- 🔍 3. Total quantity sold by subcategory
SELECT 
    Subcategory,
    SUM(Quantity) AS Quantity_Sold
FROM Gold.fact_Sales s
LEFT JOIN Gold.dim_Products p ON s.Product_Key = p.Product_Key
GROUP BY Subcategory
ORDER BY Quantity_Sold DESC;

-- 🔍 4. Which brand has the highest average revenue per order?
SELECT 
    Brand,
    FORMAT(SUM(s.Sales_USD) / COUNT(DISTINCT s.Order_Number), 'C0', 'en-US') AS Avg_Revenue_Per_Order
FROM Gold.fact_Sales s
LEFT JOIN Gold.dim_Products p ON s.Product_Key = p.Product_Key
GROUP BY Brand
ORDER BY SUM(s.Sales_USD) DESC;

-- 🔍 5. Products with no sales (Dead Stock)
SELECT 
    p.Product_Name,
    FORMAT(ISNULL(SUM(s.Sales_USD), 0), 'C0', 'en-US') AS No_Sales
FROM Gold.dim_Products p
LEFT JOIN Gold.fact_Sales s ON p.Product_Key = s.Product_Key
GROUP BY p.Product_Name
HAVING SUM(ISNULL(s.Sales_USD, 0)) = 0
ORDER BY p.Product_Name;
