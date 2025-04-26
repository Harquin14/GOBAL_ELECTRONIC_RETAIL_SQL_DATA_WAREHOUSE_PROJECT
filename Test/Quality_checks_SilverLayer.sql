/* -----------------------------------------------------------
    Data Quality Checks for Silver Layer - Medallion Architecture
    Author: [Your Name]
    Project: [Project Name]
    Purpose: Ensure data consistency, completeness, and cleanliness
------------------------------------------------------------*/


/* -------------------------------
    Checks for Silver.Exchange_Rates
-------------------------------- */
-- Check for missing or invalid exchange rate values
SELECT * FROM Bronze.Exchange_Rates
WHERE Exchange IS NULL OR Exchange <= 0;

-- Check for unnecessary whitespaces in Currency field
SELECT * FROM Bronze.Exchange_Rates
WHERE Currency <> TRIM(Currency);

-- Check for missing dates
SELECT * FROM Bronze.Exchange_Rates
WHERE Date IS NULL;

-- View metadata for Exchange_Rates table
EXEC sp_help 'Bronze.Exchange_Rates';



/* -------------------------------
    Checks for Silver.Products
-------------------------------- */
-- Check for duplicate ProductKey
SELECT ProductKey, COUNT(*)  
FROM Bronze.Products
GROUP BY ProductKey
HAVING COUNT(*) > 1;

-- Check for improperly formatted ProductName
SELECT ProductName 
FROM Bronze.Products
WHERE ProductName LIKE '"%"';

-- Check for trailing quotation marks in Brand names
SELECT DISTINCT Brand 
FROM Bronze.Products
WHERE Brand LIKE '%"';

-- Check for missing Unit Cost and Unit Price
SELECT * FROM Bronze.Products
WHERE UnitCostUSD IS NULL;

SELECT * FROM Bronze.Products
WHERE UnitPriceUSD IS NULL;

-- Check for quotation mark issues in SubcategoryKey
SELECT SubcategoryKey 
FROM Bronze.Products
WHERE SubcategoryKey LIKE '%"';

-- Identify Subcategory fields with unexpected numeric strings
SELECT DISTINCT Subcategory, ProductName 
FROM Bronze.Products
WHERE Subcategory LIKE '199.99 "';

-- Standardize Subcategory naming
SELECT DISTINCT
    CASE 
        WHEN TRIM(REPLACE(Subcategory, '"', '')) = '$159.00' THEN 'Printers'
        WHEN TRIM(REPLACE(Subcategory, '"', '')) = '$158.00' THEN 'Printers'
        WHEN TRIM(REPLACE(Subcategory, '"', '')) = '0201' THEN 'Monitors'
        WHEN TRIM(REPLACE(Subcategory, '"', '')) = '0301' THEN 'Laptops'
        WHEN TRIM(REPLACE(Subcategory, '"', '')) = '0305' THEN 'Projectors & Screens'
        WHEN TRIM(REPLACE(Subcategory, '"', '')) = '0405' THEN 'Digital SLR Cameras'
        WHEN TRIM(REPLACE(Subcategory, '"', '')) = '0702' THEN 'Download Games'
        WHEN TRIM(REPLACE(Subcategory, '"', '')) = '0801' THEN 'Washers & Dryers'
        WHEN TRIM(REPLACE(Subcategory, '"', '')) = '0804' THEN 'Water Heaters'
        WHEN TRIM(REPLACE(Subcategory, '"', '')) = '0805' THEN 'Coffee Machines'
        WHEN TRIM(REPLACE(Subcategory, '"', '')) = '199.99' THEN 'Refrigerators'
        WHEN TRIM(REPLACE(Subcategory, '"', '')) = '0203' THEN 'Home Theater System'
        ELSE TRIM(REPLACE(Subcategory, '"', ''))
    END AS Subcategory, 
    Category
FROM Bronze.Products;

-- Validate 'Washers & Dryers' subcategory
SELECT DISTINCT Subcategory 
FROM Bronze.Products
WHERE Subcategory = 'Washers & Dryers';

-- Check UnitCostUSD for zero values after cleaning
SELECT 
    CASE 
        WHEN CAST(REPLACE(UnitCostUSD, '$', '') AS FLOAT) = 0 THEN 'NULL'
        ELSE UnitCostUSD
    END AS ValueStatus 
