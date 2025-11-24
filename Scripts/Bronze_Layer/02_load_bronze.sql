/*# 📥 Bronze Layer Data Ingestion

## 🎯 Purpose

This module ingests raw CRM and ERP data from CSV files into the **Bronze layer** of the data warehouse using a **fully logged, idempotent, and error-resilient** stored procedure.  

The Bronze layer serves as the **immutable landing zone** for source data—preserving original structure, content, and fidelity without transformation, cleansing, 
  or business logic. This design ensures:  
- Full reproducibility of downstream pipelines  
- Auditability from source to insight  


> ⚠️ **Note**: This is a **full-refresh load** (TRUNCATE + INSERT), appropriate for static or daily snapshot datasets in a development or demo environment.

---

## 📜 Script Reference

- **The Execution not accept  any parameters or retutn any values 
- **Execution Command**:  
  ```sql
  EXEC bronze.load_bronze;

## 🚀 Key Features

✅ **Full Refresh Pattern**  
- Truncates target tables before reload (suitable for static datasets or daily snapshots).  

✅ **BULK INSERT Optimization**  
- Uses `TABLOCK` and minimal logging for high-performance loading.  
- Skips header row (`FIRSTROW = 2`).  

✅ **Comprehensive Logging**  
- Prints table-level and total job duration in seconds.  
- Clear section separators for CRM vs. ERP loads.  

✅ **Error Handling**  
- Wrapped in `TRY...CATCH` with detailed error output (message, number, state).  

✅ **Source Transparency**  
- Hardcoded (for demo) paths reflect real project structure.  
- In production, paths would be parameterized or driven by a metadata table.

---

## 🗃️ Tables Loaded

### CRM Source
- `bronze.crm_cust_info`
- `bronze.crm_prd_info`
- `bronze.crm_sales_details`

### ERP Source
- `bronze.erp_CUST_AZ12`
- `bronze.erp_LOC_A101`
- `bronze.erp_PX_CAT_G1V2`

> ⚠️ **Note**: File paths are local for demonstration. In cloud or team environments, these would use `OPENROWSET`, Azure Blob Storage, or parameterized paths.*/

---
## Script 

