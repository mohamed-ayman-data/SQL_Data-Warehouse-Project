/*
Purpose of Script :
create Tables in Silver Layer (Schema) , Drop the Tables 
IF already existed 
*/
-- ====================================================
-- DDL: Ingest raw CRM source tables into silver layer
-- ====================================================

-- CREATE customer_info TABLE 
CREATE TABLE silver.crm_cust_info (
	cst_id INT ,
	cst_key NVARCHAR(50),
	cst_firstname NVARCHAR(50),
	cst_lastname NVARCHAR(50),
	cst_material_status NVARCHAR(50),
	cst_gndr NVARCHAR(50),
	cst_create_date DATE ,
	dwh_create_date DATETIME2 DEFAULT GETDATE()
);

-- CREATE product_info TABLE 

CREATE TABLE silver.crm_prd_info(
	prd_id INT ,
	cat_id NVARCHAR(50),
	prd_key NVARCHAR(50),
	prd_nm NVARCHAR(50),
	prd_cost INT ,
	prd_line VARCHAR(50),
	prd_start_dt DATE ,
	prd_end_dt DATE,
	dwh_create_date DATETIME2 DEFAULT GETDATE()
);  
-- CREATE sales_details TABLE 
DROP TABLE silver.crm_sales_details;
CREATE TABLE silver.crm_sales_details(
	sls_ord_num NVARCHAR(50),
	sls_prd_key NVARCHAR(50),
	sls_cust_id INT ,
	sls_order_dt DATE ,
	sls_ship_dt DATE ,
	sls_due_dt DATE ,
	sls_sales INT,
	sls_quantity INT,
	sls_price INT ,
	dwh_create_date DATETIME2 DEFAULT GETDATE()
);  
-- ====================================================
-- DDL: Ingest raw ERP source tables into silver layer
-- ====================================================

-- CREATE CUST_AZ12 TABLE 
CREATE TABLE silver.erp_CUST_AZ12 (
	 CID NVARCHAR(50),
	 BDATE DATE,
	 GEN VARCHAR(50),
	dwh_create_date DATETIME2 DEFAULT GETDATE()
); 
-- CREATE LOC_A101 TABLE  
CREATE TABLE silver.erp_LOC_A101 (
	 CID   NVARCHAR(50),
	 CNTRY VARCHAR(50),
	dwh_create_date DATETIME2 DEFAULT GETDATE()
);  
-- CREATE PX_CAT_G1V2 TABLE  
CREATE TABLE silver.erp_PX_CAT_G1V2 (
	 ID NVARCHAR(50),
	 CAT VARCHAR(50),
	 SUBCAT VARCHAR(50),
	 MAINTENANCE VARCHAR(50),
	dwh_create_date DATETIME2 DEFAULT GETDATE()
);  
