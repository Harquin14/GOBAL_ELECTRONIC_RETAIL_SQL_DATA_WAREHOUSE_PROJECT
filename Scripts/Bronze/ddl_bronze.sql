-- =============================================
-- Create tables in Bronze layer (raw data)
-- =============================================

-- Drop and recreate Bronze.Exchange_Rates table if it already exists
IF OBJECT_ID('Bronze.Exchange_Rates', 'U') IS NOT NULL
    DROP TABLE Bronze.Exchange_Rates;
CREATE TABLE Bronze.Exchange_Rates (
    Date DATE,
    Currency NVARCHAR(10),
    Exchange FLOAT(10)    -- Note: FLOAT(10) is equivalent to FLOAT; precision is not enforced
);

-- Drop and recreate Bronze.Products table
IF OBJECT_ID('Bronze.Products', 'U') IS NOT NULL
    DROP TABLE Bronze.Products;
CREATE TABLE Bronze.Products (
    ProductKey INT,
    ProductName NVARCHAR(256),
    Brand NVARCHAR(50),
    Color NVARCHAR(50),
    UnitCostUSD NVARCHAR(10),     -- Stored as string to match raw CSV; can be cast in Silver layer
    UnitPriceUSD NVARCHAR(10),
    SubcategoryKey NVARCHAR(20),
    Subcategory NVARCHAR(50),
    CategoryKey NVARCHAR(30),
    Category NVARCHAR(50)
);

-- Drop and recreate Bronze.Sales table
IF OBJECT_ID('Bronze.Sales', 'U') IS NOT NULL
    DROP TABLE Bronze.Sales;
CREATE TABLE Bronze.Sales (
    OrderNumber INT,
    LineItem INT,
    OrderDate DATE,
    DeliveryDate DATE,
    CustomerKey INT,
    StoreKey INT,
    ProductKey INT,
    Quantity INT,
    CurrencyCode NVARCHAR(50)
);

-- Drop and recreate Bronze.Stores table
IF OBJECT_ID('Bronze.Stores', 'U') IS NOT NULL
    DROP TABLE Bronze.Stores;
CREATE TABLE Bronze.Stores (
    StoreKey INT,
    Country NVARCHAR(50),
    State NVARCHAR(256),
    SquareMeters INT,
    OpenDate DATE
);

-- Drop and recreate Bronze.Customers table
IF OBJECT_ID('Bronze.Customers', 'U') IS NOT NULL
    DROP TABLE Bronze.Customers;
CREATE TABLE Bronze.Customers (
    CustomerKey INT,
    Gender NVARCHAR(50),
    Name NVARCHAR(100),
    City NVARCHAR(200),
    StateCode NVARCHAR(50),
    ZipCode NVARCHAR(50),
    Country NVARCHAR(50),
    Continent NVARCHAR(50),
    Birthday NVARCHAR(50)     -- Stored as string to match file format; convert in Silver layer
);
