WITH raw_data AS (
    SELECT 
        patient_id,
        first_name,
        last_name,
        DATE(dob) AS dob,
        gender,
        LOWER(contact_info) AS contact_info,
        TIMESTAMP(created_at) AS created_at,
        TIMESTAMP(updated_at) AS updated_at
    FROM {{ source('raw_s3', 'tbl') }}  -- Use 'tbl' instead of 'patient_data'
)

SELECT * FROM raw_data
WHERE patient_id IS NOT NULL;
