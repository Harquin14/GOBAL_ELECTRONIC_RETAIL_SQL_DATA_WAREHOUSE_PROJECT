/*
=================================================================
Stored Procedure: silver.load_silver
Description:
This stored procedure automates the ETL process of transforming 
and loading cleaned data into the silver layer tables from the 
bronze layer. It includes:
- Data cleaning, standardization, and normalization
- Execution time tracking
- Error handling
- Ensures idempotent data loading by truncating before inserting

Execution:
Run this procedure after loading bronze layer data to populate
and clean silver layer data.

=================================================================
*/

/*
=================================================================
Stored Procedure: silver.load_silver
Description:
This stored procedure automates the ETL process of transforming 
and loading cleaned data into the silver layer tables from the 
bronze layer. It includes:
- Data cleaning, standardization, and normalization
- Execution time tracking
- Error handling
- Ensures idempotent data loading by truncating before inserting

Execution:
Run this procedure after loading bronze layer data to populate
and clean silver layer data.

=================================================================
*/

CREATE OR ALTER PROCEDURE silver.load_silver AS
BEGIN
    DECLARE @start_time DATETIME, @end_time DATETIME;

    BEGIN TRY
        PRINT('Loading Silver Layer');
        PRINT('======================================================');

        -- ================= Exchange Rates =================
        PRINT('>>>> Loading silver.exchange_rates');
        SET @start_time = GETDATE();

        TRUNCATE TABLE silver.exchange_rates;
        INSERT INTO silver.exchange_rates([date], currency, exchange)
        SELECT [date], TRIM(currency), exchange
        FROM bronze.exchange_rates;

        SET @end_time = GETDATE();
        PRINT '>> LOAD DURATION: ' + CAST(DATEDIFF(SECOND, @start_time, @end_time) AS NVARCHAR) + ' Seconds';
        PRINT('======================================================');

        -- ================= Products =================
        PRINT('>>>> Loading silver.products');
        SET @start_time = GETDATE();
-- Truncate the target table before inserting new data
TRUNCATE TABLE silver.products;

