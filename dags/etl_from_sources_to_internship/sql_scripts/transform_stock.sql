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
