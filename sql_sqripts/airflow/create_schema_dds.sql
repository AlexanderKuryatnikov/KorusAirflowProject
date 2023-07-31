CREATE SCHEMA dds;

CREATE TABLE dds.brand (
    brand_id INT PRIMARY KEY,
    brand VARCHAR(255)
);

CREATE TABLE dds.category (
    category_id VARCHAR(10) PRIMARY KEY,
    category_name VARCHAR(50)
);

CREATE TABLE dds.store (
    pos VARCHAR(50) PRIMARY KEY,
    pos_name VARCHAR(255)
);

CREATE TABLE dds.product (
    product_id INT PRIMARY KEY,
    name_short VARCHAR(255),
    category_id VARCHAR(10),
    pricing_line_id INT,
    brand_id INT
);

CREATE TABLE dds.stock (
    available_on DATE,
    product_id INT,
    pos VARCHAR(50),
    available_quantity NUMERIC,
    cost_per_item NUMERIC(10, 2),
    PRIMARY KEY (available_on, product_id, pos)
);

CREATE TABLE dds.transaction_store (
    transaction_id VARCHAR(20) PRIMARY KEY,
    pos VARCHAR(50)
);

CREATE TABLE dds.transaction (
    transaction_id VARCHAR(20),
    product_id INT,
    recorded_on TIMESTAMP,
    quantity NUMERIC,
    price NUMERIC(10, 2),
    price_full NUMERIC(10, 2),
    order_type_id VARCHAR(20),
    PRIMARY KEY (transaction_id, product_id)
);