-- Insert the cleaned data into the silver.products table
;WITH CleanedProducts AS (
    SELECT 
        productkey, 
        TRIM(REPLACE(productname, '"', '')) AS productname,
        TRIM(REPLACE(brand, '"', '')) AS brand,

        -- Cleaned color
        CASE 
            WHEN color <> TRIM(color) THEN NULL
            ELSE TRIM(color)
        END AS color,

        -- Cleaned unit cost cast back to NVARCHAR(10)
        CASE 
            WHEN unitcostusd IN ('Proseware', 'Blue', '"$1') THEN CAST(1.00 AS NVARCHAR(10)) 
            WHEN ISNUMERIC(REPLACE(unitcostusd, '$','')) = 1 THEN 
                CAST(TRY_CAST(REPLACE(unitcostusd, '$','') AS DECIMAL(18,2)) AS NVARCHAR(10))
            ELSE NULL
        END AS unitcostusd,

        -- Cleaned unit price cast back to NVARCHAR(10)
        CASE 
            WHEN TRIM(unitpriceusd) IN ('Black', 'Grey', '"$2', '"$1','Green','White','060.22 ') THEN NULL
            WHEN ISNUMERIC(REPLACE(unitpriceusd, '$','')) = 1 THEN 
                CAST(TRY_CAST(REPLACE(unitpriceusd, '$','') AS DECIMAL(18,2)) AS NVARCHAR(10))
            ELSE NULL
        END AS unitpriceusd,

        -- Cleaned subcategorykey cast back to NVARCHAR(60)
        CASE 
            WHEN TRIM(REPLACE(subcategorykey, '"', '')) = '$3' THEN CAST('0802' AS NVARCHAR(60))
            WHEN TRIM(REPLACE(subcategorykey, '"', '')) IN ('899.99','184.97','099.99','592.20') THEN CAST('0304' AS NVARCHAR(60))
            WHEN TRIM(REPLACE(subcategorykey, '"', '')) = '$32.00' THEN CAST('0702' AS NVARCHAR(60))
            WHEN TRIM(REPLACE(subcategorykey, '"', '')) IN ('$72.66','$73.12') THEN CAST('0306' AS NVARCHAR(60))
            WHEN TRIM(REPLACE(subcategorykey, '"', '')) IN ('000.00','620.00','600.00','580.00','560.00','530.00','520.00','500.00','030.00') THEN CAST('0402' AS NVARCHAR(60))
            WHEN TRIM(REPLACE(subcategorykey, '"', '')) IN ('989.90','989.00','818.00','818.90','652.90','599.90','599.00','652.00') THEN CAST('0801' AS NVARCHAR(60))
            WHEN TRIM(REPLACE(subcategorykey, '"', '')) = '499.00' THEN CAST('0305' AS NVARCHAR(60))
            WHEN TRIM(REPLACE(subcategorykey, '"', '')) = '475.00' THEN CAST('0804' AS NVARCHAR(60))
            WHEN TRIM(REPLACE(subcategorykey, '"', '')) IN ('299.00','199.00','099.00') THEN CAST('0301' AS NVARCHAR(60))
            WHEN TRIM(REPLACE(subcategorykey, '"', '')) = '295.00' THEN CAST('0305' AS NVARCHAR(60))
            WHEN TRIM(REPLACE(subcategorykey, '"', '')) = '109.00' THEN CAST('0203' AS NVARCHAR(60))
            WHEN TRIM(REPLACE(subcategorykey, '"', '')) = '650.00' THEN CAST('0805' AS NVARCHAR(60))
            ELSE CAST(REPLACE(TRIM(REPLACE(subcategorykey, '"', '')), '$', '') AS NVARCHAR(60))
        END AS subcategorykey,

        -- Cleaned subcategory
        CASE 
            WHEN TRIM(REPLACE(subcategory, '"', '')) = '$159.00' THEN 'Printers'
            WHEN TRIM(REPLACE(subcategory, '"', '')) = '$158.00' THEN 'Printers'
            WHEN TRIM(REPLACE(subcategory, '"', '')) = '0201' THEN 'Monitors'
            WHEN TRIM(REPLACE(subcategory, '"', '')) = '0301' THEN 'Laptops'
            WHEN TRIM(REPLACE(subcategory, '"', '')) = '0305' THEN 'Projectors & Screens'
            WHEN TRIM(REPLACE(subcategory, '"', '')) = '0405' THEN 'Digital SLR Cameras'
            WHEN TRIM(REPLACE(subcategory, '"', '')) = '0702' THEN 'Download Games'
            WHEN TRIM(REPLACE(subcategory, '"', '')) = '0801' THEN 'Washers & Dryers'
            WHEN TRIM(REPLACE(subcategory, '"', '')) = '0804' THEN 'Water Heaters'
            WHEN TRIM(REPLACE(subcategory, '"', '')) = '0805' THEN 'Coffee Machines'
            WHEN TRIM(REPLACE(subcategory, '"', '')) = '199.99' THEN 'Refrigerators'
            WHEN TRIM(REPLACE(subcategory, '"', '')) = '0203' THEN 'Home Theater System'
            ELSE TRIM(REPLACE(subcategory, '"', ''))
        END AS subcategory,

        -- Cleaned categorykey cast to NVARCHAR(30)
        CASE
            WHEN categorykey IN ('Washers & Dryers', 'Coffee Machines','0802','Water Heaters') THEN '08'
            WHEN categorykey IN ('Laptops','Projectors & Screens',' Scanners & Fax"','0306') THEN '03'
            WHEN categorykey = 'Camcorders' THEN '04'
            WHEN categorykey = 'Download Games' THEN '07'
            WHEN categorykey IN ('Televisions', 'Home Theater System') THEN '02'
            WHEN categorykey = 'Laptops' THEN '03'
            ELSE TRIM(CAST(categorykey AS NVARCHAR(30)))
        END AS categorykey,

        -- Cleaned category
        CASE 
            WHEN TRIM(REPLACE(category, '"', '')) LIKE '%Music, Movies and Audio Books%' THEN 'TV and Video'
            WHEN TRIM(REPLACE(category, '"', '')) LIKE '%03,Computers%' THEN 'Computers'
            WHEN TRIM(REPLACE(category, '"', '')) LIKE '%02,TV and Video%' THEN 'TV and Video'
            WHEN TRIM(REPLACE(category, '"', '')) LIKE '%Printers, Scanners & Fax%' THEN 'Computers'
            WHEN TRIM(REPLACE(category, '"', '')) LIKE '%08,Home Appliances%' 
                 OR TRIM(REPLACE(category, '"', '')) LIKE '%Refrigerators%' THEN 'Home Appliances'
            WHEN TRIM(REPLACE(category, '"', '')) LIKE '%07,Games and Toys%' THEN 'Games and Toys'
            WHEN TRIM(REPLACE(category, '"', '')) = '04,Cameras and camcorders' THEN 'Cameras and camcorders'
            ELSE TRIM(REPLACE(category, '"', '')) 
        END AS category
    FROM bronze.products
)
INSERT INTO silver.products (
    productkey, 
    productname, 
    brand, 
    color, 
    unitcostusd, 
    unitpriceusd, 
    subcategorykey, 
    subcategory, 
    categorykey, 
    category
)
SELECT 
    productkey, 
    productname, 
    brand, 
    color, 
    unitcostusd, 
    unitpriceusd, 
    subcategorykey, 
    subcategory, 
    categorykey, 
    category
