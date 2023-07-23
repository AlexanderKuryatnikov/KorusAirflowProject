from airflow import DAG
from airflow.operators.dummy_operator import DummyOperator
from airflow.operators.postgres_operator import PostgresOperator
from datetime import datetime

from common_package.consts import (
    DEFAULT_ARGS
)


with DAG(
    dag_id='form_datamarts',
    start_date=datetime(2021, 1, 1),
    schedule=None,
    catchup=False,
    default_args=DEFAULT_ARGS,
) as dag:
    start_task = DummyOperator(task_id='start')
    end_task = DummyOperator(task_id='end')

    form_sales_report_task = PostgresOperator(
        task_id='form_sales_report',
        sql='SELECT form_sales_report();'
    )
    form_purchase_forecast_task = PostgresOperator(
        task_id='form_purchase_forecast',
        sql='SELECT form_purchase_forecast();'
    )

    start_task >> [
        form_sales_report_task,
        form_purchase_forecast_task
    ] >> end_task
