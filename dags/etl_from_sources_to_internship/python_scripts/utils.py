import csv

from airflow.exceptions import AirflowException
from airflow.providers.postgres.hooks.postgres import PostgresHook
from psycopg2.extras import execute_values


def get_connection(conn_id):
    '''Подключение к БД.'''
    try:
        pg_hook = PostgresHook(postgres_conn_id=conn_id)
        connection = pg_hook.get_conn()
    except Exception as error:
        raise AirflowException(f'ERROR: Connect error: {error}')
    return connection


def load_and_close_connection(sql_table_name, table, connection):
    '''Загрузка таблицы в БД и отключение от БД.'''
    try:
        cursor_dds = connection.cursor()
        cursor_dds.execute(f'TRUNCATE TABLE stg.{sql_table_name};')
        execute_values(
            cursor_dds,
            f'INSERT INTO stg.{sql_table_name} VALUES %s',
            table
        )
        connection.commit()
        cursor_dds.close()
        connection.close()
    except Exception as error:
        raise AirflowException(f'ERROR: Error in loading data: {error}')


def load_from_source(sql_table_name, conn_id_from, conn_id_to):
    '''Копирование таблицы из одной БД в другую.'''
    connection_source = get_connection(conn_id=conn_id_from)
    try:
        cursor_source = connection_source.cursor()
        cursor_source.execute(f'SELECT * FROM sources.{sql_table_name}')
        table = cursor_source.fetchall()
        cursor_source.close()
        connection_source.close()
    except Exception as error:
        raise AirflowException(f'ERROR: Error in fetching data: {error}')

    connection_dds = get_connection(conn_id=conn_id_to)
    load_and_close_connection(sql_table_name=sql_table_name,
                              table=table,
                              connection=connection_dds)


def load_csv_to_db(sql_table_name, csv_path, conn_id):
    '''Загрузка таблицы в БД из csv файла.'''
    with open(csv_path, 'r', encoding='utf8') as f:
        csv_reader = csv.reader(f, delimiter=';')
        next(csv_reader)
        table = []
        for row in csv_reader:
            table.append(row)

    connection_dds = get_connection(conn_id=conn_id)
    load_and_close_connection(sql_table_name=sql_table_name,
                              table=table,
                              connection=connection_dds)
