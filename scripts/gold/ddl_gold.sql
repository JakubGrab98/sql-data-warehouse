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
		ON ci.cst_key = cl.cid;

GO;

CREATE VIEW gold.dim_products AS
SELECT
    ROW_NUMBER() OVER (ORDER BY pn.prd_start_dt, pn.prd_key) AS product_key, -- Surrogate key
    pn.prd_id       AS product_id,
    pn.prd_key      AS product_number,
    pn.prd_nm       AS product_name,
    pn.cat_id       AS category_id,
    pc.cat          AS category,
    pc.subcat       AS subcategory,
    pc.maintenance  AS maintenance,
    pn.prd_cost     AS cost,
    pn.prd_line     AS product_line,
    pn.prd_start_dt AS start_date
FROM silver.crm_prd_info pn
LEFT JOIN silver.erp_px_cat_g1v2 pc
    ON pn.cat_id = pc.id
WHERE pn.prd_end_dt IS NULL;
