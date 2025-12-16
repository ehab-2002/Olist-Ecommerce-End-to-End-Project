

WITH products_source AS (
    SELECT * FROM {{ source('raw_data', 'products') }}
),

category_translation AS (
    SELECT * FROM {{ source('raw_data', 'product_category_name_translations') }}
),
 
products_dim AS (
    SELECT
        -- Surrogate key
        ROW_NUMBER() OVER (ORDER BY p.product_id) AS product_sk,

        p.product_id,
        
      
        COALESCE(t.product_category_name_english, p.product_category_name, 'Unknown') AS category_name,

       
    FROM products_source p
    LEFT JOIN category_translation t 
        ON p.product_category_name = t.product_category_name
)

SELECT * FROM products_dim