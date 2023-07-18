INSERT INTO
    dds.product
SELECT
    product_id::INT,
    name_short,
    category_id,
    pricing_line_id::INT,
    brand_id::INT
FROM (
    SELECT
        *,
        row_number() over (partition by product_id, name_short, category_id, brand_id) as product_number
    FROM
        stg.product
    WHERE pricing_line_id SIMILAR TO '[0-9]+'
          AND name_short NOT SIMILAR TO '[0-9]*'
          AND name_short NOT SIMILAR TO '[a-zA-Z]*'
          AND category_id IN (SELECT category_id
                              FROM dds.category)
          AND brand_id::INT IN (SELECT brand_id
                           FROM dds.brand)
) as unique_product
WHERE
    product_number = 1;
