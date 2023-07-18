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
