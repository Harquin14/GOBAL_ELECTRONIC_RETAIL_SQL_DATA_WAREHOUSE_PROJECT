-- ================================================
-- 📊 Store Sales Performance Report
-- Objective: Analyze performance of stores by location, size, and monthly trends
-- ================================================

-- 🔍 1. Which store generated the highest total sales?
SELECT  
    st.Store_Key,
    st.Country,
    st.State,
    FORMAT(SUM(s.Sales_USD), 'C0', 'en-US') AS Highest_Revenue
FROM Gold.fact_Sales s
LEFT JOIN Gold.dim_Stores st ON s.Store_Key = st.Store_Key
GROUP BY st.Store_Key, st.Country, st.State
ORDER BY SUM(s.Sales_USD) DESC;

-- 🔍 2. What is the total number of orders per store?
SELECT  
    st.Store_Key,
    st.Country,
    st.State,
    COUNT(DISTINCT s.Order_Number) AS Total_Orders
FROM Gold.fact_Sales s
LEFT JOIN Gold.dim_Stores st ON s.Store_Key = st.Store_Key
GROUP BY st.Store_Key, st.Country, st.State
ORDER BY Total_Orders DESC;

-- 🔍 3. What is the average revenue per order by store?
WITH Base AS (
    SELECT  
        st.Store_Key,
        st.Country,
        st.State,
        COUNT(DISTINCT s.Order_Number) AS Total_Orders,
        SUM(s.Sales_USD) AS Total_Revenue
    FROM Gold.fact_Sales s
    JOIN Gold.dim_Stores st ON s.Store_Key = st.Store_Key
    GROUP BY st.Store_Key, st.Country, st.State
)
SELECT 
    Store_Key,
    Country,
    State,
    Total_Orders,
    FORMAT(Total_Revenue, 'C0', 'en-US') AS Total_Revenue,
    FORMAT(Total_Revenue / Total_Orders, 'C0', 'en-US') AS Avg_Revenue_Per_Order
FROM Base
ORDER BY Avg_Revenue_Per_Order DESC;

-- 🔍 4. Which country/state has the best-performing stores?
SELECT  
    st.Store_Key,
    st.Country,
    st.State,
    FORMAT(SUM(s.Sales_USD), 'C0', 'en-US') AS Total_Revenue,
    COUNT(DISTINCT s.Order_Number) AS Total_Orders
FROM Gold.fact_Sales s
LEFT JOIN Gold.dim_Stores st ON s.Store_Key = st.Store_Key
GROUP BY st.Store_Key, st.Country, st.State
ORDER BY SUM(s.Sales_USD) DESC;

-- 🔍 5. How does store size (square meters) relate to total sales?
SELECT  
    st.Store_Key,
    st.Country,
    st.State,
    st.Square_Meters,
    FORMAT(SUM(s.Sales_USD), 'C0', 'en-US') AS Total_Revenue
FROM Gold.fact_Sales s
LEFT JOIN Gold.dim_Stores st ON s.Store_Key = st.Store_Key
GROUP BY st.Store_Key, st.Country, st.State, st.Square_Meters
ORDER BY SUM(s.Sales_USD) DESC;

-- 🔍 6. Revenue contribution by store size category
SELECT
    CASE
        WHEN st.Square_Meters < 100 THEN 'Small'
        WHEN st.Square_Meters < 200 THEN 'Medium'
        ELSE 'Large'
    END AS Store_Size_Category,
    FORMAT(SUM(s.Sales_USD), 'C0', 'en-US') AS Total_Revenue_For_Category,
    COUNT(DISTINCT st.Store_Key) AS Number_Of_Stores
FROM Gold.fact_Sales s
LEFT JOIN Gold.dim_Stores st ON s.Store_Key = st.Store_Key
GROUP BY
    CASE
        WHEN st.Square_Meters < 100 THEN 'Small'
        WHEN st.Square_Meters < 200 THEN 'Medium'
        ELSE 'Large'
    END
ORDER BY SUM(s.Sales_USD) DESC;

-- 🔍 7. Monthly sales trend per store (based on order date)
SELECT  
    st.Store_Key,
    st.Open_Date,
    MONTH(s.Order_Date) AS Order_Month,
    FORMAT(SUM(s.Sales_USD), 'C0', 'en-US') AS Total_Sales
FROM Gold.fact_Sales s
LEFT JOIN Gold.dim_Stores st ON s.Store_Key = st.Store_Key
GROUP BY st.Store_Key, st.Open_Date, MONTH(s.Order_Date)
ORDER BY SUM(s.Sales_USD) DESC;
