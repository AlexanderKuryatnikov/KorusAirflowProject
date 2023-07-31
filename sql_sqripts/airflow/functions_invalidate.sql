CREATE FUNCTION invalidate_brand()
RETURNS void
LANGUAGE SQL
AS
$invalidate_brand$
TRUNCATE invalid_data.brand;

INSERT INTO
    invalid_data.brand
SELECT
    *,
    'неверное поле' AS error_description
FROM
    stg.brand
WHERE
    brand_id NOT SIMILAR TO '[0-9]+'
    OR brand SIMILAR TO '[0-9]*';
$invalidate_brand$;


CREATE FUNCTION invalidate_category()
RETURNS void
LANGUAGE SQL
AS
$invalidate_category$
TRUNCATE invalid_data.category;

INSERT INTO
    invalid_data.category
SELECT
    *,
    'неверное поле' AS error_description
FROM
    stg.category
WHERE
    category_name SIMILAR TO '[0-9]*'
    OR category_name SIMILAR TO '[a-zA-Z]*'
    OR category_name is NULL;
$invalidate_category$;


CREATE FUNCTION invalidate_store()
RETURNS void
LANGUAGE SQL
AS
$invalidate_store$
TRUNCATE invalid_data.store;

INSERT INTO
    invalid_data.store
SELECT
    *,
    'не определёно поле' AS error_description
FROM
    stg.store
WHERE
    pos IS NULL
    OR pos = ''
    OR pos_name IS NULL
    OR pos_name = ''
$invalidate_store$;


CREATE FUNCTION invalidate_product()
RETURNS void
LANGUAGE SQL
AS
$invalidate_product$
TRUNCATE invalid_data.product;

INSERT INTO
    invalid_data.product
SELECT
    *,
    'неверное поле pricing_line_id' AS error_description
FROM
    stg.product
WHERE
    pricing_line_id NOT SIMILAR TO '[0-9]+';

INSERT INTO
    invalid_data.product
SELECT
    *,
    'не определена категория' AS error_description
FROM
    stg.product
WHERE
    category_id NOT IN (SELECT category_id
                        FROM dds.category);

INSERT INTO
    invalid_data.product
SELECT
    *,
    'не определён бренд' AS error_description
FROM
    stg.product
WHERE
    brand_id NOT SIMILAR TO '[0-9]+'
    OR brand_id::INT NOT IN (SELECT brand_id
                             FROM dds.brand);

INSERT INTO
    invalid_data.product
SELECT
    *,
    'не определено название' AS error_description
FROM
    stg.product
WHERE
    name_short SIMILAR TO '[0-9]*'
    OR name_short SIMILAR TO '[a-zA-Z]*'
    OR name_short IS NULL;
$invalidate_product$;


CREATE FUNCTION invalidate_transaction()
RETURNS void
LANGUAGE SQL
AS
$invalidate_transaction$
TRUNCATE invalid_data.transaction;

INSERT INTO
    invalid_data.transaction
SELECT
    *,
    'не определён продукт' AS error_description
FROM
    stg.transaction
WHERE
    product_id NOT SIMILAR TO '[0-9]+'
    OR product_id::INT NOT IN (SELECT product_id
                               FROM dds.product);

INSERT INTO
    invalid_data.transaction
SELECT
    *,
    'неверное числовое поле' AS error_description
FROM
    stg.transaction
WHERE
    quantity NOT SIMILAR TO '[0-9]+(\.[0-9]+)?'
    OR price NOT SIMILAR TO '[0-9]+(\.[0-9]+)?'
    OR price_full NOT SIMILAR TO '[0-9]+(\.[0-9]+)?';

INSERT INTO
    invalid_data.transaction
SELECT
    *,
    'не определена транзакция'
FROM
    stg.transaction
WHERE  
    transaction_id NOT IN (SELECT transaction_id
                           FROM dds.transaction_store)
$invalidate_transaction$;


CREATE FUNCTION invalidate_stock()
RETURNS void
LANGUAGE SQL
AS
$invalidate_stock$
TRUNCATE invalid_data.stock;

INSERT INTO
    invalid_data.stock
SELECT
    *,
    'не определён продукт' AS error_description
FROM
    stg.stock
WHERE
    product_id NOT SIMILAR TO '[0-9]+'
    OR product_id::INT NOT IN (SELECT product_id
                               FROM dds.product);

INSERT INTO
    invalid_data.stock
SELECT
    *,
    'неверное числовое поле' AS error_description
FROM
    stg.stock
WHERE
    available_quantity NOT SIMILAR TO '[0-9]+(\.[0-9]+)?'
    OR cost_per_item NOT SIMILAR TO '[0-9]+(\.[0-9]+)?';

INSERT INTO
    invalid_data.stock
SELECT
    *,
    'неполные дубликаты' AS error_description
FROM
    stg.stock
WHERE
    (available_on, product_id, pos) IN (
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
	);
$invalidate_stock$;


CREATE FUNCTION invalidate_transaction_store()
RETURNS void
LANGUAGE SQL
AS
$transaction_store$
TRUNCATE invalid_data.transaction_store;

INSERT INTO
    invalid_data.transaction_store
SELECT
    *,
    'неверное поле transaction_id' AS error_description
FROM
    stg.transaction_store
WHERE
    transaction_id = ''
    OR transaction_id IS NULL;

INSERT INTO
    invalid_data.transaction_store
SELECT
    *,
    'неверное поле pos' AS error_description
FROM
    stg.transaction_store
WHERE
    pos NOT IN (SELECT pos
                FROM dds.store);
$transaction_store$;
