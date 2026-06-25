
----Question 1  Y-on-Y Growth Rate
WITH yearly_spend AS (
    SELECT
        EXTRACT(YEAR FROM transaction_date) AS year,
        product_id,
        SUM(spend) AS curr_year_spend
    FROM user_transactions
    GROUP BY
        EXTRACT(YEAR FROM transaction_date),
        product_id
)

SELECT
    year,
    product_id,
    curr_year_spend,
    LAG(curr_year_spend) OVER(
        PARTITION BY product_id
        ORDER BY year
    ) AS prev_year_spend,
    ROUND(
        100 * (
            curr_year_spend -
            LAG(curr_year_spend) OVER(
                PARTITION BY product_id
                ORDER BY year
            )
        )
        /
        LAG(curr_year_spend) OVER(
            PARTITION BY product_id
            ORDER BY year
        ),
        2
    ) AS yoy_rate
FROM yearly_spend
ORDER BY product_id, year;



-----Question 2   Average Review Ratings

SELECT
    EXTRACT(MONTH FROM submit_date) AS mth,
    product_id AS product,
    ROUND(AVG(stars), 2) AS avg_stars
FROM reviews
GROUP BY
    EXTRACT(MONTH FROM submit_date),
    product_id
ORDER BY
    mth,
    product;
	
	
----- Question 3    Teams Power Users

SELECT
    sender_id,
    COUNT(message_id) AS message_count
FROM messages
WHERE EXTRACT(YEAR FROM sent_date) = 2022
  AND EXTRACT(MONTH FROM sent_date) = 8
GROUP BY sender_id
ORDER BY message_count DESC
LIMIT 2;