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