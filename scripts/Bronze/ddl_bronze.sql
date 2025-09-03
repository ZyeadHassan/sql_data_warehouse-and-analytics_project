/********************************************************************************************
    Project : Data Warehouse - Bronze Layer (Raw Data Storage)
    Layer   : Bronze (Raw / Staging)
    Purpose : To store raw ingested data from CRM & ERP source systems before any transformation.
              This layer is the foundation for further processing in the Silver & Gold layers.

********************************************************************************************/

USE DataWarehouse;
GO

/*------------------------------------------------------------------------------------------
    Table: Bronze.crm_cust_info
    Source: CRM System
    Purpose: Stores customer information from CRM
------------------------------------------------------------------------------------------*/
CREATE TABLE Bronze.crm_cust_info (
    cst_id              INT,              
    cst_key             NVARCHAR(50),     
    cst_firstname       NVARCHAR(50),     
    cst_lastname        NVARCHAR(50),     
    cst_marital_status  NVARCHAR(50),     
    cst_gndr            NVARCHAR(50), 
    cst_create_date     DATE              
);
GO

/*------------------------------------------------------------------------------------------
    Table: Bronze.crm_prd_info
    Source: CRM System
    Purpose: Stores product master data
------------------------------------------------------------------------------------------*/
DROP TABLE Bronze.crm_prd_info;


CREATE TABLE Bronze.crm_prd_info (
    prd_id          INT,              
    prd_key         NVARCHAR(50), 
	prd_nm			NVARCHAR(50),
    prd_cost        INT,             
    prd_line        NVARCHAR(50),     
    prd_start_dt    DATETIME,         
    prd_end_dt      DATETIME 
);
GO
           
/*------------------------------------------------------------------------------------------
    Table: Bronze.crm_sales_details
    Source: CRM System
    Purpose: Stores raw sales transactions
------------------------------------------------------------------------------------------*/
CREATE TABLE Bronze.crm_sales_details (
    sls_ord_num     NVARCHAR(50),    
    sls_prd_key     NVARCHAR(50),     
    sls_cust_id     INT,             
    sls_order_dt    INT,              
    sls_ship_dt     INT,              
    sls_due_dt      INT,            
    sls_sales       INT,              
    sls_quantity    INT,             
    sls_price       INT               
);
GO

/*------------------------------------------------------------------------------------------
    Table: Bronze.erp_cust_az12
    Source: ERP System
    Purpose: Stores additional customer demographics
------------------------------------------------------------------------------------------*/
CREATE TABLE Bronze.erp_cust_az12 (
    cid     NVARCHAR(50),     
    bdate   DATE,             
    gen     NVARCHAR(50)      
);
GO

/*------------------------------------------------------------------------------------------
    Table: Bronze.erp_loc_a101
    Source: ERP System
    Purpose: Stores customer location details
------------------------------------------------------------------------------------------*/
CREATE TABLE Bronze.erp_loc_a101 (
    cid     NVARCHAR(50),     
    cntry   NVARCHAR(50)      
);
GO

/*------------------------------------------------------------------------------------------
    Table: Bronze.erp_px_cat_g1v2
    Source: ERP System
    Purpose: Stores product category and maintenance details
------------------------------------------------------------------------------------------*/
CREATE TABLE Bronze.erp_px_cat_g1v2 (
    id           NVARCHAR(50),    
    cat          NVARCHAR(50),    
    subcat       NVARCHAR(50),   
    maintenance  NVARCHAR(50)   
);
GO
