-- =============================================
-- Data Warehouse Initialization Script
-- Author: Mohamed Ayman Mohamed Ibrahim
-- Purpose: Create DataWarehouse DB + Bronze/Silver/Gold schemas
-- Safe to run multiple times (idempotent)
-- =============================================

-- Step 1: Create database if it doesn't exist
use master;

-- Create a New Database "Data Warehouse" 
IF NOT EXISTS (SELECT * FROM sys.databases WHERE name = 'DataWarehouse')
    CREATE DATABASE DataWarehouse;
GO


-- Step 2: Switch to the target database
USE DataWarehouse;
GO

-- Step 3: Create schemas (idempotent using dynamic SQL)
    
-- create the bronze layer 
    
CREATE SCHEMA bronze ;
go
-- create the silver layer
CREATE SCHEMA silver;
go
-- create the gold layer
CREATE SCHEMA gold; 

