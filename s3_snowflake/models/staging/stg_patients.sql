{{ config(
    materialized='incremental',
    unique_key='patient_id'
) }}

WITH source AS (
    SELECT
        patient_id::INT AS patient_id,
        first_name::STRING AS first_name,
        last_name::STRING AS last_name,
        TRY_TO_DATE(dob, 'MM/DD/YYYY') AS dob,
        gender::STRING AS gender,
        contact_info::STRING AS contact_info,

        -- Fix timestamps (S3 has only time, add current date)
        CASE 
            WHEN created_at LIKE '__:__:__%' 
            THEN TO_TIMESTAMP(CONCAT(CURRENT_DATE, ' ', created_at), 'YYYY-MM-DD HH24:MI:SS.FF')
            ELSE NULL 
        END AS created_at,

        CASE 
            WHEN updated_at LIKE '__:__:__%' 
            THEN TO_TIMESTAMP(CONCAT(CURRENT_DATE, ' ', updated_at), 'YYYY-MM-DD HH24:MI:SS.FF')
            ELSE NULL 
        END AS updated_at

    FROM {{ source('raw', 'patients') }}
)

SELECT * FROM source;
