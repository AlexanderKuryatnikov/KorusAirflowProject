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
