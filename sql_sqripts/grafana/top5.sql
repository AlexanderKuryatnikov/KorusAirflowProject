/*
Запрос для создания круговой диаграммы топ 5 товаров.
*/
(
SELECT
    name_short,
    $top_calc_var AS sum_field
FROM
    datamarts.sales_report
WHERE
    pos_name IN ($pos_name_var)
    AND category_name IN ($category_var)
    AND $__timeFilter(recorded_on)
GROUP BY
    name_short
ORDER BY sum_field $top_var
LIMIT 5
)
UNION
(
SELECT
    'другие' AS name_short,
    SUM(sum_field) AS sum_field
FROM (
    SELECT
        name_short,
        $top_calc_var AS sum_field
    FROM
        datamarts.sales_report
    WHERE
        pos_name IN ($pos_name_var)
        AND category_name IN ($category_var)
        AND $__timeFilter(recorded_on)
    GROUP BY
        name_short
    ORDER BY sum_field $top_var
    OFFSET 5
) as other_products
)

/*
Запрос для создания линейного графа топ 5 товаров.
Требуется указать трансформацию Prepare time series/multi-frame time series
*/
SELECT
    recorded_on,
    revenue,
    name_short
FROM
    datamarts.sales_report
WHERE
    name_short IN (
        SELECT
            name_short
        FROM
            datamarts.sales_report
        WHERE
            pos_name IN ($pos_name_var)
            AND category_name IN ($category_var)
            AND $__timeFilter(recorded_on)
        GROUP BY
            name_short
        ORDER BY
            SUM(revenue) $top_var
        LIMIT 5
    )
