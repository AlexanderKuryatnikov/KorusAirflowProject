from airflow import DAG
from airflow.decorators import task, task_group
from airflow.operators.postgres_operator import PostgresOperator
from datetime import datetime

from etl_from_sources_to_internship.python_scripts.utils import (
    load_csv_to_db,
    load_from_source
)


table_names = (
    'brand',
    'category',
    'store',
    'product',
    'stock',
    'transaction',
)
default_args = {
    'postgres_conn_id': 'db_internship',
}


@task_group(group_id='load_tables')
def load_tables():
    for table_name in table_names:
        @task(task_id=f'load_{table_name}')
        def load_table(table_name=table_name):
            if table_name == 'store':
                load_csv_to_db(
                    sql_table_name=f'{table_name}',
                    csv_path=('dags/etl_from_sources_to_internship/'
                              f'csv_files/{table_name}s.csv')
                )
            else:
                load_from_source(sql_table_name=f'{table_name}')
        load_table()


@task_group(group_id='invalid_tables')
def invalid_tables():
    for table_name in table_names:
        PostgresOperator(
            task_id=f'invalid_{table_name}',
            sql=f'invalid_{table_name}.sql'
        )


@task_group(group_id='transform_tables')
def transform_tables():
    transform_brand_task = PostgresOperator(
        task_id='transform_brand',
        sql='transform_brand.sql'
    )
    transform_category_task = PostgresOperator(
        task_id='transform_category',
        sql='transform_category.sql'
    )
    transform_store_task = PostgresOperator(
        task_id='transform_store',
        sql='transform_store.sql'
    )
    transform_product_task = PostgresOperator(
        task_id='transform_product',
        sql='transform_product.sql'
    )
    transform_stock_task = PostgresOperator(
        task_id='transform_stock',
        sql='transform_stock.sql'
    )
    transform_transaction_task = PostgresOperator(
        task_id='transform_transaction',
        sql='transform_transaction.sql'
    )

    [
        transform_brand_task, transform_category_task
    ] >> transform_product_task >> transform_transaction_task

    transform_product_task >> transform_stock_task
    transform_store_task >> transform_stock_task


with DAG(
    dag_id='etl_from_sources_to_internship',
    start_date=datetime(2021, 1, 1),
    schedule='@once',
    catchup=False,
    default_args=default_args,
    template_searchpath=['dags/etl_from_sources_to_internship/sql_scripts']
) as dag:
    truncate_stg_task = PostgresOperator(
        task_id='truncate_stg',
        sql='truncate_stg.sql'
    )
    truncate_dds_task = PostgresOperator(
        task_id='truncate_dds',
        sql='truncate_dds.sql'
    )
    truncate_invalid_data_task = PostgresOperator(
        task_id='truncate_invalid_data',
        sql='truncate_invalid_data.sql'
    )

    load_tables_group = load_tables()
    transform_tables_group = transform_tables()
    invalid_tables_group = invalid_tables()

    (
        truncate_stg_task >>
        load_tables_group >>
        truncate_dds_task >>
        transform_tables_group >>
        truncate_invalid_data_task >>
        invalid_tables_group
    )
