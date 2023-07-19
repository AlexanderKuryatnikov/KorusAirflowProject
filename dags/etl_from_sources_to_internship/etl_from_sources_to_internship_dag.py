from airflow import DAG
from airflow.operators.empty import EmptyOperator
from airflow.operators.postgres_operator import PostgresOperator
from datetime import datetime

from etl_from_sources_to_internship.python_scripts.consts import (
    DEFAULT_ARGS
)
from etl_from_sources_to_internship.python_scripts.task_groups import (
    invalidate_tables,
    load_tables,
    transform_tables
)


with DAG(
    dag_id='etl_from_sources_to_internship',
    start_date=datetime(2021, 1, 1),
    schedule='@once',
    catchup=False,
    default_args=DEFAULT_ARGS,
) as dag:
    start_task = EmptyOperator(task_id='start')
    end_task = EmptyOperator(task_id='end')

    truncate_stg_task = PostgresOperator(
        task_id='truncate_stg',
        sql='SELECT truncate_stg();'
    )
    truncate_dds_task = PostgresOperator(
        task_id='truncate_dds',
        sql='SELECT truncate_dds();'
    )
    truncate_invalid_data_task = PostgresOperator(
        task_id='truncate_invalid_data',
        sql='SELECT truncate_invalid_data();'
    )

    load_tables_group = load_tables()
    transform_tables_group = transform_tables()
    invalidate_tables_group = invalidate_tables()

    (
        start_task >>
        truncate_stg_task >>
        load_tables_group >>
        truncate_dds_task >>
        transform_tables_group >>
        truncate_invalid_data_task >>
        invalidate_tables_group >>
        end_task
    )