FROM Bronze.Products;

-- Detect bad SubcategoryKey values
SELECT SubcategoryKey, Subcategory, ProductName 
FROM Bronze.Products
WHERE SubcategoryKey LIKE '%"';

-- Verify 'Printers' subcategory
SELECT DISTINCT Subcategory 
FROM Bronze.Products
WHERE Subcategory = 'Printers';

-- Correct and clean SubcategoryKey values
SELECT DISTINCT 
    CASE 
        WHEN TRIM(REPLACE(SubcategoryKey, '"', '')) = '$3' THEN '0802'
        WHEN TRIM(REPLACE(SubcategoryKey, '"', '')) IN ('899.99','184.97','099.99','592.20') THEN '0304'
        WHEN TRIM(REPLACE(SubcategoryKey, '"', '')) = '$32.00' THEN '0702'
        WHEN TRIM(REPLACE(SubcategoryKey, '"', '')) IN ('$72.66','$73.12') THEN '0306'
        WHEN TRIM(REPLACE(SubcategoryKey, '"', '')) IN ('000.00','620.00','600.00','580.00','560.00','530.00','520.00','500.00','030.00') THEN '0402'
        WHEN TRIM(REPLACE(SubcategoryKey, '"', '')) IN ('989.90','989.00','818.00','818.90','652.90','599.90','599.00','652.00') THEN '0801'
        WHEN TRIM(REPLACE(SubcategoryKey, '"', '')) = '499.00' THEN '0305'
        WHEN TRIM(REPLACE(SubcategoryKey, '"', '')) = '475.00' THEN '0804'
        WHEN TRIM(REPLACE(SubcategoryKey, '"', '')) IN ('299.00','199.00','099.00') THEN '0301'
        WHEN TRIM(REPLACE(SubcategoryKey, '"', '')) = '295.00' THEN '0305'
        WHEN TRIM(REPLACE(SubcategoryKey, '"', '')) = '109.00' THEN '0203'
        WHEN TRIM(REPLACE(SubcategoryKey, '"', '')) = '650.00' THEN '0805'
        ELSE TRIM(REPLACE(SubcategoryKey, '"', ''))
    END AS SubcategoryKey 
FROM Bronze.Products;

-- Standardize CategoryKey values
SELECT DISTINCT
CASE
    WHEN CategoryKey IN ('Washers & Dryers', 'Coffee Machines','0802','Water Heaters') THEN '08'
    WHEN CategoryKey IN ('Laptops','Projectors & Screens',' Scanners & Fax"','0306') THEN '03'
    WHEN CategoryKey = 'Camcorders' THEN '04'
    WHEN CategoryKey = 'Download Games' THEN '07'
    WHEN CategoryKey IN ('Televisions', 'Home Theater System') THEN '02'
    ELSE TRIM(CategoryKey)
END AS CategoryKey
FROM Bronze.Products;

-- Standardize Category names
SELECT DISTINCT 
    CASE 
        WHEN TRIM(REPLACE(Category, '"', '')) LIKE '%Music, Movies and Audio Books%' THEN 'TV and Video'
        WHEN TRIM(REPLACE(Category, '"', '')) LIKE '%03,Computers%' THEN 'Computers'
        WHEN TRIM(REPLACE(Category, '"', '')) LIKE '%02,TV and Video%' THEN 'TV and Video'
        WHEN TRIM(REPLACE(Category, '"', '')) LIKE '%Printers, Scanners & Fax%' THEN 'Computers'
        WHEN TRIM(REPLACE(Category, '"', '')) LIKE '%08,Home Appliances%' OR 
             TRIM(REPLACE(Category, '"', '')) LIKE '%Refrigerators%' THEN 'Home Appliances'
        WHEN TRIM(REPLACE(Category, '"', '')) LIKE '%07,Games and Toys%' THEN 'Games and Toys'
        WHEN TRIM(REPLACE(Category, '"', '')) = '04,Cameras and camcorders' THEN 'Cameras and camcorders'
        ELSE TRIM(REPLACE(Category, '"', ''))
    END AS Category, 
    Subcategory
FROM Bronze.Products;

-- Review distinct categories and subcategories
SELECT DISTINCT Category, Subcategory 
FROM Bronze.Products
ORDER BY Category DESC;

