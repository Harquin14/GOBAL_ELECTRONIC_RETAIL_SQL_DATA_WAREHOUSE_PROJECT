---CREATING TABLES
IF OBJECT_ID('Silver.Exchange_Rates', 'U') IS NOT NULL
DROP TABLE Silver.Exchange_Rates;
CREATE TABLE Silver.Exchange_Rates(
Date Date, Currency NVARCHAR(10),Exchange FLOAT(10),Dwh_Date Date
);

IF OBJECT_ID('Silver.Products', 'U') IS NOT NULL
DROP TABLE Silver.Products;
CREATE TABLE Silver.Products(
ProductKey INT, ProductName NVARCHAR(256), Brand NVARCHAR(50),Color NVARCHAR(50), UnitCostUSD NVARCHAR(10),
UnitPriceUSD NVARCHAR(10),SubcategoryKey NVARCHAR(60), Subcategory NVARCHAR(50), CategoryKey NVARCHAR(30), 
Category NVARCHAR(50)
);

IF OBJECT_ID('Silver.Sales', 'U') IS NOT NULL
DROP TABLE Silver.Sales;
CREATE TABLE Silver.Sales( OrderNumber INT, LineItem INT, OrderDate Date, DeliveryDate Date, CustomerKey INT,StoreKey INT,
ProductKey INT, Quantity INT, CurrencyCode NVARCHAR(50)
);

IF OBJECT_ID('Silver.Stores', 'U') IS NOT NULL
DROP TABLE Silver.Stores;
CREATE TABLE Silver.Stores( StoreKey INT, Country NVARCHAR(50), State NVARCHAR(256), SquareMeters INT, OpenDate Date);

IF OBJECT_ID('Silver.Customers', 'U') IS NOT NULL
DROP TABLE Silver.Customers;
CREATE TABLE Silver.Customers( CustomerKey INT, Gender NVARCHAR(50), Name NVARCHAR(100), City NVARCHAR(200), StateCode NVARCHAR(50),
ZipCode NVARCHAR(50), Country NVARCHAR(50), Continent NVARCHAR(50), Birthday NVARCHAR(50),State NVARCHAR(50) );
