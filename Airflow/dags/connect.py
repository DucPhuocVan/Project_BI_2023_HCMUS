from sqlalchemy import create_engine
from sqlalchemy.orm import sessionmaker
server = 'localhost'
port = '9876'
database_master = 'master'
username = 'sa'
password = 'password123'
driver = 'ODBC+Driver+17+for+SQL+Server'
database_source_USA = "projectBI_Source_USA"
database_staging = "projectBI_Staging"
database_NDS = "projectBI_NDS"
database_DW = "project_DW"
# IPAddress = "172.20.0.3"
IPAddress = "airflow-sqlserver-1"
container_name = 'airflow-airflow-webserver-1'

