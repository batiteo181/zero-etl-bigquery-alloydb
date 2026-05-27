CREATE TABLE IF NOT EXISTS alloydb_product_sales (
    sale_id SERIAL PRIMARY KEY,
    product_name VARCHAR(100),
    revenue NUMERIC,
    transaction_date DATE
);

INSERT INTO alloydb_product_sales (product_name, revenue, transaction_date) VALUES
('Midnight Swirl', 4500.25, '2026-05-25'),
('Midnight Swirl', 3200.50, '2026-05-26'),
('Froyo Vanilla Classic', 1200.00, '2026-05-26');
