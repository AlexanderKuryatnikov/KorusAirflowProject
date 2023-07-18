# Korus Airflow Project
### Описание
Проект написан на Airflow. Оркестрируется процесс выгрузки данных из БД internship_sources, переноса и обработки данных в БД internship_6_db.
### Как запустить
1. Установить Docker и Docker Compose
2. Создать файл окружения .env и в нём указать:
    - AIRFLOW_UID=50000
    - _AIRFLOW_WWW_USER_USERNAME=логин (по умолчанию airflow)
    - _AIRFLOW_WWW_USER_PASSWORD=пароль (по умолчанию airflow)
4. Если отсутствуют, создать директории config, dags, plugins:
```
mkdir config dags plugins
```
3. Перед первым запуском выполнить миграцию бащы данных и создать первую учётную запись пользователя:
```
docker-compose up airflow-init
```
4. Запустить
```
docker-compose up
```
5. Открыть вебсервер по адресу http://localhost:8080
6. Настроить в UI подключение к базам данных (Admin > Connections > Add a new record):
    6.1. internship_sources
        - Connection Id: db_source
        - Connection Type: Postgres
        - Host: 10.1.108.29
        - Schema: internship_sources
        - Login: interns_6
        - Port: 5432
    6.1. internship_6_db
        - Connection Id: db_internship
        - Connection Type: Postgres
        - Host: 10.1.108.29
        - Schema: internship_6_db
        - Login: interns_6
        - Port: 5432
7. Запустить ДАГ etl_from_sources_to_internship_dag
### Разработчик
Александр Курятников