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
