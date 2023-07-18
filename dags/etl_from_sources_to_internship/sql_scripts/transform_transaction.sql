INSERT INTO
    dds.transaction
SELECT
    transaction_id,
    product_id::INT,
    recorded_on::TIMESTAMP,
    quantity::NUMERIC,
    price::NUMERIC,
    price_full::NUMERIC,
    'BUY' AS order_type_id
FROM (
    SELECT
        *,
        row_number() over (partition by transaction_id, product_id) as transaction_number
    FROM
        stg.transaction
    WHERE
        product_id::INT IN (SELECT product_id
                            FROM dds.product)
        AND quantity SIMILAR TO '[0-9]+(\.[0-9]+)?'
        AND price SIMILAR TO '[0-9]+(\.[0-9]+)?'
        AND price_full SIMILAR TO '[0-9]+(\.[0-9]+)?'
) as unique_transaction
WHERE
    transaction_number = 1;