FROM CleanedProducts
WHERE TRY_CAST(unitpriceusd AS DECIMAL(18,2)) IS NOT NULL
  AND TRY_CAST(unitpriceusd AS DECIMAL(18,2)) >= 0;



        SET @end_time = GETDATE();
        PRINT '>> LOAD DURATION: ' + CAST(DATEDIFF(SECOND, @start_time, @end_time) AS NVARCHAR) + ' Seconds';
        PRINT('======================================================');


		 PRINT '==========================================================================================='

                -- ================= Sales =================
        PRINT '>>>> Loading silver.sales';
        SET @start_time = GETDATE();

        TRUNCATE TABLE Silver.Sales;
        INSERT INTO Silver.Sales(OrderNumber, LineItem, OrderDate, DeliveryDate, CustomerKey,StoreKey,ProductKey, Quantity, CurrencyCode)
        SELECT 
            OrderNumber, LineItem, OrderDate, DeliveryDate, CustomerKey, StoreKey,ProductKey, Quantity, CurrencyCode
        FROM Bronze.Sales
		;

        SET @end_time = GETDATE();
        PRINT '>> LOAD DURATION: ' + CAST(DATEDIFF(SECOND, @start_time, @end_time) AS NVARCHAR) + ' Seconds';
        PRINT '============================================================';



        -- ================= Stores =================
        PRINT('>>>> Loading silver.stores');
        SET @start_time = GETDATE();

        TRUNCATE TABLE silver.stores;
        INSERT INTO silver.stores(storekey, country, state, squaremeters, opendate)
        SELECT storekey, country, state, squaremeters, opendate
        FROM bronze.stores;

        SET @end_time = GETDATE();
        PRINT '>> LOAD DURATION: ' + CAST(DATEDIFF(SECOND, @start_time, @end_time) AS NVARCHAR) + ' Seconds';
        PRINT('======================================================');

   -- ================= Customers =================
        PRINT('>>>> Loading silver.Customers');
        SET @start_time = GETDATE();

        TRUNCATE TABLE Silver.Customers;
        INSERT INTO Silver.Customers(CustomerKey,Gender,Name,City,StateCode,State,ZipCode,Country,Continent,Birthday)
        
SELECT 
		CustomerKey,
		Gender,
		Name,
		UPPER(LEFT(
		LTRIM(
		  STUFF(City, 1, PATINDEX('%[A-Za-z]%', City) - 1, '')
		), 1)) 
	+ 
	LOWER(SUBSTRING(
		LTRIM(
		  STUFF(City, 1, PATINDEX('%[A-Za-z]%', City) - 1, '')
		), 2, LEN(City))) AS City,   StateCode,State,
		 CASE 
			WHEN Country LIKE '%[0-9]%' THEN Country
			ELSE Country
		END AS ZipCode,
		 CASE 
			WHEN Continent IN ('Italy', 'Netherlands', 'Germany', 'United States', 'Australia','United Kingdom','Canada','France') THEN Continent
			ELSE NULL
		END AS Country,
		 LTRIM(RTRIM(LEFT(Birthday, CHARINDEX(',', Birthday) - 1))) AS Continent,
		 TRY_CAST(
		LTRIM(RTRIM(SUBSTRING(Birthday, CHARINDEX(',', Birthday) + 1, LEN(Birthday))))
		AS DATE
	  ) AS Birthdate
	  

FROM Bronze.Customers;

        SET @end_time = GETDATE();
        PRINT '>> LOAD DURATION: ' + CAST(DATEDIFF(SECOND, @start_time, @end_time) AS NVARCHAR) + ' Seconds';
        PRINT('======================================================');


    END TRY
    BEGIN CATCH
        PRINT('ERROR OCCURRED: ' + ERROR_MESSAGE());
        PRINT('ERROR NUMBER: ' + CAST(ERROR_NUMBER() AS NVARCHAR));
    END CATCH
END


EXEC  Silver.Load_Silver





