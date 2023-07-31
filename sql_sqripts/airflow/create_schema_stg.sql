CREATE SCHEMA stg;

CREATE TABLE stg.brand (
    brand_id VARCHAR(255),
    brand VARCHAR(255)
);

CREATE TABLE stg.category (
    category_id VARCHAR(255),
    category_name VARCHAR(255)
);

CREATE TABLE stg.store (
    pos VARCHAR(255),
    pos_name VARCHAR(255)
);

CREATE TABLE stg.product (
    product_id VARCHAR(255),
    name_short VARCHAR(255),
    category_id VARCHAR(255),
    pricing_line_id VARCHAR(255),
    brand_id VARCHAR(255)
);

CREATE TABLE stg.stock (
    available_on VARCHAR(255),
    product_id VARCHAR(255),
    pos VARCHAR(255),
    available_quantity VARCHAR(255),
    cost_per_item VARCHAR(255)
);

CREATE TABLE stg.transaction_store (
    transaction_id VARCHAR(255),
    pos VARCHAR(255)
);

CREATE TABLE stg.transaction (
    transaction_id VARCHAR(255),
    product_id VARCHAR(255),
    recorded_on VARCHAR(255),
    quantity VARCHAR(255),
    price VARCHAR(255),
    price_full VARCHAR(255),
    order_type_id VARCHAR(255)
);