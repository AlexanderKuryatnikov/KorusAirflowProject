/* Таблица для прогноза закупок. */
SELECT
    name_short AS Товар,
    brand AS Бренд,
    SUM(available_quantity) AS "Остаток на складе",
    AVG(cost_per_item) AS "Средняя цена за единицу",
    '' AS "Количество на закупку",
    '' AS "Дата закупки"
FROM
    datamarts.purchase_forecast
WHERE
    pos_name IN ($pos_name_var)
    AND name_short IN ($product_var)
    AND available_on = '${__from:date:YYYY-MM-DD}'
GROUP BY
    name_short, brand