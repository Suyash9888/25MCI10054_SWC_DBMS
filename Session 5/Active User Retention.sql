SELECT
    EXTRACT(MONTH FROM curr.event_date) AS month,
    COUNT(DISTINCT curr.user_id) AS monthly_active_users
FROM user_actions curr
WHERE EXTRACT(YEAR FROM curr.event_date) = 2022
  AND EXTRACT(MONTH FROM curr.event_date) = 7
  AND EXISTS (
        SELECT 1
        FROM user_actions prev
        WHERE prev.user_id = curr.user_id
          AND DATE_TRUNC('month', prev.event_date)
              = DATE_TRUNC('month', curr.event_date) - INTERVAL '1 month'
  )
GROUP BY month;
