-- =============================================
-- Data Warehouse Initialization Script
-- Author: Mohamed Ayman Mohamed Ibrahim
-- Purpose: Create DataWarehouse DB + Bronze/Silver/Gold schemas
-- Safe to run multiple times (idempotent)
-- =============================================

-- Step 1: Create database if it doesn't exist
USE master;
GO

IF NOT EXISTS (SELECT * FROM sys.databases WHERE name = 'DataWarehouse')
BEGIN
    CREATE DATABASE DataWarehouse;
    PRINT '✅ Database [DataWarehouse] created.';
END
ELSE
BEGIN
    PRINT 'ℹ️ Database [DataWarehouse] already exists.';
END
GO

-- Step 2: Switch to the target database
USE DataWarehouse;
GO

-- Step 3: Create schemas (idempotent using dynamic SQL)
IF NOT EXISTS (SELECT * FROM sys.schemas WHERE name = 'bronze')
BEGIN
    EXEC('CREATE SCHEMA bronze');
    PRINT '✅ Schema [bronze] created.';
END
ELSE
BEGIN
    PRINT 'ℹ️ Schema [bronze] already exists.';
END
GO

IF NOT EXISTS (SELECT * FROM sys.schemas WHERE name = 'silver')
BEGIN
    EXEC('CREATE SCHEMA silver');
    PRINT '✅ Schema [silver] created.';
END
ELSE
BEGIN
    PRINT 'ℹ️ Schema [silver] already exists.';
END
GO

IF NOT EXISTS (SELECT * FROM sys.schemas WHERE name = 'gold')
BEGIN
    EXEC('CREATE SCHEMA gold');
    PRINT '✅ Schema [gold] created.';
END
ELSE
BEGIN
    PRINT 'ℹ️ Schema [gold] already exists.';
END
GO

-- Final confirmation
PRINT '🎉 DataWarehouse environment is ready!';
