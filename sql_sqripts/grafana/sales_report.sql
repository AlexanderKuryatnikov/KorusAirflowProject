/*
3 запроса на общие выручку/количество/средний чек по отобранным данным.
Используются в отчёте продаж и анализе продаж.
*/
SELECT
    TO_CHAR(SUM(revenue), '999 999 999 999 999')
FROM
    datamarts.sales_report
WHERE
    pos_name IN ($pos_name_var)
    AND category_name IN ($category_var)
    AND $__timeFilter(recorded_on)

SELECT
    TO_CHAR(SUM(quantity), '999 999 999 999 999')
FROM
    datamarts.sales_report
WHERE
    pos_name IN ($pos_name_var)
    AND category_name IN ($category_var)
    AND $__timeFilter(recorded_on)

SELECT
    TO_CHAR(SUM(revenue) / SUM(quantity), '999 999 999 999 999')
FROM
    datamarts.sales_report
WHERE
    pos_name IN ($pos_name_var)
    AND category_name IN ($category_var)
    AND $__timeFilter(recorded_on)

/*
Таблица с общей информацией по продажам.
*/
SELECT
    name_short AS Товар,
    SUM(quantity) AS Количество,
    SUM(quantity) * 100 / (
        SELECT SUM(quantity)
        FROM datamarts.sales_report
        WHERE
            pos_name IN ($pos_name_var)
            AND category_name IN ($category_var)
            AND $__timeFilter(recorded_on)
    ) AS "Доля от общего количества, %",
    SUM(revenue) AS Выручка,
    SUM(revenue) * 100 / (
        SELECT SUM(revenue)
        FROM datamarts.sales_report
        WHERE
            pos_name IN ($pos_name_var)
            AND category_name IN ($category_var)
            AND $__timeFilter(recorded_on)
    ) AS "Доля от общей выручки, %",
    SUM(revenue) / SUM(quantity) AS "Средний чек продукта"
FROM
    datamarts.sales_report
WHERE
    pos_name IN ($pos_name_var)
    AND category_name IN ($category_var)
    AND $__timeFilter(recorded_on)
GROUP BY
    name_short