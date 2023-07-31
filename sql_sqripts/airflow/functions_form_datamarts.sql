CREATE FUNCTION form_sales_report()
RETURNS void
LANGUAGE SQL
AS
$form_sales_report$
TRUNCATE datamarts.sales_report;

INSERT INTO
    datamarts.sales_report(
        recorded_on,
        pos_name,
        name_short,
        category_name,
        quantity,
        price,
        revenue
    )
SELECT
	trans.recorded_on,
	store.pos_name,
	prod.name_short || ' id' || prod.product_id as name_short,
	cat.category_name,
	trans.quantity,
	trans.price,
	trans.price * trans.quantity AS revenue
FROM
	dds.product AS prod
	JOIN dds.transaction AS trans ON trans.product_id = prod.product_id
	JOIN dds.transaction_store AS trans_store ON trans_store.transaction_id = trans.transaction_id
	JOIN dds.category AS cat ON cat.category_id = prod.category_id
	JOIN dds.store AS store ON store.pos = trans_store.pos;
$form_sales_report$;


CREATE FUNCTION form_purchase_forecast()
RETURNS void
LANGUAGE SQL
AS
$form_purchase_forecast$
TRUNCATE datamarts.purchase_forecast;

INSERT INTO
    datamarts.purchase_forecast(
        available_on,
        name_short,
        brand,
        pos_name,
        available_quantity,
        cost_per_item
    )
SELECT
    stock.available_on,
    prod.name_short || ' id' || prod.product_id as name_short,
    brand.brand,
    store.pos_name,
    stock.available_quantity,
    stock.cost_per_item
FROM
    dds.stock AS stock
    JOIN dds.store AS store ON store.pos = stock.pos
    JOIN dds.product AS prod ON prod.product_id = stock.product_id
    JOIN dds.brand AS brand ON brand.brand_id = prod.brand_id;
$form_purchase_forecast$;
