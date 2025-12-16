
WITH sellers_source AS (
    SELECT 
        seller_id,
        seller_zip_code_prefix,
        seller_city,
        seller_state
    FROM {{ source('raw_data', 'sellers') }}
)

SELECT
    --Surrogate key
    ROW_NUMBER() OVER (ORDER BY seller_id) AS seller_sk,

    
    seller_id,
    UPPER(seller_city) AS seller_city,
    UPPER(seller_state) AS seller_state,
    seller_zip_code_prefix AS seller_zip_code

FROM sellers_source