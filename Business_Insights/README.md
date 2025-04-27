🧠 Objective

This document outlines the key business questions derived from the Global Electronic Retailers dataset.
Each section includes a set of insights generated using SQL queries against the Gold Layer of the data warehouse.

1️⃣ Store Sales Performance Analysis
Objective:

Analyze revenue trends and operational performance at the store level.

Business Questions:

  - Which store generated the highest total sales?
  
  - How many orders were placed per store?
  
  - What is the average revenue per order for each store?
  
  - Which country/state has the highest performing stores?
  
  - How does store size (in square meters) correlate with total sales?
  
  - What are the monthly sales trends by store (using Open Date and Order Date)?

2️⃣ Product Sales and Pricing Analysis

Objective:

Evaluate product sales volume, revenue drivers, and pricing strategies.

Business Questions:

  - Which are the top 10 best-selling products (by total sales)?
  
  - What is the average selling price (UnitPriceUSD) by product category?
  
  - How many units were sold across different product subcategories?
  
  - Which brand achieved the highest average order revenue?
  
  - How many products are classified as dead stock (zero sales)?

3️⃣ Customer Purchase Behavior Analysis

Objective:

Understand customer purchasing patterns to support marketing and loyalty initiatives.

Business Questions:

  - How many new customers were acquired each month?
  
  - What is the total lifetime spend for each customer?
  
  - How can customers be segmented based on their lifetime spend?
  
    VIP Customers (> $5,000)
  
    Regular Customers ($1,000 - $5,000)
  
    Low-Value Customers (< $1,000)
  
  - What is the average quantity of products purchased per customer?
  
  - What is the gender distribution among customers, and how does it relate to total sales?

4️⃣ Currency and Exchange Rate Impact Analysis

Objective:

Assess the effect of international currencies and exchange rate fluctuations on sales.

Business Questions:

  - Which currencies were most commonly used in sales transactions?
  
  - What were the average exchange rates over time?
  
  - How do sales in local currencies compare against sales in USD?
  
  - How do exchange rate trends impact monthly sales volume?

🚀 Approach

Queries are executed on the Gold Layer (aggregated tables).

SQL Server and SSMS are used for all analytical querying.

 visualizations are created using Tableau.

📂 Related Files
/gold/ – Contains cleaned and aggregated datasets.

Business_Insights/sql_queries/ – Contains SQL scripts answering each business question (structured by topic).
