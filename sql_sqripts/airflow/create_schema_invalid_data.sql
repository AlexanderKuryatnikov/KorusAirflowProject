CREATE SCHEMA invalid_data;

CREATE TABLE invalid_data.brand (
    brand_id VARCHAR(255),
    brand VARCHAR(255),
    error_description VARCHAR(255)
);

CREATE TABLE invalid_data.category (
    category_id VARCHAR(255),
    category_name VARCHAR(255),
    error_description VARCHAR(255)
);

CREATE TABLE invalid_data.store (
    pos VARCHAR(255),
    pos_name VARCHAR(255),
    error_description VARCHAR(255)
);

CREATE TABLE invalid_data.product (
    product_id VARCHAR(255),
    name_short VARCHAR(255),
    category_id VARCHAR(255),
    pricing_line_id VARCHAR(255),
    brand_id VARCHAR(255),
    error_description VARCHAR(255)
);

CREATE TABLE invalid_data.stock (
    available_on VARCHAR(255),
    product_id VARCHAR(255),
    pos VARCHAR(255),
    available_quantity VARCHAR(255),
    cost_per_item VARCHAR(255),
    error_description VARCHAR(255)
);

CREATE TABLE invalid_data.transaction_store (
    transaction_id VARCHAR(255),
    pos VARCHAR(255),
    error_description VARCHAR(255)
);

CREATE TABLE invalid_data.transaction (
    transaction_id VARCHAR(255),
    product_id VARCHAR(255),
    recorded_on VARCHAR(255),
    quantity VARCHAR(255),
    price VARCHAR(255),
    price_full VARCHAR(255),
    order_type_id VARCHAR(255),
    error_description VARCHAR(255)
);