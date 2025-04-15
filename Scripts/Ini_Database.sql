-- =============================================
-- Create database and schemas for data pipeline
-- =============================================

-- Create the main database
CREATE DATABASE Retailer;

-- Switch context to the Retailer database
USE Retailer;

-- Create schemas for Medallion architecture layers
CREATE SCHEMA Bronze;   -- Raw/ingested data
CREATE SCHEMA Silver;   -- Cleaned/transformed data
CREATE SCHEMA Gold;     -- Business-level, analytics-ready data
