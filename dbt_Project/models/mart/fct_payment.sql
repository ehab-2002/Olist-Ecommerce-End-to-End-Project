{{ config(
    materialized='table',
    tags=['facts']
) }}

WITH payments AS (
    SELECT 
        order_id,
        payment_sequential,
        payment_type,
        payment_installments,
        payment_value
    FROM {{ source('raw_data', 'payments') }}
),

orders AS (
    SELECT 
        order_id,
        customer_id,
        order_purchase_timestamp
    FROM {{ source('raw_data', 'orders') }}
),


dim_customers AS (
    SELECT customer_sk, customer_id FROM {{ ref('dim_customers') }}
),


fact_payment AS (
    SELECT
       
      ROW_NUMBER() OVER (ORDER BY pay.order_id, pay.payment_sequential) as payment_sk,

        
        pay.order_id,
        pay.payment_sequential,
        pay.payment_type, 
        
        cust.customer_sk,
        TO_NUMBER(TO_CHAR(ord.order_purchase_timestamp, 'YYYYMMDD')) as payment_date_key,

        pay.payment_installments,
        pay.payment_value

    FROM payments pay
    JOIN orders ord ON pay.order_id = ord.order_id
    LEFT JOIN dim_customers cust ON ord.customer_id = cust.customer_id
)

SELECT * FROM fact_payment