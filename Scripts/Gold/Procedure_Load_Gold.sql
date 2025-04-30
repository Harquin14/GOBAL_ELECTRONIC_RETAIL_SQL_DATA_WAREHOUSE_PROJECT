-- ========================================
-- 🛠️ GOLD LAYER BUILD SCRIPT
-- ========================================
-- Project: Modern Data Warehouse (Global Electronic Retailers)
-- Layer: Gold (Business-ready Layer)
-- Purpose:
--   - Transform curated Silver Layer data into final dimension and fact views
--   - Standardize naming conventions and formats
--   - Enrich fact data with calculated fields
--   - Prepare data for reporting (SQL-based analytics or BI tools like Tableau)
-- ========================================

-- ========================================
-- 📌 DIMENSION: Customers
-- Renames columns and applies standard naming for use in BI tools
-- ========================================
CREATE VIEW Gold.dim_Customers AS
SELECT  
  CustomerKey AS Customer_Key,
  Name,
  Gender,
  Birthday,
  Continent,
  Country,
  State,
  City,
  ZipCode AS Zip_Code,
  StateCode AS State_Code
FROM Silver.Customers;

-- ✅ Preview
SELECT * FROM Gold.dim_Customers;

-- ========================================
-- 📌 DIMENSION: Exchange Rates
-- Adds a surrogate key (Currency_Key) and includes exchange rate details
-- ========================================
CREATE VIEW Gold.dim_Exchange_Rates AS
SELECT
  ROW_NUMBER() OVER(ORDER BY Date) AS Currency_Key,
  Date,
  Currency,
  Exchange
FROM Silver.Exchange_Rates;

-- ✅ Preview
SELECT * FROM Gold.dim_Exchange_Rates;

-- ========================================
-- 📌 DIMENSION: Products
-- Cleans and renames product fields for consistency and usability
-- ========================================
CREATE VIEW Gold.dim_Products AS 
SELECT 
  CategoryKey AS Category_Key,
  Category,
  SubcategoryKey AS Subcategory_Key,
  Subcategory,
  Brand,
  ProductKey AS Product_Key,
  ProductName AS Product_Name,
  Color,
  UnitCostUSD AS Unit_Cost_USD,
  UnitPriceUSD AS Unit_Price_USD
FROM Silver.Products;

-- ✅ Preview
SELECT * FROM Gold.dim_Products;

-- ========================================
-- 📊 FACT: Sales
-- Handles invalid prices, calculates Sales_USD, and links to exchange rates
-- ========================================
CREATE VIEW Gold.fact_Sales AS

-- CTE: Compute average Unit Price for use as fallback
WITH AverageUnitPrice AS (
  SELECT AVG(CAST(UnitPriceUSD AS DECIMAL(18,2))) AS AveragePrice
  FROM Gold.dim_Products
  WHERE TRY_CAST(UnitPriceUSD AS DECIMAL(18,2)) IS NOT NULL
)

-- Main Query: Transforms sales records and joins lookup tables
SELECT 
  ROW_NUMBER() OVER(ORDER BY OrderDate) AS Order_Number,
  OrderDate AS Order_Date,
  DeliveryDate AS Delivery_Date,
  CustomerKey AS Customer_Key,
  StoreKey AS Store_Key,
  s.ProductKey AS Product_Key,
  LineItem AS Line_Item,

  -- Sanitize Unit_Price_USD (fallback to average if invalid)
  COALESCE(
    TRY_CAST(TRIM(p.UnitPriceUSD) AS DECIMAL(18,2)),
    (SELECT AveragePrice FROM AverageUnitPrice)
  ) AS Unit_Price_USD,

  Quantity,

  -- Total sales in USD
  ROUND(
    COALESCE(
      TRY_CAST(TRIM(p.UnitPriceUSD) AS DECIMAL(18,2)),
      (SELECT AveragePrice FROM AverageUnitPrice)
    ) * s.Quantity, 
  2) AS Sales_USD,

  -- Add currency surrogate key for exchange rate context
  e.Currency_Key

FROM Silver.Sales s
JOIN Gold.dim_Products p
  ON s.ProductKey = p.Product_Key
JOIN Gold.dim_Exchange_Rates e
  ON s.CurrencyCode = e.Currency
  AND s.OrderDate = e.Date;

-- ✅ Preview
SELECT * FROM Gold.fact_Sales;

-- ========================================
-- 📌 DIMENSION: Stores
-- Creates Store_Name using Country and State; renames columns for clarity
-- ========================================
CREATE VIEW Gold.dim_Stores AS
SELECT 
  StoreKey AS Store_Key,
  CASE 
    WHEN Country = 'Online' THEN 'Online Store'
    ELSE Country + ' - ' + State
  END AS Store_Name,
  Country,
  State,
  SquareMeters AS Square_Meters,
  OpenDate AS Open_Date
FROM Silver.Stores;

-- ✅ Preview
SELECT * FROM Gold.dim_Stores;
