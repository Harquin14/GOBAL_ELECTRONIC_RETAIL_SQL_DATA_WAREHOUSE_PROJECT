# GLOBAL ELECTRONIC RETAILERS (SQL-DATA-WAREHOUSE-PROJECT)
Designing and Building a Data Warehouse with the Medallion Architecture Using SQL 

--------------------------------------------------------------------------
  # PROJECT OBJECTIVE
Design and implement a modern data warehouse using SQL Server that consolidates and transforms multi-source retail data into actionable insights for decision-makers. 
The project will leverage the Medallion Architecture (Bronze, Silver, Gold layers) to enable scalable ETL processes, ensure data quality, and provide analytical reporting through SQL and Tableau.

------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------

✅ Project Requirements

1️⃣ Data Engineering & Warehouse Design



📌 Goal: Build a structured, high-performance data warehouse to support analytical queries and KPIs.

* Data Sources: Use raw sales and customer data from multiple CSVs (e.g., Products, Sales, Stores, Customers, Exchange_Rates).

* Architecture: Implement the Medallion Architecture:

  - Bronze Layer – Raw ingested data

  - Silver Layer – Cleaned and transformed data

  - Gold Layer – Aggregated tables and business-friendly metrics

- ETL Process:

  - Data Cleaning (nulls, duplicates, data types)

  - Standardization (e.g., currency conversion)

  - Data Modeling (Star Schema with Fact & Dimension tables)

  - Storage: SQL Server (with use of views, staging, and surrogate keys)

  - Documentation: ERD, Data Dictionary, Transformation Logic

2️⃣ Data Analysis & Business Insights


📌 Goal: Deliver analytics and dashboards to enable performance tracking and strategic planning.

* Key Areas of Analysis:

  - Revenue & Quantity Trends

  - Best/Worst Performing Products

  - Sales by Region/Store

  - Customer Segmentation & Loyalty

* KPIs:

  - Total Revenue

  - Total Quantity Sold

  - Top 5/Bottom 5 Products

  - Sales per Product

* Tool: Tableau or Power BI (optional), SQL-based reporting



3️⃣ Tools & Technologies
🛠️ SQL Server – Data storage and transformation

🛠️ SSMS – SQL queries and database management

📊 Tableau – Dashboard and KPI reporting

📁 CSV Files – Simulated multi-source ERP/CRM data

🔄 GitHub – Project documentation and version control

