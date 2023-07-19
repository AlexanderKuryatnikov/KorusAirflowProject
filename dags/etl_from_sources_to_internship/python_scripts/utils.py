import csv

from airflow.exceptions import AirflowException
from airflow.providers.postgres.hooks.postgres import PostgresHook


def get_connection(conn_id):
    try:
        pg_hook = PostgresHook(postgres_conn_id=conn_id)
        connection = pg_hook.get_conn()
    except Exception as error:
        raise AirflowException(f'ERROR: Connect error: {error}')
    return connection


def load_and_close_connection(sql_table_name, table, connection):
    try:
        cursor_dds = connection.cursor()
        columns_num = len(table[0])
        args_str = ','.join(['%s'] * columns_num)
        values = ','.join(
            cursor_dds.mogrify(f'({args_str})', row).
            decode('utf-8') for row in table
        )
        insert_sql = f'INSERT INTO stg.{sql_table_name} VALUES '
        cursor_dds.execute(insert_sql + values)
        connection.commit()
        cursor_dds.close()
        connection.close()
    except Exception as error:
        raise AirflowException(f'ERROR: Error in loading data: {error}')


def load_from_source(sql_table_name, conn_id_from, conn_id_to):
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
