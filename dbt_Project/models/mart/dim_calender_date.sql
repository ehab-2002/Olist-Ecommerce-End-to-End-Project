
WITH date_spine AS (
   
    SELECT 
        DATEADD(day, SEQ4(), '2015-01-01'::DATE) AS full_date
    FROM TABLE(GENERATOR(ROWCOUNT => 2200))
),

calculated_date AS (
    SELECT
        full_date,
        
        --   YYYYMMDD   surrogate key
        TO_NUMBER(TO_CHAR(full_date, 'YYYYMMDD')) AS date_key,
        
        -- تفاصيل التاريخ
        YEAR(full_date) AS year,
        QUARTER(full_date) AS quarter,
        MONTH(full_date) AS month,
        MONTHNAME(full_date) AS month_name,
        WEEKOFYEAR(full_date) AS week_of_year,
        
        -- اليوم في الأسبوع
        DAYOFWEEK(full_date) AS day_of_week,
        
        -- weekend
        CASE 
            WHEN DAYOFWEEK(full_date) IN (0, 6) THEN TRUE 
            ELSE FALSE 
        END AS is_weekend,
        
        -- holiday
        CASE 
            WHEN MONTH(full_date) = 1 AND DAY(full_date) = 1 THEN TRUE -- رأس السنة
            WHEN MONTH(full_date) = 12 AND DAY(full_date) = 25 THEN TRUE -- الكريسماس
            ELSE FALSE 
        END AS is_holiday

    FROM date_spine
)

SELECT *
FROM calculated_date
WHERE full_date <= '2020-12-31'
ORDER BY full_date
