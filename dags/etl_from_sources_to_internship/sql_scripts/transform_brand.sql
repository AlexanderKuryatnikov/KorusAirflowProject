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
