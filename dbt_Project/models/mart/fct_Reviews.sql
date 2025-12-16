

WITH raw_reviews AS (
    SELECT 
        review_id,
        order_id,
        review_score,
        review_creation_date,
        review_answer_timestamp
    FROM {{ source('raw_data', 'reviews') }}
),


orders AS (
    SELECT 
        order_id,
        customer_id
    FROM {{ source('raw_data', 'orders') }}
),


dim_customers AS (
    SELECT customer_sk, customer_id FROM {{ ref('dim_customers') }}
),


review_fact AS (
    SELECT

        ROW_NUMBER() OVER (ORDER BY rev.review_creation_date, rev.review_id) as review_sk,


        rev.review_id,
        rev.order_id,
        
        cust.customer_sk, 

        TO_NUMBER(TO_CHAR(rev.review_creation_date, 'YYYYMMDD')) as review_date_key,

        rev.review_score,
        DATEDIFF(hour, rev.review_creation_date, rev.review_answer_timestamp) as review_response_time_hours

    FROM raw_reviews rev
    JOIN orders ord ON rev.order_id = ord.order_id
    
    LEFT JOIN dim_customers cust ON ord.customer_id = cust.customer_id
)

SELECT * FROM review_fact