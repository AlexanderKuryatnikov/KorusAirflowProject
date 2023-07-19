from airflow.decorators import task, task_group
from airflow.operators.postgres_operator import PostgresOperator

from etl_from_sources_to_internship.python_scripts.consts import (
    CSV_PATH,
    INTERNSHIP_CONN_ID,
    SOURCE_CONN_ID,
    TABLE_NAMES
)
from etl_from_sources_to_internship.python_scripts.utils import (
    load_csv_to_db,
    load_from_source
)


@task_group(group_id='load_tables')
def load_tables():
    for table_name in TABLE_NAMES:
        @task(task_id=f'load_{table_name}')
        def load_table(table_name=table_name):
            if table_name == 'store':
                load_csv_to_db(
                    sql_table_name=f'{table_name}',
                    csv_path=f'{CSV_PATH}/stores.csv',
                    conn_id=INTERNSHIP_CONN_ID
                )
            elif table_name == 'transaction_store':
                load_csv_to_db(
                    sql_table_name=f'{table_name}',
                    csv_path=f'{CSV_PATH}/транзакции-магазины.csv',
                    conn_id=INTERNSHIP_CONN_ID
                )
            else:
                load_from_source(
                    sql_table_name=f'{table_name}',
                    conn_id_from=SOURCE_CONN_ID,
                    conn_id_to=INTERNSHIP_CONN_ID
                )
        load_table()


@task_group(group_id='transform_tables')
def transform_tables():
    transform_brand_task = PostgresOperator(
        task_id='transform_brand',
        sql='SELECT transform_brand();'
    )
    transform_category_task = PostgresOperator(
        task_id='transform_category',
        sql='SELECT transform_category();'
    )
    transform_store_task = PostgresOperator(
        task_id='transform_store',
        sql='SELECT transform_store();'
    )
    transform_product_task = PostgresOperator(
        task_id='transform_product',
        sql='SELECT transform_product();'
    )
    transform_stock_task = PostgresOperator(
        task_id='transform_stock',
        sql='SELECT transform_stock();'
    )
    transform_transaction_task = PostgresOperator(
        task_id='transform_transaction',
        sql='SELECT transform_transaction();'
    )
    transform_transaction_store_task = PostgresOperator(
        task_id='transform_transaction_store',
        sql='SELECT transform_transaction_store();'
    )

    [
        transform_brand_task, transform_category_task
    ] >> transform_product_task >> [
        transform_transaction_task, transform_stock_task
    ]
    transform_store_task >> [
        transform_stock_task, transform_transaction_store_task
    ]
    transform_transaction_store_task >> transform_transaction_task


@task_group(group_id='invalidate_tables')
def invalid_tables():
    for table_name in TABLE_NAMES:
        PostgresOperator(
            task_id=f'invalidate_{table_name}',
            sql=f'SELECT invalidate_{table_name}();'
        )
