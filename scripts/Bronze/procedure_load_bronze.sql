/********************************************************************************************
    Project : Data Warehouse - Bronze Layer (Raw Data Storage)
    Layer   : Bronze (Raw / Staging)
    Object  : Stored Procedure - Bronze.load_bronze
    Purpose : Load raw data into Bronze layer tables using BULK INSERT
********************************************************************************************/

CREATE OR ALTER PROCEDURE Bronze.load_bronze
AS
BEGIN
    DECLARE 
        @start_time       DATETIME,
        @end_time         DATETIME,
        @batch_start_time DATETIME,
        @batch_end_time   DATETIME;

    BEGIN TRY
        SET @batch_start_time = GETDATE();

        PRINT '================================================================';
        PRINT '   Starting Bronze Layer Load';
        PRINT '================================================================';

        /*======================================================================================
            Load CRM Tables
        ======================================================================================*/
        PRINT '----------------------------------------------------------------';
        PRINT '   Loading CRM Tables';
        PRINT '----------------------------------------------------------------';

        /*--------------------------------------------------------------------------------------
            CRM Customer Information
        --------------------------------------------------------------------------------------*/
        SET @start_time = GETDATE();
        PRINT '<< Truncating table Bronze.crm_cust_info >>';
        TRUNCATE TABLE Bronze.crm_cust_info;

        PRINT '<< Inserting data into: Bronze.crm_cust_info >>';
        BULK INSERT Bronze.crm_cust_info
        FROM 'E:\courses\Baraa\Sql\sql-data-warehouse-project\datasets\source_crm\cust_info.csv'
        WITH (
            FIRSTROW = 2,
            FIELDTERMINATOR = ',',
            TABLOCK
        );
        SET @end_time = GETDATE();
        PRINT 'Load duration: ' + CAST(DATEDIFF(second, @start_time, @end_time) AS NVARCHAR) + ' seconds';
        PRINT '-----------------';

        /*--------------------------------------------------------------------------------------
            CRM Product Information
        --------------------------------------------------------------------------------------*/
        SET @start_time = GETDATE();
        PRINT '<< Truncating table Bronze.crm_prd_info >>';
        TRUNCATE TABLE Bronze.crm_prd_info;

        PRINT '<< Inserting data into: Bronze.crm_prd_info >>';
        BULK INSERT Bronze.crm_prd_info
        FROM 'E:\courses\Baraa\Sql\sql-data-warehouse-project\datasets\source_crm\prd_info.csv'
        WITH (
            FIRSTROW = 2,
            FIELDTERMINATOR = ',',
            TABLOCK
        );
        SET @end_time = GETDATE();
        PRINT 'Load duration: ' + CAST(DATEDIFF(second, @start_time, @end_time) AS NVARCHAR) + ' seconds';
        PRINT '-----------------';

        /*--------------------------------------------------------------------------------------
            CRM Sales Details
        --------------------------------------------------------------------------------------*/
        SET @start_time = GETDATE();
        PRINT '<< Truncating table Bronze.crm_sales_details >>';
        TRUNCATE TABLE Bronze.crm_sales_details;

        PRINT '<< Inserting data into: Bronze.crm_sales_details >>';
        BULK INSERT Bronze.crm_sales_details
        FROM 'E:\courses\Baraa\Sql\sql-data-warehouse-project\datasets\source_crm\sales_details.csv'
        WITH (
            FIRSTROW = 2,
            FIELDTERMINATOR = ',',
            TABLOCK
        );
        SET @end_time = GETDATE();
        PRINT 'Load duration: ' + CAST(DATEDIFF(second, @start_time, @end_time) AS NVARCHAR) + ' seconds';
        PRINT '-----------------';

        /*======================================================================================
            Load ERP Tables
        ======================================================================================*/
        PRINT '----------------------------------------------------------------';
        PRINT '   Loading ERP Tables';
        PRINT '----------------------------------------------------------------';

        /*--------------------------------------------------------------------------------------
            ERP Customer Demographics
        --------------------------------------------------------------------------------------*/
        SET @start_time = GETDATE();
        PRINT '<< Truncating table Bronze.erp_cust_az12 >>';
        TRUNCATE TABLE Bronze.erp_cust_az12;

        PRINT '<< Inserting data into: Bronze.erp_cust_az12 >>';
        BULK INSERT Bronze.erp_cust_az12
        FROM 'E:\courses\Baraa\Sql\sql-data-warehouse-project\datasets\source_erp\cust_az12.csv'
        WITH (
            FIRSTROW = 2,
            FIELDTERMINATOR = ',',
            TABLOCK
        );
        SET @end_time = GETDATE();
        PRINT 'Load duration: ' + CAST(DATEDIFF(second, @start_time, @end_time) AS NVARCHAR) + ' seconds';
        PRINT '-----------------';

        /*--------------------------------------------------------------------------------------
            ERP Customer Locations
        --------------------------------------------------------------------------------------*/
        SET @start_time = GETDATE();
        PRINT '<< Truncating table Bronze.erp_loc_a101 >>';
        TRUNCATE TABLE Bronze.erp_loc_a101;

        PRINT '<< Inserting data into: Bronze.erp_loc_a101 >>';
        BULK INSERT Bronze.erp_loc_a101
        FROM 'E:\courses\Baraa\Sql\sql-data-warehouse-project\datasets\source_erp\loc_a101.csv'
        WITH (
            FIRSTROW = 2,
            FIELDTERMINATOR = ',',
            TABLOCK
        );
        SET @end_time = GETDATE();
        PRINT 'Load duration: ' + CAST(DATEDIFF(second, @start_time, @end_time) AS NVARCHAR) + ' seconds';
        PRINT '-----------------';

        /*--------------------------------------------------------------------------------------
            ERP Product Categories
        --------------------------------------------------------------------------------------*/
        SET @start_time = GETDATE();
        PRINT '<< Truncating table Bronze.erp_px_cat_g1v2 >>';
        TRUNCATE TABLE Bronze.erp_px_cat_g1v2;

        PRINT '<< Inserting data into: Bronze.erp_px_cat_g1v2 >>';
        BULK INSERT Bronze.erp_px_cat_g1v2
        FROM 'E:\courses\Baraa\Sql\sql-data-warehouse-project\datasets\source_erp\px_cat_g1v2.csv'
        WITH (
            FIRSTROW = 2,
            FIELDTERMINATOR = ',',
            TABLOCK
        );
        SET @end_time = GETDATE();
        PRINT 'Load duration: ' + CAST(DATEDIFF(second, @start_time, @end_time) AS NVARCHAR) + ' seconds';
        PRINT '-----------------';

        /*======================================================================================
            Final Summary
        ======================================================================================*/
        SET @batch_end_time = GETDATE();

        PRINT '================================================================';
        PRINT '   Bronze Layer Loading Complete';
        PRINT '   Total Duration: ' + CAST(DATEDIFF(second, @batch_start_time, @batch_end_time) AS NVARCHAR) + ' seconds';
        PRINT '================================================================';
    END TRY

    BEGIN CATCH
        PRINT '================================================================';
        PRINT '   ERROR OCCURRED DURING BRONZE LAYER LOAD';
        PRINT '   ERROR MESSAGE: ' + ERROR_MESSAGE();
        PRINT '   ERROR NUMBER : ' + CAST(ERROR_NUMBER() AS NVARCHAR);
        PRINT '   ERROR STATE  : ' + CAST(ERROR_STATE()  AS NVARCHAR);
        PRINT '================================================================';
    END CATCH
END;
GO
