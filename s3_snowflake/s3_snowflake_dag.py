from airflow import DAG
from airflow.providers.fivetran.operators.fivetran import FivetranOperator
from airflow.providers.snowflake.operators.snowflake import SnowflakeOperator
from airflow.utils.dates import days_ago

default_args = {
    'owner': 'airflow',
    'start_date': days_ago(1),
    'catchup': False
}

with DAG(
    's3_to_snowflake_pipeline',
    default_args=default_args,
    schedule_interval='@daily',
    catchup=False
) as dag:

    # Trigger Fivetran to Sync S3 Data
    sync_s3_to_snowflake = FivetranOperator(
        task_id='sync_s3_to_snowflake',
        connector_id='your_fivetran_connector_id',
        wait_for_completion=True
    )

    # Run dbt Transformations in Snowflake
    run_dbt_transforms = SnowflakeOperator(
        task_id='run_dbt_transforms',
        sql="CALL dbt_run()",  # Use Snowflake's native dbt job execution
        snowflake_conn_id='snowflake_default'
    )

    # Task Dependencies
    sync_s3_to_snowflake >> run_dbt_transforms