CREATE OR ALTER PROCEDURE bronze.load_bronze AS
BEGIN
	DECLARE @start_time DATETIME ,@end_time DATETIME,@start_batch DATETIME ,@end_batch DATETIME ;
	BEGIN TRY
		SET @start_batch = GETDATE();
		-- ======================================================
		-- INSERTING THE DATA FROM THE CRM CSV FILES
		-- ======================================================
		PRINT('===================================================');
		PRINT('Loading CRM Tables');
		PRINT('===================================================');

		PRINT('TURENCATE TABLE >> bronze.crm_cust_info');
		PRINT('INSERTING TABLE >> bronze.crm_cust_info');
		SET @start_time = GETDATE();
		TRUNCATE TABLE bronze.crm_cust_info ;
		-- INSERT THE DATA INTO cust_info TABLE 
		BULK INSERT bronze.crm_cust_info
		FROM 'C:\Users\ADMIN\Desktop\data analysis\iti prep\warehouse project\f78e076e5b83435d84c6b6af75d8a679\sql-data-warehouse-project\datasets\source_crm\cust_info.csv'
		WITH (
			FIRSTROW =2,
			FIELDTERMINATOR =',',
			TABLOCK
		);
		SET @end_time = GETDATE();
		print '>> Load_duration'+CAST(datediff(second,@start_time,@end_time) AS NVARCHAR)+'Seconds';
		print '------------';
		


		-- ***************************************************************
		PRINT('TURENCATE TABLE >> bronze.crm_prd_info');
		PRINT('INSERTING TABLE >> bronze.crm_prd_info');

		-- INSERT THE DATA INTO prd_info TABLE
		SET @start_time = GETDATE();
		TRUNCATE TABLE bronze.crm_prd_info ;

		BULK INSERT bronze.crm_prd_info
		FROM 'C:\Users\ADMIN\Desktop\data analysis\iti prep\warehouse project\f78e076e5b83435d84c6b6af75d8a679\sql-data-warehouse-project\datasets\source_crm\prd_info.csv'
		WITH (
			FIRSTROW =2,
			FIELDTERMINATOR =',',
			TABLOCK
		);
		SET @end_time = GETDATE();
		print '>> Load_duration:  '+CAST(datediff(second,@start_time,@end_time) AS NVARCHAR)+'Seconds';
		print '------------' ;
		

		-- ***************************************************************
		PRINT('TURENCATE TABLE >> bronze.crm_sales_details');
		PRINT('INSERTING TABLE >> bronze.crm_sales_details');

		-- INSERT THE DATA INTO sales_details TABLE
		SET @start_time = GETDATE();
		TRUNCATE TABLE bronze.crm_sales_details ;

		BULK INSERT bronze.crm_sales_details
		FROM 'C:\Users\ADMIN\Desktop\data analysis\iti prep\warehouse project\f78e076e5b83435d84c6b6af75d8a679\sql-data-warehouse-project\datasets\source_crm\sales_details.csv'
		WITH (
			FIRSTROW =2,
			FIELDTERMINATOR =',',
			TABLOCK
		);

		SET @end_time = GETDATE();
		print '>> Load_duration'+CAST(datediff(second,@start_time,@end_time) AS NVARCHAR)+'Seconds';
		print '------------';


		-- ======================================================
		-- INSERTING THE DATA FROM THE ERP CSV FILES 
		-- ====================================================== 
		PRINT('===================================================');
		PRINT('Loading ERP Tables');
		PRINT('===================================================');

		PRINT('TURENCATE TABLE >> bronze.erp_CUST_AZ12');
		PRINT('INSERTING TABLE >> bronze.erp_CUST_AZ12');

		-- INSERT THE DATA INTO CUST_AZ12 TABLE
		SET @start_time = GETDATE();
		TRUNCATE TABLE bronze.erp_CUST_AZ12 ;

		BULK INSERT bronze.erp_CUST_AZ12 
		FROM 'C:\Users\ADMIN\Desktop\data analysis\iti prep\warehouse project\f78e076e5b83435d84c6b6af75d8a679\sql-data-warehouse-project\datasets\source_erp\CUST_AZ12.csv'
		WITH(
			FIRSTROW = 2 ,
			FIELDTERMINATOR =',',
			TABLOCK
		);
		SET @end_time = GETDATE();
		print '>> Load_duration'+CAST(datediff(second,@start_time,@end_time) AS NVARCHAR)+'Seconds';
		print '------------';
		
		-- ***************************************************************
		PRINT('TURENCATE TABLE >> bronze.erp_LOC_A101');
		PRINT('INSERTING TABLE >> bronze.erp_LOC_A101');
		-- INSERT THE DATA INTO LOC_A101 TABLE
		SET @start_time = GETDATE();
		TRUNCATE TABLE bronze.erp_LOC_A101 ;

		BULK INSERT bronze.erp_LOC_A101
		FROM 'C:\Users\ADMIN\Desktop\data analysis\iti prep\warehouse project\f78e076e5b83435d84c6b6af75d8a679\sql-data-warehouse-project\datasets\source_erp\LOC_A101.csv'
		WITH(
			FIRSTROW = 2 ,
			FIELDTERMINATOR =',',
			TABLOCK
		);
		SET @end_time = GETDATE();
		print '>> Load_duration'+CAST(datediff(second,@start_time,@end_time) AS NVARCHAR)+'Seconds';
		print '------------';
		

		-- ***************************************************************
		PRINT('TURENCATE TABLE >> bronze.erp_PX_CAT_G1V2');
		PRINT('INSERTING TABLE >> bronze.erp_PX_CAT_G1V2');
		-- INSERT THE DATA INTO PX_CAT_G1V2 TABLE
		SET @start_time = GETDATE();
		TRUNCATE TABLE bronze.erp_PX_CAT_G1V2 ;

		BULK INSERT bronze.erp_PX_CAT_G1V2
		FROM 'C:\Users\ADMIN\Desktop\data analysis\iti prep\warehouse project\f78e076e5b83435d84c6b6af75d8a679\sql-data-warehouse-project\datasets\source_erp\PX_CAT_G1V2.csv'
		WITH(
			FIRSTROW = 2 ,
			FIELDTERMINATOR =',',
			TABLOCK
		);

		SET @end_time = GETDATE();
		print '>> Load_duration'+CAST(datediff(second,@start_time,@end_time) AS NVARCHAR)+'Seconds';
		print '------------';
		SET @end_batch = GETDATE();
		PRINT '--------------------------------';
		PRINT '	LOADING IS COMPLETE';
		PRINT '		.. DUREATION:  '+CAST(DATEDIFF(SECOND,@start_batch,@end_batch) AS NVARCHAR)+' seconds';
		PRINT '--------------------------------';
	END TRY
	BEGIN CATCH
		PRINT('--------------------------------------');
		PRINT('ERROR OCURED');
		PRINT('ERROR MESSAGE'+ ERROR_MESSAGE());
		PRINT('ERROR MESSAGE'+ CAST(ERROR_NUMBER() AS NVARCHAR ));
		PRINT('ERROR MESSAGE'+ CAST(ERROR_STATE() AS NVARCHAR ))
		PRINT('--------------------------------------');
	END CATCH 
END 


