

WITH orders AS (
    SELECT * FROM {{ source('raw_data', 'orders') }}
),

items AS (
    SELECT 
        order_id,
        order_item_id,
        seller_id,
        product_id,
        shipping_limit_date 
    FROM {{ source('raw_data', 'order_items') }}
),


dim_sellers AS (
    SELECT seller_sk, seller_id FROM {{ ref('dim_sellers') }}
),

dim_products AS ( 
    SELECT product_sk, product_id FROM {{ ref('dim_products') }}
),

dim_customers AS (
    SELECT customer_sk, customer_id FROM {{ ref('dim_customers') }}
),


Accumulate_fact AS (
    SELECT
       
        ROW_NUMBER() OVER (ORDER BY ord.order_purchase_timestamp, itm.order_item_id) as Accumulate_fact_sk,

       
        ord.order_id,
        itm.order_item_id, 
        ord.order_status,
        
        cust.customer_sk,
        sel.seller_sk,   
        prod.product_sk,

        
        TO_NUMBER(TO_CHAR(ord.order_purchase_timestamp, 'YYYYMMDD')) as purchase_date_key,
        TO_NUMBER(TO_CHAR(ord.order_approved_at, 'YYYYMMDD')) as approved_date_key,
        TO_NUMBER(TO_CHAR(ord.order_delivered_carrier_date, 'YYYYMMDD')) as carrier_pickup_date_key,
        TO_NUMBER(TO_CHAR(ord.order_delivered_customer_date, 'YYYYMMDD')) as delivered_date_key,
        TO_NUMBER(TO_CHAR(ord.order_estimated_delivery_date, 'YYYYMMDD')) as estimated_date_key,
        TO_NUMBER(TO_CHAR(itm.shipping_limit_date, 'YYYYMMDD')) as seller_deadline_date_key,

        DATEDIFF(day, ord.order_approved_at, ord.order_delivered_carrier_date) as days_to_ship,
        
        DATEDIFF(day, ord.order_delivered_carrier_date, itm.shipping_limit_date) as seller_sla_diff,

        DATEDIFF(day, ord.order_delivered_carrier_date, ord.order_delivered_customer_date) as days_in_transit,
        
        DATEDIFF(day, ord.order_purchase_timestamp, ord.order_delivered_customer_date) as total_delivery_days

    FROM orders ord
    JOIN items itm ON ord.order_id = itm.order_id
    
    LEFT JOIN dim_customers cust ON ord.customer_id = cust.customer_id
    LEFT JOIN dim_sellers sel ON itm.seller_id = sel.seller_id
    LEFT JOIN dim_products prod ON itm.product_id = prod.product_id
)

SELECT * FROM Accumulate_fact