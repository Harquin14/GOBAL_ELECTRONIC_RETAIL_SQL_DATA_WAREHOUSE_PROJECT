

---CREATING TABLES
IF OBJECT_ID('Bronze.Exchange_Rates', 'U') IS NOT NULL
DROP TABLE Bronze.Exchange_Rates;
CREATE TABLE Bronze.Exchange_Rates(
Date Date, Currency NVARCHAR(10),Exchange FLOAT(10)
);

IF OBJECT_ID('Bronze.Products', 'U') IS NOT NULL
DROP TABLE Bronze.Products;
CREATE TABLE Bronze.Products(
ProductKey INT, ProductName NVARCHAR(256), Brand NVARCHAR(50),Color NVARCHAR(50), UnitCostUSD FLOAT(10),
UnitPriceUSD FLOAT(10),SubcategoryKey INT, Subcategory NVARCHAR(50), CategoryKey INT, Category NVARCHAR(50)
);

IF OBJECT_ID('Bronze.Sales', 'U') IS NOT NULL
DROP TABLE Bronze.Sales;
CREATE TABLE Bronze.Sales( OrderNumber INT, LineItem INT, OrderDate Date, DeliveryDate Date, CustomerKey INT,StoreKey INT,
ProductKey INT, Quantity INT, CurrencyCode NVARCHAR(50)
);

IF OBJECT_ID('Bronze.Stores', 'U') IS NOT NULL
DROP TABLE Bronze.Stores;
CREATE TABLE Bronze.Stores( StoreKey INT, Country NVARCHAR(50), State NVARCHAR(256), SquareMeters INT, OpenDate Date);

IF OBJECT_ID('Bronze.Customers', 'U') IS NOT NULL
DROP TABLE Bronze.Customers;
CREATE TABLE Bronze.Customers( CustomerKey INT, Gender NVARCHAR(50), Name NVARCHAR(100), City NVARCHAR(200), StateCode NVARCHAR(10),
ZipCode INT, Country NVARCHAR(50), Continent NVARCHAR(50), Birthday Date );
