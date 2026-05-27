SELECT 
  bq_prod.category,
  alloy_sale.product_name,
  SUM(alloy_sale.revenue) AS total_revenue_from_alloydb
FROM EXTERNAL_QUERY(
  "code-vipassana-497502.us-central1.alloydb_federated_connection",
  "SELECT product_name, revenue FROM alloydb_product_sales;"
) AS alloy_sale
INNER JOIN `code-vipassana-497502.froyo_data.product` AS bq_prod
  ON UPPER(alloy_sale.product_name) = UPPER(bq_prod.product_name)
GROUP BY 1, 2;
