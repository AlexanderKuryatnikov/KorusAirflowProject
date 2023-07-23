from airflow import DAG
from airflow.operators.dummy_operator import DummyOperator
from datetime import datetime

from common_package.consts import (
    DEFAULT_ARGS
)


with DAG(
    dag_id='form_datamart',
    start_date=datetime(2021, 1, 1),
    schedule=None,
    catchup=False,
    default_args=DEFAULT_ARGS,
) as dag:
    start_task = DummyOperator(task_id='start')
    end_task = DummyOperator(task_id='end')

    start_task >> end_task
