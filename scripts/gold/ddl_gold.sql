CREATE VIEW gold.dim_customers AS
	SELECT
		ROW_NUMBER() OVER (ORDER BY cst_id) AS customer_key,
		ci.cst_id AS customer_id,
		ci.cst_key AS customer_number,
		ci.cst_firstname AS first_name, 
		ci.cst_lastname AS last_name,
		cl.cntry AS country,
		ci.cst_marital_status AS marital_status,
		CASE
			WHEN ci.cst_gndr != 'n/a' THEN ci.cst_gndr
			ELSE COALESCE(cb.gen, 'n/a')
		END AS gender,
		cb.bdate AS birthdate,
		ci.cst_create_date AS create_date

	FROM silver.crm_cust_info AS ci
	LEFT JOIN silver.erp_cust_az12 AS cb
		ON ci.cst_key = cb.cid
	LEFT JOIN silver.erp_loc_a101 AS cl
		ON ci.cst_key = cl.cid
