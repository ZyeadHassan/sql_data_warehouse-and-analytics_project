/********************************************************************************************
    Project : Data Warehouse - Gold Layer (Presentation / Analytics)
    Layer   : Gold (Dimensional Model)
    Purpose : Provides business-friendly structures (dimensions & facts) for reporting and 
              analytics. Gold layer is built on top of Silver cleansed data.
              Objects:
                  - dim_customers
                  - dim_products
                  - fact_sales
********************************************************************************************/

USE DataWarehouse;
GO

/*------------------------------------------------------------------------------------------
    View: Gold.dim_customers
    Purpose: Dimension table for customer master data.
             Combines CRM customer info (master source), ERP demographics, and ERP locations.
------------------------------------------------------------------------------------------*/
CREATE VIEW Gold.dim_customers AS
SELECT 
    ROW_NUMBER() OVER (ORDER BY cst_id) AS customer_key,    -- Surrogate key for DW
    ci.cst_id          AS customer_id,                      -- Business key (CRM ID)
    ci.cst_key         AS customer_number,                  
    ci.cst_firstname   AS first_name,                       
    ci.cst_lastname    AS last_name,                        
    la.cntry           AS country,                          
    ci.cst_marital_status AS maritial_status,             
    CASE 
        WHEN ci.cst_gndr != 'n/a' THEN ci.cst_gndr          
        ELSE COALESCE(ca.gen, 'n/a')                        
    END                AS gender,
    ca.bdate           AS birthdate,                        
    ci.cst_create_date AS create_date                     
FROM Silver.crm_cust_info ci
LEFT JOIN Silver.erp_cust_az12 ca
    ON ci.cst_key = ca.cid
LEFT JOIN Silver.erp_loc_a101 la
    ON ci.cst_key = la.cid;
GO

/*------------------------------------------------------------------------------------------
    View: Gold.dim_products
    Purpose: Dimension table for product master data.
             Combines CRM product info with ERP product categories.
------------------------------------------------------------------------------------------*/
CREATE VIEW Gold.dim_products AS
SELECT 
    ROW_NUMBER() OVER (ORDER BY prd_start_dt, prd_key) AS product_key, -- Surrogate key
    pn.prd_id        AS product_id,        -- Business key (CRM product ID)
    pn.prd_key       AS product_number,    -- CRM product code
    pn.prd_nm        AS product_name,      
    pn.cat_id        AS category_id,       
    pc.cat           AS category,          
    pc.subcat        AS subcategory,       
    pc.maintenance   AS maintenance,       
    pn.prd_cost      AS cost,              
    pn.prd_line      AS product_line,      
    pn.prd_start_dt  AS start_date         
FROM Silver.crm_prd_info pn
LEFT JOIN Silver.erp_px_cat_g1v2 pc
    ON pn.cat_id = pc.id
WHERE pn.prd_end_dt IS NULL;               -- Only active products
GO

/*------------------------------------------------------------------------------------------
    View: Gold.fact_sales
    Purpose: Fact table for sales transactions.
             Links sales orders to customers and products via surrogate keys.
------------------------------------------------------------------------------------------*/
CREATE VIEW Gold.fact_sales AS
SELECT 
    sd.sls_ord_num   AS order_number,     
    pr.product_key   AS product_key,       -- Surrogate product key (FK to dim_products)
    cu.customer_key  AS customer_key,      -- Surrogate customer key (FK to dim_customers)
    sd.sls_order_dt  AS order_date,        
    sd.sls_ship_dt   AS ship_date,         
    sd.sls_due_dt    AS due_date,          
    sd.sls_sales     AS sales_amount,      
    sd.sls_quantity  AS quantity,          
    sd.sls_price     AS price              
FROM Silver.crm_sales_details sd 
LEFT JOIN Gold.dim_products pr
    ON sd.sls_prd_key = pr.product_number
LEFT JOIN Gold.dim_customers cu
    ON sd.sls_cust_id = cu.customer_id;
GO
