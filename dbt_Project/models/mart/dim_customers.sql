

WITH source_data AS (
    SELECT 
        customer_id,
        customer_unique_id,
        customer_zip_code_prefix,
        customer_city,
        customer_state
    FROM {{ source('raw_data', 'customers') }}
)

SELECT
    -- Surrogate key
    ROW_NUMBER() OVER (ORDER BY customer_id) AS customer_sk,

    customer_id,       
    customer_unique_id,
    UPPER(customer_city) AS customer_city,
    UPPER(customer_state) AS customer_state,
    customer_zip_code_prefix AS customer_zip_code

FROM source_data