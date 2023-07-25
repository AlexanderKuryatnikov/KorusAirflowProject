from airflow import DAG
from airflow.operators.dummy_operator import DummyOperator
from airflow.operators.postgres_operator import PostgresOperator
from airflow.sensors.external_task_sensor import ExternalTaskSensor

from common_package.consts import (
    DEFAULT_ARGS,
    SCHEDULE,
    START_DATE
)


with DAG(
    dag_id='form_datamarts',
    start_date=START_DATE,
    schedule=SCHEDULE,
    catchup=False,
    default_args=DEFAULT_ARGS,
) as dag:
    wait_for_dds_task = ExternalTaskSensor(
        task_id='wait_for_dds',
        external_dag_id='etl_from_sources_to_internship',
    )

    form_sales_report_task = PostgresOperator(
        task_id='form_sales_report',
        sql='SELECT form_sales_report();'
    )
    form_purchase_forecast_task = PostgresOperator(
        task_id='form_purchase_forecast',
        sql='SELECT form_purchase_forecast();'
    )

    end_task = DummyOperator(task_id='end')

    wait_for_dds_task >> [
        form_sales_report_task,
        form_purchase_forecast_task
    ] >> end_task
