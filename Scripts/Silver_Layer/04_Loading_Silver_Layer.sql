/*
## 🧪 Silver Layer Transformation
### 🎯 Purpose  
  This script implements the **`silver.load_silver`** stored procedure,
  which orchestrates the **transformation and cleansing** of raw data from the Bronze layer into a trusted, conformed dataset in the Silver layer.  

  Key data quality and enrichment operations include:  
  - Filtering out invalid or malformed dates  
- Correcting calculation inconsistencies in metrics (e.g., sales, pricing)  
- Adding audit metadata (e.g.,'dwh_create_date) for traceability  

The Silver layer serves as the **single source of truth** for clean, standardized, and business-ready data—enabling reliable analytics and modeling in the Gold layer.

> ▶️ **Execution**:  
> ```sql
> EXEC silver.load_silver;
> ```
*/

CREATE OR ALTER PROCEDURE silver.load_silver AS
BEGIN 
	DECLARE @start_time DATETIME , @end_time DATETIME , @start_batch DATETIME ,@end_batch DATETIME 
	BEGIN TRY
	SET @start_batch = GETDATE();
	PRINT'===============================================';
	PRINT 'Loading Silver Layer ' ;
	PRINT'==============================================='
	-- ===============================================
	--					CRM
	-- ===============================================
	PRINT('**********************************************');
	PRINT 'Loading CRM Tables ' ;
	PRINT('**********************************************');

	-- ===============================================
	-- inserting data into silver.crm_cust_info
	-- ===============================================
	PRINT 'TRUNCATE THE TABLE silver.crm_cust_info' ;
	TRUNCATE TABLE silver.crm_cust_info;
	PRINT 'INSERT DATE INTO silver.crm_cust_info' ;
	SET @start_time = GETDATE();
	INSERT INTO silver.crm_cust_info(
		cst_id,
		cst_key,
		cst_firstname,
		cst_lastname,
		cst_material_status,
		cst_gndr,
		cst_create_date	
		)
	SELECT 
		cst_id,
		cst_key,
		TRIM(cst_firstname) AS cst_firstname ,
		TRIM(cst_lastname)AS cst_lastname,
		CASE WHEN cst_material_status ='M' THEN 'Married'
			 WHEN cst_material_status ='S' THEN 'Single'
			 ELSE 'N/A' 
		END AS cst_material_status,
		CASE WHEN cst_gndr ='M' THEN 'Male'
			 WHEN cst_gndr ='F' THEN 'Female'
			 ELSE 'N/A'
		END As cst_gndr,
		cst_create_date
	FROM(
	SELECT 
		*,
		ROW_NUMBER() OVER(PARTITION BY cst_id ORDER BY cst_create_date DESC) AS Flag_attemp
	FROM bronze.crm_cust_info
	) T 
	WHERE Flag_attemp = 1;
	SET @end_time = GETDATE()
	PRINT 'DURATION: '+ CAST(DATEDIFF(second,@start_time,@end_time ) AS NVARCHAR )+'seconds'

	-- ===============================================
	-- inserting data into silver.crm_prd_info
	-- ===============================================
	PRINT 'TRUNCATE THE TABLE silver.crm_prd_info' ;
	TRUNCATE TABLE silver.crm_prd_info;
	PRINT 'INSERT DATE INTO silver.crm_prd_info' ;
	SET @start_time = GETDATE();
	INSERT INTO silver.crm_prd_info ( 
		prd_id,
		cat_id,
		prd_key,
		prd_nm,prd_cost,
		prd_line,
		prd_start_dt,
		prd_end_dt
		)
	SELECT 
		prd_id,
		REPLACE( SUBSTRING(prd_key,1,5),'-','_' )AS ctr_id,
		SUBSTRING(prd_key,7,LEN(prd_key)) AS prd_key,
		prd_nm,
		ISNULL(prd_cost,0) AS prd_cost,
		CASE UPPER(TRIM(prd_line))
			WHEN 'M' THEN 'Mountain'
			WHEN 'R' THEN 'Road'
			WHEN 'S' THEN 'Other Sales'
			WHEN 'T' THEN 'Touring'
			ELSE 'N/A'
		END AS prd_line ,
		CAST(prd_start_dt AS DATE) AS prd_start_dt,
		DATEADD(day,-1,LEAD(prd_start_dt) OVER(PARTITION BY prd_key ORDER BY prd_start_dt)) AS prd_end_dt
	FROM bronze.crm_prd_info;
	SET @end_time = GETDATE()
	PRINT 'DURATION: '+ CAST(DATEDIFF(second,@start_time,@end_time ) AS NVARCHAR )+'seconds'
	-- ===============================================
	-- inserting data into silver.crm_sales_details 
	-- ===============================================
	PRINT 'TRUNCATE THE TABLE silver.crm_sales_details' ;
	TRUNCATE TABLE silver.crm_sales_details;
	PRINT 'INSERT DATE INTO silver.crm_sales_details' ;
	SET @start_time = GETDATE();
	INSERT INTO silver.crm_sales_details (
		sls_ord_num,
		sls_prd_key,
		sls_cust_id,
		sls_order_dt,
		sls_ship_dt,
		sls_due_dt,
		sls_sales,
		sls_quantity,
		sls_price
	
	)
	SELECT 
		sls_ord_num,
		sls_prd_key,
		sls_cust_id,
		CASE 
			WHEN sls_order_dt = 0 OR LEN(sls_order_dt)!=8 THEN NULL
			ELSE CAST (CAST(sls_order_dt AS VARCHAR) AS DATE) 
		END AS sls_order_dt ,
		CASE 
			WHEN sls_ship_dt = 0 OR LEN(sls_ship_dt)!=8 THEN NULL
			ELSE CAST (CAST(sls_ship_dt AS VARCHAR) AS DATE) 
		END AS sls_ship_dt ,
		CASE 
			WHEN sls_due_dt = 0 OR LEN(sls_due_dt)!=8 THEN NULL
			ELSE CAST (CAST(sls_due_dt AS VARCHAR) AS DATE) 
		END AS sls_due_dt ,
		CASE 
			WHEN sls_sales IS NULL OR sls_sales <= 0 OR sls_sales != ABS(sls_price)*sls_quantity
			THEN ABS(sls_price) * sls_quantity 
			ELSE sls_sales
		END AS sls_sales ,
		sls_quantity,
		CASE 
			WHEN sls_price <=0 OR sls_price IS NULL 
			THEN sls_sales / nullif (sls_quantity,0)
			ELSE sls_price
		END AS sls_price
	FROM bronze.crm_sales_details ;
	SET @end_time = GETDATE()
	PRINT 'DURATION: '+ CAST(DATEDIFF(second,@start_time,@end_time ) AS NVARCHAR )+'seconds'

	-- ===============================================
	--					ERP
	-- ===============================================
	PRINT('**********************************************');
	PRINT 'INSERTING ERP Tables ' ;
	PRINT('**********************************************');

	-- ===============================================
	-- inserting data into silver.erp_CUST_AZ12
	-- ===============================================
	PRINT 'TRUNCATE THE TABLE silver.erp_CUST_AZ12' ;
	TRUNCATE TABLE silver.erp_CUST_AZ12;
	PRINT 'INSERT DATE INTO silver.erp_CUST_AZ12' ;
	SET @start_time = GETDATE();
	INSERT INTO silver.erp_CUST_AZ12 (
		CID,
		BDATE,
		GEN
	)
	SELECT 
			CASE 
			WHEN CID LIKE 'NAS%' THEN SUBSTRING(CID,4,LEN(CID)) 
			ELSE CID 
		END AS CID,
		CASE 
			WHEN BDATE > '2025-01-01' OR BDATE IS NULL THEN NULL
			ELSE BDATE
		END AS BDATE,
		CASE	
			WHEN UPPER(TRIM(GEN)) IN  ('M','MALE') THEN 'Male'
			WHEN UPPER(TRIM(GEN)) IN ('F','FEMALE' )THEN 'Female'
			WHEN GEN ='' OR GEN IS NULL THEN 'N/A'
			ELSE GEN 
		END AS GEN 
	FROM bronze.erp_CUST_AZ12;
	SET @end_time = GETDATE()
	PRINT 'DURATION: '+ CAST(DATEDIFF(second,@start_time,@end_time ) AS NVARCHAR )+'seconds'
	-- ===============================================
	-- inserting data into silver.erp_LOC_A101
	-- ===============================================
	PRINT 'TRUNCATE THE TABLE silver.erp_LOC_A101' ;
	TRUNCATE TABLE silver.erp_LOC_A101;
	PRINT 'INSERT DATE INTO silver.erp_LOC_A101' ;
	SET @start_time = GETDATE();
	INSERT INTO silver.erp_LOC_A101(
		CID,
		CNTRY
	)
	SELECT 
		REPLACE(CID,'-','') AS CID ,
		CASE 
			WHEN TRIM(CNTRY) IN ('US','USA') THEN 'United State'
			WHEN TRIM(CNTRY) IN ('DE') THEN 'Germany'
			WHEN CNTRY IS NULL OR CNTRY ='' THEN 'N/A'
			ELSE TRIM (CNTRY) 
		END AS CNTRY 
	FROM bronze.erp_LOC_A101;
	SET @end_time = GETDATE()
	PRINT 'DURATION: '+ CAST(DATEDIFF(second,@start_time,@end_time ) AS NVARCHAR )+'seconds'
	-- ===============================================
	-- inserting data into silver.erp_PX_CAT_G1V2
	-- ===============================================
	PRINT 'TRUNCATE THE TABLE silver.erp_PX_CAT_G1V2' ;
	TRUNCATE TABLE silver.erp_PX_CAT_G1V2;
	PRINT 'INSERT DATE INTO silver.erp_PX_CAT_G1V2' ;
	SET @start_time = GETDATE();
	INSERT INTO silver.erp_PX_CAT_G1V2 (
		ID,
		CAT,
		SUBCAT,
		MAINTENANCE
	)
	SELECT 
		ID,
		CAT,
		SUBCAT,
		MAINTENANCE
	FROM bronze.erp_PX_CAT_G1V2;
	SET @end_time = GETDATE()
	PRINT 'DURATION: '+ CAST(DATEDIFF(second,@start_time,@end_time ) AS NVARCHAR )+'seconds'
	SET @end_batch = GETDATE();
	PRINT '---------------------------------------------------------'
	PRINT 'LOADING IS COMPELETE'
	PRINT 'LOADING DURATION : '+CAST(DATEDIFF(second,@start_batch,@end_batch)AS NVARCHAR)+'seconds'
	PRINT '---------------------------------------------------------'
	END TRY
	BEGIN CATCH
		PRINT('**********************************************');
		PRINT('ERROR OCURED');
		PRINT('ERROR MESSAGE'+ ERROR_MESSAGE());
		PRINT('ERROR MESSAGE'+ CAST(ERROR_NUMBER() AS NVARCHAR ));
		PRINT('ERROR MESSAGE'+ CAST(ERROR_STATE() AS NVARCHAR ))
		PRINT('**********************************************');
	END CATCH 
END 


