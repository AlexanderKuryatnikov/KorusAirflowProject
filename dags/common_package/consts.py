from datetime import datetime


INTERNSHIP_CONN_ID = 'db_internship'
SOURCE_CONN_ID = 'db_source'

DEFAULT_ARGS = {
    'postgres_conn_id': INTERNSHIP_CONN_ID,
}

SCHEDULE = '55 * * * *'
START_DATE = datetime(2021, 1, 1)
