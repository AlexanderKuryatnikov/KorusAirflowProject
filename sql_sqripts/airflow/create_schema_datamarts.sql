CREATE SCHEMA datamarts;

CREATE TABLE datamarts.sales_report (
    id INT GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
    recorded_on TIMESTAMP,
    pos_name VARCHAR(255),
    name_short VARCHAR(255),
    category_name VARCHAR(255),
    quantity NUMERIC,
    price NUMERIC,
    revenue NUMERIC,
    update_date TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

CREATE TABLE datamarts.purchase_forecast (
    id INT GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
    available_on DATE,
    name_short VARCHAR(255),
    brand VARCHAR(255),
    pos_name VARCHAR(255),
    available_quantity NUMERIC,
    cost_per_item NUMERIC,
    update_date TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);
