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