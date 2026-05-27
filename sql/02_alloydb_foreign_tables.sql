CREATE EXTENSION IF NOT EXISTS bigquery_fdw;

CREATE SERVER bigquery_server FOREIGN DATA WRAPPER bigquery_fdw;

CREATE USER MAPPING FOR postgres SERVER bigquery_server;

CREATE FOREIGN TABLE IF NOT EXISTS bq_ingredient (
    cas_number VARCHAR,
    ingredient_name VARCHAR,
    max_moisture_percentage DOUBLE PRECISION,
    ph_range VARCHAR,
    purity_percentage DOUBLE PRECISION,
    shelf_life_months BIGINT,
    specific_gravity_range VARCHAR
) SERVER bigquery_server OPTIONS (
    project 'code-vipassana-497502',
    dataset 'froyo_data',
    table 'ingredient'
);
