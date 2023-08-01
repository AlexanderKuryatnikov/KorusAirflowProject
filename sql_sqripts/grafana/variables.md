### Общие переменные для отчёта продаж, анализа продаж и сравнительного анализа
Выбор из списка магазинов
    - name: pos_name_var
    - variable type: query
    - label: Магазин
    - query: SELECT DISTINCT pos_name FROM datamarts.sales_report
    - sort: Alphabetical (case-insensitive, asc)
    - selection options: multi-value, include all options
Выбор из списка категорий
    - name: category_var
    - variable type: query
    - label: Категория
    - query: SELECT DISTINCT category_name FROM datamarts.sales_report
    - sort: Alphabetical (case-insensitive, asc)
    - selection options: multi-value, include all options

### Переменные для анализа продаж
Выбор топ 5 лучших или топ 5 худших
    - name: top_var
    - variable type: custom
    - label: Топ
    - custom options: лучших : DESC, худших : ASC
Выбор параметра расчёта топ 5
    - name: top_calc_var
    - variable type: custom
    - label: Рассчитать топ
    - custom options: по выручке : revenue, по количеству : quantity

### Переменные для сравнительного анализа по периодам
Выбор из списка товаров
    - name: product_var
    - variable type: query
    - label: Товар
    - query: SELECT DISTINCT name_short FROM datamarts.sales_report WHERE category_name IN ($category_var)
    - sort: Alphabetical (case-insensitive, asc)
    - selection options: multi-value, include all options
Выбор разницы между периодами
    - name: interval_var
    - variable type: custom
    - label: Предыдущий период
    - custom options: 7 дней назад : 7 days, 14 дней назад : 14 days, 1 месяц назад : 1 month, 2 месяца назад : 2 months, 3 месяца назад : 3 months, 6 месяцев назад : 6 months, 1 год назад : 1 year, 2 года назад : 2 years, 3 года назад : 3 years
Выбор параметра расчёта для сравнительного анализа
    - name: compare_calc_var
    - variable type: custom
    - label: Сравнить
    - custom options: по выручке : SUM(revenue), по количеству : SUM(quantity), по среднему чеку : SUM(revenue)/SUM(quantity)

### Переменные для прогноза закупок
Выбор из списка магазинов
    - name: pos_name_var
    - variable type: query
    - label: Магазин
    - query: SELECT DISTINCT pos_name FROM datamarts.purchase_forecast
    - sort: Alphabetical (case-insensitive, asc)
    - selection options: multi-value, include all options
Выбор из списка товаров
    - name: product_var
    - variable type: query
    - label: Товар
    - query: SELECT DISTINCT name_short FROM datamarts.purchase_forecast WHERE pos_name IN (@pos_name_var)
    - sort: Alphabetical (case-insensitive, asc)
    - selection options: multi-value, include all options
