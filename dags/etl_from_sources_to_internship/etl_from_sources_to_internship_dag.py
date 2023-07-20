from airflow import DAG
from airflow.operators.empty import EmptyOperator
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
    schedule='@daily',
    catchup=False,
    default_args=DEFAULT_ARGS,
) as dag:
    start_task = EmptyOperator(task_id='start')
    end_task = EmptyOperator(task_id='end')

    load_tables_group = load_tables()
    transform_tables_group = transform_tables()
    invalidate_tables_group = invalidate_tables()

    (
        start_task >>
        load_tables_group >>
        transform_tables_group >>
        invalidate_tables_group >>
        end_task
    )
