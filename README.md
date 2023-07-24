# Korus Airflow Project
### Описание
Проект написан на Airflow. Оркестрируется процесс загрузки и обработки данных двумя ДАГами:
1. etl_from_sources_to_internship \
    Загружает данные из БД internship_sources, переносит и обработывает данные в БД internship_6_db в три слоя: stg, dds, invalid_data. После наполнения слоя dds запускается ДАГ form_datamarts.
3. form_datamarts \
    Перезаписывает витрины.
### Как запустить
1. Установить Docker и Docker Compose
2. Клонировать репозиторий и перейти в директорию:
```
git clone git@github.com:AlexanderKuryatnikov/KorusAirflowProject.git
cd KorusAirflowProject
```
3. Создать файл окружения .env и в нём указать:
    - AIRFLOW_UID=50000
    - _AIRFLOW_WWW_USER_USERNAME=логин (по умолчанию airflow)
    - _AIRFLOW_WWW_USER_PASSWORD=пароль (по умолчанию airflow)
4. Если отсутствуют, создать директории config, dags, plugins:
```
mkdir config dags plugins
```
5. Перед первым запуском выполнить миграцию бащы данных и создать первую учётную запись пользователя:
```
docker-compose up airflow-init
```
6. Запустить
```
docker-compose up
```
7. Открыть вебсервер по адресу http://localhost:8080
8. Настроить в UI подключение к базам данных (Admin > Connections > Add a new record):
    1. internship_sources
        - Connection Id: db_source
        - Connection Type: Postgres
        - Host: 10.1.108.29
        - Schema: internship_sources
        - Login: interns_6
        - Port: 5432
    2. internship_6_db
        - Connection Id: db_internship
        - Connection Type: Postgres
        - Host: 10.1.108.29
        - Schema: internship_6_db
        - Login: interns_6
        - Port: 5432
9. Запустить ДАГ etl_from_sources_to_internship_dag
### Разработчик
Александр Курятников
