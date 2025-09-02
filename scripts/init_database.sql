/********************************************************************************************
    Script Name : Data Warehouse Initialization Script
    Description : This script creates a practice data warehouse in SQL Server with the
                  commonly used multi-layered architecture (Bronze, Silver, Gold).
                  - Bronze: Raw / Staging data
                  - Silver: Cleansed / Transformed data
                  - Gold  : Business-ready / Analytics data

    Author      : [Zyead Hassan]
    Created On  : [2-Sept-2025]
    Notes       : Run this script on SQL Server to set up schemas for practicing
                  data analytics and data engineering concepts.
********************************************************************************************/

-- Switch to master database
USE master;
GO

-- Create a new database for the Data Warehouse
CREATE DATABASE DataWarehouse;
GO

-- Switch context to the newly created database
USE DataWarehouse;
GO

-- Create schema for raw/staging layer
CREATE SCHEMA Bronze;
GO

-- Create schema for cleansed/transformed layer
CREATE SCHEMA Silver;
GO

-- Create schema for business-ready/analytics layer
CREATE SCHEMA Gold;
GO
