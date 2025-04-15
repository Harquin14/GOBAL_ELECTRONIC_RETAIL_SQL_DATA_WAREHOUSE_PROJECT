-- ============================================
-- Load raw data into Bronze layer tables
-- ============================================

-- Clear existing data from the Exchange_Rates table before importing
TRUNCATE TABLE Bronze.Exchange_Rates;

-- Load data from Exchange_Rates.csv into Bronze.Exchange_Rates table
BULK INSERT Bronze.Exchange_Rates
FROM 'F:\DATASET\Global Electronics Retailer\ERP/Exchange_Rates.csv'
WITH (
    FIRSTROW = 2,               -- Skip header row
    FIELDTERMINATOR = ',',      -- CSV file is comma-delimited
    TABLOCK                     -- Use table-level locking for performance
);

-- Clear existing data from the Products table
TRUNCATE TABLE Bronze.Products;

-- Load data from Products.csv into Bronze.Products table
BULK INSERT Bronze.Products
FROM 'F:\DATASET\Global Electronics Retailer\ERP/Products.csv'
WITH (
    FIRSTROW = 2,
    FIELDTERMINATOR = ',',
    TABLOCK
);

-- Clear existing data from the Sales table
TRUNCATE TABLE Bronze.Sales;

-- Load data from Sales.csv into Bronze.Sales table
BULK INSERT Bronze.Sales
FROM 'F:\DATASET\Global Electronics Retailer\ERP/Sales.csv'
WITH (
    FIRSTROW = 2,
    FIELDTERMINATOR = ',',
    TABLOCK
);

-- Clear existing data from the Stores table
TRUNCATE TABLE Bronze.Stores;

-- Load data from Stores.csv into Bronze.Stores table
BULK INSERT Bronze.Stores
FROM 'F:\DATASET\Global Electronics Retailer\ERP/Stores.csv'
WITH (
    FIRSTROW = 2,
    FIELDTERMINATOR = ',',
    TABLOCK
);

-- Clear existing data from the Customers table
TRUNCATE TABLE Bronze.Customers;

-- Load data from Customers.csv into Bronze.Customers table
BULK INSERT Bronze.Customers
FROM 'F:\DATASET\Global Electronics Retailer\CRM/Customers.csv'
WITH (
    FIRSTROW = 2,
    FIELDTERMINATOR = ',',
    TABLOCK
);
