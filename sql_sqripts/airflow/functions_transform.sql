CREATE FUNCTION transform_brand()
RETURNS void
LANGUAGE SQL
AS
$transform_brand$
TRUNCATE dds.brand;

INSERT INTO
    dds.brand
SELECT
    brand_id::INT,
    brand
FROM (
    SELECT
        *,
        row_number() over (partition by brand_id, brand) as brand_number
    FROM
        stg.brand
    WHERE
        brand_id SIMILAR TO '[0-9]+'
        AND brand NOT SIMILAR TO '[0-9]*'
) as unique_brand
WHERE
    brand_number = 1;
$transform_brand$;


CREATE FUNCTION transform_category()
RETURNS void
LANGUAGE SQL
AS
$transform_category$
TRUNCATE dds.category;

INSERT INTO
    dds.category
SELECT
    category_id,
    category_name
FROM (
    SELECT
        *,
        row_number() over (partition by category_id, category_name) as category_number
    FROM
        stg.category
    WHERE
        category_name NOT SIMILAR TO '[0-9]*'
        AND category_name NOT SIMILAR TO '[a-zA-Z]*'
) as unique_category
WHERE
    category_number = 1;
$transform_category$;


CREATE FUNCTION transform_store()
RETURNS void
LANGUAGE SQL
AS
$transform_store$
TRUNCATE dds.store;

INSERT INTO
    dds.store
SELECT
    *
FROM
    stg.store;
$transform_store$;


CREATE FUNCTION transform_product()
RETURNS void
LANGUAGE SQL
AS
$transform_product$
TRUNCATE dds.product;

INSERT INTO
    dds.product
SELECT
    product_id::INT,
    name_short,
    category_id,
    pricing_line_id::INT,
    brand_id::INT
FROM (
    SELECT
        *,
        row_number() over (partition by product_id, name_short, category_id, brand_id) as product_number
    FROM
        stg.product
    WHERE pricing_line_id SIMILAR TO '[0-9]+'
          AND name_short NOT SIMILAR TO '[0-9]*'
          AND name_short NOT SIMILAR TO '[a-zA-Z]*'
          AND category_id IN (SELECT category_id
                              FROM dds.category)
          AND brand_id::INT IN (SELECT brand_id
                           FROM dds.brand)
) as unique_product
WHERE
    product_number = 1;
$transform_product$;


CREATE FUNCTION transform_transaction()
RETURNS void
LANGUAGE SQL
AS
$transform_transaction$
TRUNCATE dds.transaction;

INSERT INTO
    dds.transaction
SELECT
    transaction_id,
    product_id::INT,
    recorded_on::TIMESTAMP,
    quantity::NUMERIC,
    price::NUMERIC,
    price_full::NUMERIC,
    'BUY' AS order_type_id
FROM (
    SELECT
        *,
        row_number() over (partition by transaction_id, product_id) as transaction_number
    FROM
        stg.transaction
    WHERE
        product_id::INT IN (SELECT product_id
                            FROM dds.product)
        AND transaction_id IN (SELECT transaction_id
                               FROM dds.transaction_store)
        AND quantity SIMILAR TO '[0-9]+(\.[0-9]+)?'
        AND price SIMILAR TO '[0-9]+(\.[0-9]+)?'
        AND price_full SIMILAR TO '[0-9]+(\.[0-9]+)?'
) as unique_transaction
WHERE
    transaction_number = 1;
$transform_transaction$;


CREATE FUNCTION transform_stock()
RETURNS void
LANGUAGE SQL
AS
$transform_stock$
TRUNCATE dds.stock;

INSERT INTO
    dds.stock
SELECT
    '1899-12-30'::DATE + available_on::INT AS available_on,
    product_id::INT,
    CASE WHEN pos SIMILAR TO '%999'
         THEN 'Магазин 9'
         ELSE pos
    END AS pos,
    available_quantity::NUMERIC,
    cost_per_item::NUMERIC
FROM (
    SELECT
        *,
        row_number() over (partition by available_on, product_id, pos) as stock_number
    FROM
        stg.stock
    WHERE
        product_id SIMILAR TO '[0-9]+'
        AND product_id::INT IN (SELECT product_id
                                FROM dds.product)
        AND available_quantity SIMILAR TO '[0-9]+(\.[0-9]+)?'
        AND cost_per_item SIMILAR TO '[0-9]+(\.[0-9]+)?'
) AS unique_stock
WHERE
    (available_on, product_id, pos) NOT IN (
    	SELECT
			available_on, product_id, pos
		FROM
			stg.stock
		WHERE
  			available_quantity SIMILAR TO '[0-9]+(\.[0-9]+)?'
    		AND cost_per_item SIMILAR TO '[0-9]+(\.[0-9]+)?'
		GROUP BY
			available_on, product_id, pos
		HAVING
			max(available_quantity::NUMERIC) != min(available_quantity::NUMERIC)
			OR max(cost_per_item::NUMERIC) != min(cost_per_item::NUMERIC)
	)
    AND stock_number = 1;
$transform_stock$;


CREATE FUNCTION transform_transaction_store()
RETURNS void
LANGUAGE SQL
AS
$transform_transaction_store$
TRUNCATE dds.transaction_store;

INSERT INTO
    dds.transaction_store
SELECT
    transaction_id,
    pos
FROM (
    SELECT
        *,
        row_number() over (partition by transaction_id, pos) as tran_st_number
    FROM
        stg.transaction_store
    WHERE
        pos IN (SELECT pos
                FROM dds.store)
        AND transaction_id != ''
        AND transaction_id IS NOT NULL
) as unique_tran_st
WHERE
    tran_st_number = 1;
$transform_transaction_store$;