-- Detect SubcategoryKey length issues
SELECT DISTINCT SubcategoryKey, Category, Subcategory 
FROM Bronze.Products
WHERE LEN(SubcategoryKey) > 6;

-- Identify improper UnitPriceUSD values
SELECT DISTINCT UnitPriceUSD   
FROM Bronze.Products
WHERE UnitCostUSD LIKE '"$';

-- Clean UnitCostUSD values
SELECT DISTINCT
CASE 
    WHEN UnitCostUSD IN ('Proseware', 'Blue', '"$1') THEN '1'
    ELSE REPLACE(UnitCostUSD, '$','')
END AS UnitCostUSD 
FROM Bronze.Products;

-- Clean UnitPriceUSD values
SELECT DISTINCT 
CASE 
    WHEN REPLACE(UnitPriceUSD,'$','') IN ('$Black','$"$2','$"$1','Grey$') THEN 'NULL'
    ELSE REPLACE(UnitPriceUSD,'$','')
END AS UnitPriceUSD 
FROM Bronze.Products;

-- Clean UnitPriceUSD special cases
SELECT DISTINCT 
    CASE 
        WHEN TRIM(UnitPriceUSD) IN ('Black', 'Grey', '"$2', '"$1', 'Green', 'White', '060.22 "') THEN 'null'
        ELSE REPLACE(UnitPriceUSD, '$', '') 
    END AS CleanedUnitPriceUSD
FROM Bronze.Products;

-- Check for trailing spaces in Color field
SELECT DISTINCT
CASE 
    WHEN Color <> TRIM(Color) THEN 'null'
    ELSE Color 
END AS Color
FROM Bronze.Products;



/* -------------------------------
    Checks for Silver.Sales
-------------------------------- */
-- Check for duplicate Quantity entries per Store
SELECT DISTINCT Quantity  
FROM Bronze.Sales 
GROUP BY StoreKey
HAVING COUNT(*) > 1;

-- Check for missing Order Dates
SELECT * FROM Bronze.Sales
WHERE OrderDate IS NULL;



/* -------------------------------
    Checks for Silver.Customers
-------------------------------- */
-- Extract City, ZipCode, and validate Country and Continent fields
SELECT 
    CustomerKey,
    Gender,
    Name,
    UPPER(LEFT(LTRIM(STUFF(City, 1, PATINDEX('%[A-Za-z]%', City) - 1, '')), 1)) +
    LOWER(SUBSTRING(LTRIM(STUFF(City, 1, PATINDEX('%[A-Za-z]%', City) - 1, '')), 2, LEN(City))) AS City,
    StateCode,
    State,
    CASE WHEN Country LIKE '%[0-9]%' THEN Country ELSE Country END AS ZipCode,
    CASE WHEN Continent IN ('Italy', 'Netherlands', 'Germany', 'United States', 'Australia','United Kingdom','Canada','France') THEN Continent ELSE NULL END AS Country,
    LTRIM(RTRIM(LEFT(Birthday, CHARINDEX(',', Birthday) - 1))) AS Continent,
    TRY_CAST(LTRIM(RTRIM(SUBSTRING(Birthday, CHARINDEX(',', Birthday) + 1, LEN(Birthday)))) AS DATE) AS Birthdate
FROM Bronze.Customers;

-- Check for trailing spaces in StateCode
SELECT * 
FROM Bronze.Customers
WHERE TRIM(StateCode) <> StateCode;

-- Extract Continent and Birthdate from Birthday field
SELECT
    LTRIM(RTRIM(LEFT(Birthday, CHARINDEX(',', Birthday) - 1))) AS Continent,
    TRY_CAST(LTRIM(RTRIM(SUBSTRING(Birthday, CHARINDEX(',', Birthday) + 1, LEN(Birthday)))) AS DATE) AS Birthdate
FROM Bronze.Customers;

-- Add Dwh_Date for tracking updates
UPDATE Silver.Customers
SET Dwh_Date = GETDATE();

-- Review Silver tables
SELECT * FROM Silver.Sales;
SELECT * FROM Silver.Customers;


/* -------------------------------
    Checks for Silver.Stores
-------------------------------- */
-- Drop unnecessary columns
ALTER TABLE Silver.Stores
DROP COLUMN Dwh_Date;
