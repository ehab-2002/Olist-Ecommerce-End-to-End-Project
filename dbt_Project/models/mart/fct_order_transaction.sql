

WITH orders AS (
    SELECT 
        order_id,
        customer_id,
        order_status,
        order_purchase_timestamp
    FROM {{ source('raw_data', 'orders') }}
),

items AS (
    SELECT 
        order_id,
        order_item_id,
        product_id,
        seller_id,
        price,
        freight_value
    FROM {{ source('raw_data', 'order_items') }}
),

dim_products AS (
    SELECT product_sk, product_id FROM {{ ref('dim_products') }}
),

dim_sellers AS (
    SELECT seller_sk, seller_id FROM {{ ref('dim_sellers') }}
),

dim_customers AS (
    SELECT customer_sk, customer_id FROM {{ ref('dim_customers') }}
),


transaction_fact AS (
    SELECT
        
      ROW_NUMBER() OVER (ORDER BY ord.order_id, itm.order_item_id) as fact_id,

        ord.order_id,
        itm.order_item_id,
        ord.order_status,

        cust.customer_sk,
        prod.product_sk,
        sel.seller_sk,
        
        TO_NUMBER(TO_CHAR(ord.order_purchase_timestamp, 'YYYYMMDD')) as order_date_key,

        
        itm.price,
        itm.freight_value,
        (itm.price + itm.freight_value) as total_amount

    FROM orders ord
   
    JOIN items itm ON ord.order_id = itm.order_id
    
    
    LEFT JOIN dim_customers cust ON ord.customer_id = cust.customer_id
    LEFT JOIN dim_products prod ON itm.product_id = prod.product_id
    LEFT JOIN dim_sellers sel ON itm.seller_id = sel.seller_id
)

SELECT * FROM transaction_fact