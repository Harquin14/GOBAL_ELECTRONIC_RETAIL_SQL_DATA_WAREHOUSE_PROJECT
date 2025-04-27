GLOBAL ELECTRONIC RETAILERS (SQL Data Warehouse Project)

Designing and Building a Modern Data Warehouse with the Medallion Architecture Using SQL Server

📈 Project Objective
Design and implement a scalable, high-performance data warehouse that consolidates, transforms, and analyzes multi-source retail data.
The project leverages the Medallion Architecture (Bronze, Silver, Gold layers) to enable efficient ETL processes, ensure data quality, and support actionable insights for business decision-makers.
SQL Server is used for storage and transformation, with Tableau available for optional dashboarding.

✅ Project Scope and Requirements
1️⃣ Data Engineering & Warehouse Design
Goal:
Build a structured, query-optimized data warehouse to support analytics and business KPIs.

Data Sources:

Raw retail datasets including Sales, Products, Customers, Stores, and Exchange Rates (CSV files).

Architecture:

Implementation of the Medallion Architecture:
  
  -Bronze Layer – Raw ingested data
  
  -Silver Layer – Cleaned and transformed data
  
  -Gold Layer – Aggregated business-friendly tables

ETL Process Includes:

  -Data Cleaning (null handling, deduplication, data type standardization)
  
  -Currency Standardization (conversion to USD)
  
  -Data Modeling (Star Schema with Fact and Dimension tables)
  
  -Database Optimization (views, indexing, surrogate keys)

Deliverables:

  -Entity-Relationship Diagram (ERD)
  
  -Data Dictionary
  
  -Transformation Logic Documentation

2️⃣ Business Analysis & Insights
Goal:
Translate raw data into meaningful business insights through SQL queries and optional dashboards.

The business analysis is organized into four key areas:

📊 1. Store Sales Performance Report

Objective:

Analyze store-level performance and revenue trends.

Key Insights:

  -Top-performing stores by total sales
  
  -Number of orders per store
  
  -Average revenue per order
  
  -Best-performing country/state by sales
  
  -Store size vs total sales correlation
  
  -Monthly sales trend analysis (Open Date vs Order Date)

📊 2. Product Sales and Pricing Report

Objective:

Understand revenue drivers and pricing effectiveness.

Key Insights:

  -Top 10 best-selling products by revenue
  
  -Average selling price by product category
  
  -Quantity sold by subcategory
  
  -Best-performing brands by order revenue
  
  -Dead stock analysis (products with no sales)

📊 3. Customer Purchase Behavior Report

Objective:

Analyze customer purchasing patterns to drive loyalty strategies.

Key Insights:

  -New customer acquisition trend (monthly)
  
  -Total lifetime spend per customer
  
  -Customer segmentation:
    
    VIP (> $5,000)
    
    Regular ($1,000–$5,000)
    
    Low-Value (< $1,000)
  
  -Average products purchased per customer
  
  -Sales distribution by gender (Male vs Female)



📊 4. Currency and Exchange Rate Impact Report

Objective:

Evaluate the impact of currency fluctuations on international sales.

Key Insights:

  -Most used currencies in sales
  
  -Average exchange rate trend over time
  
  -Comparison of sales in local currency vs USD
  
  -Correlation between exchange rate trends and sales volume

3️⃣ Tools & Technologies

Tool	Purpose

  -SQL Server:	Data storage, transformation, and modelling
  
  -SSMS:	SQL querying and database management
  
  -Tableau: 	Data Visualization and KPI dashboards
  
  -CSV Files:	Simulated multi-source ERP/CRM data inputs
  
  -GitHub:	Version control and project documentation
