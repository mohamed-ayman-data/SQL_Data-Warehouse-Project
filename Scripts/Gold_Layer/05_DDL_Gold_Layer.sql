/*
====================================================================
 Gold Layer: Semantic Data Model (Star Schema)
--------------------------------------------------------------------
 Purpose:
   Expose business-ready views for analytics by integrating and 
   modeling cleansed data from the Silver layer.

 Components:
   - dim_customer: Conformed customer dimension (CRM + ERP)
   - dim_products: Active product catalog with category hierarchy
   - fact_sales:   Transactional sales facts linked to dimensions

 Key Features:
   - Surrogate keys for stable dimension joins
   - Business logic for attribute resolution (e.g., gender fallback)
   - Filtering of inactive/historical records (e.g., ended products)
   - Optimized for direct consumption by BI tools

 Layer Philosophy:
   "Gold = what the business understands — consistent, trusted, simple."
====================================================================
*/
-- ====================================================
-- Build the customer dimension view 
-- ====================================================

CREATE VIEW gold.dim_customer AS
	SELECT 
		ROW_NUMBER() OVER(ORDER BY cst_id) AS customer_key,
		ci.cst_id AS customer_id ,
		ci.cst_key AS customer_number ,
		ci.cst_firstname AS first_name ,
		ci.cst_lastname AS last_name ,
		la.CNTRY AS country,
		ci.cst_material_status AS material_status,
		CASE
			WHEN	ci.cst_gndr !='N/A' THEN ci.cst_gndr -- CRM is the master 
			WHEN ci.cst_gndr ='N/A' AND ca.GEN IS NULL then 'N/A'
			ELSE ca.GEN
		END AS gender  ,
		ci.cst_create_date AS create_date,
		ca.BDATE AS birth_date
	FROM silver.crm_cust_info ci
	LEFT JOIN silver.erp_CUST_AZ12 ca
	ON ci.cst_key=ca.CID
	LEFT JOIN silver.erp_LOC_A101 la
	ON ci.cst_key = la.CID ;

-- ====================================================
-- Build the Product  dimension view 
-- ====================================================
CREATE VIEW gold.dim_products AS
	SELECT 
		ROW_NUMBER() OVER(ORDER BY prd_start_dt,prd_id) AS product_key ,
		pn.prd_id AS product_id,
		pn.prd_key AS product_number,
		pn.prd_nm AS product_name  ,
		pn.cat_id AS category_id,
		pc.CAT AS Category,
		pc.SUBCAT AS Subcategory,
		pc.MAINTENANCE ,
		pn.prd_cost AS Cost ,
		pn.prd_line AS product_line,
		pn.prd_start_dt AS start_date
	FROM silver.crm_prd_info pn
	LEFT JOIN silver.erp_PX_CAT_G1V2 pc
	ON pn.cat_id = pc.ID
	WHERE pn.prd_end_dt IS NULL -- filer out historical data
	;
-- ====================================================
-- Build the Sales Fact view 
-- ====================================================
CREATE VIEW gold.fact_sales AS
	SELECT 
		sd.sls_ord_num AS order_number ,
		pr.product_key ,
		cr.customer_key,
		sd.sls_order_dt AS order_date,
		sd.sls_ship_dt AS shiping_date,
		sd.sls_due_dt AS due_date,
		sd.sls_sales AS sales,
		sd.sls_quantity AS quantity,
		sd.sls_price AS price
	FROM silver.crm_sales_details sd
	LEFT JOIN gold.dim_products pr
	ON sd.sls_prd_key = pr.product_number 
	LEFT JOIN gold.dim_customer cr
	ON sd.sls_cust_id = cr.customer_id;
