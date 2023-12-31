from datetime import datetime
from airflow import DAG 
from airflow.operators.dummy_operator import DummyOperator
from airflow.operators.python_operator import PythonOperator
from airflow.operators.bash_operator import BashOperator
from airflow.sensors.external_task import ExternalTaskSensor

import os

default_args = {
    'owner': 'Tan',
    'start_date': datetime(2023,12,30),
    'email':'projectBI@gmail.com',
    'email_on_failure':True,
    'schedule_interval':'0 0 * * *'
} 

with DAG('pipeline_2', default_args=default_args, catchup=True) as DAG:
    START = DummyOperator(task_id = 'START')
    FINISH = DummyOperator(task_id = 'FINISH')
    pipeline_2 = BashOperator(
        task_id = 'pipeline_2',
        bash_command = 'cd /opt/airflow/dags/save/dbt_pipeline_2 && dbt run'
    )

wait_for_extract = ExternalTaskSensor(
    task_id = 'wait_pipeline_1',
    external_dag_id = 'pipeline_1',
    external_task_id= 'FINISH',
    start_date = datetime(2023,12,30)
)

START >> wait_for_extract >> pipeline_2 >> FINISH
# START >> pipeline_2 >> FINISH