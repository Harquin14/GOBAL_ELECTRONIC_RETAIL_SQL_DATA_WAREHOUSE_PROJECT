-- ========================================
-- Project Summary:
-- This script builds the Gold layer views in a Data Warehouse project.
-- It transforms and structures data from the Silver layer into denormalized, 
-- analysis-ready views: dimensions and fact tables used for reporting and BI.
-- Key transformations include column renaming, derived keys, and data quality handling.
-- ========================================

-- ========================================
-- Create a dimension view for Customers
-- Renames and standardizes columns for reporting
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

-- ========================================
-- Create a dimension view for Exchange Rates
-- Adds a surrogate key (Currency_Key) using ROW_NUMBER
CREATE VIEW Gold.dim_Exchange_Rates AS
SELECT
  ROW_NUMBER() OVER(ORDER BY Date) AS Currency_Key,
  Date,
  Currency,
  Exchange
FROM Silver.Exchange_Rates;

-- ========================================
-- Create a dimension view for Products
-- Cleans and renames fields for standard use
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
  UnitCostUSD,
  UnitPriceUSD
FROM Silver.Products;

-- ========================================
-- Create a fact view for Sales
-- Replaces invalid UnitPriceUSD values with the average price
-- Computes total sales (Sales_USD) and joins with product and exchange rate dimensions
CREATE VIEW Gold.fact_Sales AS

-- CTE to calculate the average valid UnitPriceUSD
WITH AverageUnitPrice AS (
  SELECT AVG(CAST(UnitPriceUSD AS DECIMAL(18,2))) AS AveragePrice
  FROM Gold.dim_Products
  WHERE TRY_CAST(UnitPriceUSD AS DECIMAL(18,2)) IS NOT NULL
)

-- Main query: fact table transformation
SELECT 
  ROW_NUMBER() OVER(ORDER BY OrderDate) AS Order_Number,
  OrderDate AS Order_Date,
  DeliveryDate AS Delivery_Date,
  CustomerKey AS Customer_Key,
  StoreKey AS Store_Key,
  s.ProductKey AS Product_Key,
  LineItem AS Line_Item,

  -- If UnitPriceUSD is invalid, use the average price
  COALESCE(
    TRY_CAST(TRIM(p.UnitPriceUSD) AS DECIMAL(18,2)),
    (SELECT AveragePrice FROM AverageUnitPrice)
  ) AS Unit_Price_USD,

  Quantity,

  -- Compute total sales in USD and round to 2 decimal places
  ROUND(
    COALESCE(
      TRY_CAST(TRIM(p.UnitPriceUSD) AS DECIMAL(18,2)),
      (SELECT AveragePrice FROM AverageUnitPrice)
    ) * s.Quantity, 
  2) AS Sales_USD,

  -- Join with exchange rates to include currency metadata
  e.Currency_Key

FROM Silver.Sales s
JOIN Gold.dim_Products p
  ON s.ProductKey = p.Product_Key
JOIN Gold.dim_Exchange_Rates e
  ON s.CurrencyCode = e.Currency
  AND s.OrderDate = e.Date;

-- Optional: test view output
SELECT * FROM Gold.fact_Sales;

-- ========================================
-- Create a dimension view for Stores
-- Renames and reformats key store attributes
CREATE VIEW Gold.dim_Stores AS
SELECT 
  StoreKey AS Store_Key,
  Country,
  State,
  SquareMeters AS Square_Meters,
  OpenDate AS Open_Date
FROM Silver.Stores;

-- Optional: test view output
SELECT * FROM Gold.dim_Stores;
