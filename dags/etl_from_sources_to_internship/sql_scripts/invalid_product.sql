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