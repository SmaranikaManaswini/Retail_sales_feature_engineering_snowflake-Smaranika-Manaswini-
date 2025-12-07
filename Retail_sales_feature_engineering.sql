SELECT *
FROM retail_raw
LIMIT 20;
SELECT *
FROM retail_raw
WHERE sales IS NOT NULL;

SELECT *
FROM retail_raw
WHERE TRY_TO_DATE(date) IS NOT NULL;


CREATE OR REPLACE TABLE retail_clean AS
SELECT
    date,
    store_nbr,
    product_id,
    family,
    sales,
    promotion
FROM retail_raw
WHERE sales IS NOT NULL
ORDER BY date;

SELECT date, store_nbr, family, COUNT(*)
FROM retail_clean
GROUP BY date, store_nbr, family
HAVING COUNT(*) > 1;

SELECT *
FROM retail_clean
LIMIT 20;

SELECT store_nbr, family, MIN(date), MAX(date), COUNT(*)
FROM retail_clean
GROUP BY store_nbr, family;

CREATE OR REPLACE TABLE retail_features_final AS
WITH stats AS (
    SELECT 
        MIN(sales) AS min_sales,
        MAX(sales) AS max_sales,
        MIN(promotion) AS min_promo,
        MAX(promotion) AS max_promo
    FROM retail_clean
),
enc AS (
    SELECT
        *,
        DENSE_RANK() OVER (ORDER BY family) AS family_encoded
    FROM retail_clean
)

SELECT
    e.store_nbr,
    e.family,
    e.product_id,
    e.date,
    e.sales,
    e.promotion,

    -- Normalized features (Min-Max)
    (e.sales - s.min_sales) / NULLIF(s.max_sales - s.min_sales, 0)       AS sales_scaled,
    (e.promotion - s.min_promo) / NULLIF(s.max_promo - s.min_promo, 0)   AS promotion_scaled,

    -- Encoded categorical feature
    e.family_encoded,

    -- Time-series lag features
    LAG(e.sales, 1)  OVER (PARTITION BY e.store_nbr, e.family ORDER BY e.date) AS lag_1,
    LAG(e.sales, 7)  OVER (PARTITION BY e.store_nbr, e.family ORDER BY e.date) AS lag_7,
    LAG(e.sales, 30) OVER (PARTITION BY e.store_nbr, e.family ORDER BY e.date) AS lag_30,

    -- Rolling window features
    AVG(e.sales) OVER (
        PARTITION BY e.store_nbr, e.family
        ORDER BY e.date
        ROWS BETWEEN 6 PRECEDING AND CURRENT ROW
    ) AS rolling_avg_7,

    AVG(e.sales) OVER (
        PARTITION BY e.store_nbr, e.family
        ORDER BY e.date
        ROWS BETWEEN 29 PRECEDING AND CURRENT ROW
    ) AS rolling_avg_30,

    STDDEV(e.sales) OVER (
        PARTITION BY e.store_nbr, e.family
        ORDER BY e.date
        ROWS BETWEEN 29 PRECEDING AND CURRENT ROW
    ) AS rolling_std_30,

    -- Time-based calendar features
    EXTRACT(DAYOFWEEK FROM e.date) AS day_of_week,
    EXTRACT(MONTH     FROM e.date) AS month,
    EXTRACT(WEEK      FROM e.date) AS week_of_year,

    -- Extra transformations
    LN(1 + e.sales)         AS log_sales,
    e.sales * e.promotion   AS promo_effect

FROM enc e
CROSS JOIN stats s;


SELECT *
FROM retail_features_final
LIMIT 20;

CREATE OR REPLACE TABLE feature_store_retail AS
SELECT *
FROM retail_features_final;

SELECT MIN(date) AS min_date,
       MAX(date) AS max_date
FROM feature_store_retail;


CREATE OR REPLACE TABLE retail_train AS
SELECT *
FROM feature_store_retail
WHERE date < '2017-01-01';

CREATE OR REPLACE TABLE retail_test AS
SELECT *
FROM feature_store_retail
WHERE date >= '2017-01-01';

SELECT COLUMN_NAME
FROM INFORMATION_SCHEMA.COLUMNS
WHERE TABLE_NAME = 'FEATURE_STORE_RETAIL';

CREATE OR REPLACE TABLE PREDICTIONS_RETAIL (
    STORE_NBR INTEGER,
    FAMILY STRING,
    PRODUCT_ID INTEGER,
    DATE DATE,
    SALES FLOAT,
    PROMOTION FLOAT,
    SALES_SCALED FLOAT,
    PROMOTION_SCALED FLOAT,
    FAMILY_ENCODED INTEGER,
    LAG_1 FLOAT,
    LAG_7 FLOAT,
    LAG_30 FLOAT,
    ROLLING_AVG_7 FLOAT,
    ROLLING_AVG_30 FLOAT,
    ROLLING_STD_30 FLOAT,
    DAY_OF_WEEK INTEGER,
    MONTH INTEGER,
    WEEK_OF_YEAR INTEGER,
    LOG_SALES FLOAT,
    PROMO_EFFECT FLOAT,
    PREDICTED_SALES FLOAT
);

SELECT *
FROM PREDICTIONS_RETAIL
LIMIT 20;

