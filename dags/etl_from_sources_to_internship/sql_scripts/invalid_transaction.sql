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
