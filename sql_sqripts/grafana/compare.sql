/* Запрос для графика сравнительного анализа по периодам. */
SELECT
    COALESCE(period1.Дата, period2.Дата) AS Дата,
    period1.field_prev AS "Ранний период",
    period2.field_now AS "Поздний период"
FROM (
    SELECT
    	recorded_on::DATE || ' / ' || (recorded_on::DATE + interval '$interval_var')::DATE AS Дата,
	    $compare_calc_var AS field_prev
	FROM datamarts.sales_report
	WHERE
	    $__timeFilter(recorded_on + interval '$interval_var')
        AND name_short IN ($product_var)
        AND pos_name IN ($pos_name_var)
        AND category_name IN ($category_var)
	GROUP BY
    	recorded_on::DATE
    ) AS period1 FULL JOIN (
    SELECT
        (recorded_on::DATE - interval '$interval_var')::DATE || ' / ' || recorded_on::DATE AS Дата,
        $compare_calc_var AS field_now
    FROM datamarts.sales_report
    WHERE
        $__timeFilter(recorded_on)
        AND name_short IN ($product_var)
        AND pos_name IN ($pos_name_var)
        AND category_name IN ($category_var)
    GROUP BY
        recorded_on::DATE
    ) AS period2 ON period1.Дата = period2.Дата
ORDER BY Дата


/* Ранний период. */
/* Общая выручка. */
SELECT
    TO_CHAR(SUM(revenue), '999 999 999 999 999')
FROM
    datamarts.sales_report
WHERE
    $__timeFilter(recorded_on + interval '$interval_var')
    AND name_short IN ($product_var)
    AND pos_name IN ($pos_name_var)
    AND category_name IN ($category_var)

/* Общее количество. */
SELECT
    TO_CHAR(SUM(quantity), '999 999 999 999 999')
FROM
    datamarts.sales_report
WHERE
    $__timeFilter(recorded_on + interval '$interval_var')
    AND name_short IN ($product_var)
    AND pos_name IN ($pos_name_var)
    AND category_name IN ($category_var)

/* Общий средний чек. */
SELECT
    TO_CHAR(SUM(revenue) / SUM(quantity), '999 999 999 999 999')
FROM
    datamarts.sales_report
WHERE
    $__timeFilter(recorded_on)
    AND name_short IN ($product_var)
    AND pos_name IN ($pos_name_var)
    AND category_name IN ($category_var)


/* Поздний период. */
/* Общая выручка. */
SELECT
    TO_CHAR(SUM(revenue), '999 999 999 999 999')
FROM
    datamarts.sales_report
WHERE
    $__timeFilter(recorded_on)
    AND name_short IN ($product_var)
    AND pos_name IN ($pos_name_var)
    AND category_name IN ($category_var)

/* Общее количество. */
SELECT
    TO_CHAR(SUM(quantity), '999 999 999 999 999')
FROM
    datamarts.sales_report
WHERE
    $__timeFilter(recorded_on)
    AND name_short IN ($product_var)
    AND pos_name IN ($pos_name_var)
    AND category_name IN ($category_var)

/* Общий средний чек. */
SELECT
    TO_CHAR(SUM(revenue) / SUM(quantity), '999 999 999 999 999')
FROM
    datamarts.sales_report
WHERE
    $__timeFilter(recorded_on)
    AND name_short IN ($product_var)
    AND pos_name IN ($pos_name_var)
    AND category_name IN ($category_var)