--Q1: Count transactions by status
q1 = """
SELECT clean_status,
       COUNT(*) AS transaction_count
FROM transactions
GROUP BY clean_status
ORDER BY transaction_count DESC;
"""



--Q2: Total captured GMV by merchant
q2 = """
SELECT clean_merchant,
       ROUND(SUM(amount_usd), 2) AS total_gmv
FROM transactions
WHERE clean_status = 'captured'
GROUP BY clean_merchant
ORDER BY total_gmv DESC;
"""


--Q3: Top 10 merchants by captured GMV
q3 = """
SELECT clean_merchant,
       ROUND(SUM(amount_usd), 2) AS total_gmv,
       COUNT(*) AS transaction_count
FROM transactions
WHERE clean_status = 'captured'
GROUP BY clean_merchant
ORDER BY total_gmv DESC
LIMIT 10;
"""



--Q4: Daily GMV and successful transaction count
q4 = """
SELECT clean_date,
       ROUND(SUM(amount_usd), 2) AS daily_gmv,
       COUNT(*) AS successful_count
FROM transactions
WHERE clean_status = 'captured'
GROUP BY clean_date
ORDER BY clean_date ASC;
"""



--Q5: Merchants with chargeback ratio above 1%
q5 = """
SELECT clean_merchant,
       COUNT(*) AS total_transactions,
       SUM(CASE WHEN clean_status = 'chargeback' THEN 1 ELSE 0 END) AS chargeback_count,
       ROUND(
         100.0 * SUM(CASE WHEN clean_status = 'chargeback' THEN 1 ELSE 0 END) / COUNT(*),
         2
       ) AS chargeback_pct
FROM transactions
GROUP BY clean_merchant
HAVING chargeback_pct > 1
ORDER BY chargeback_pct DESC;
"""



--Q6: Regions with avg risk score > 50 and 20+ transactions
q6 = """
SELECT clean_region,
       ROUND(AVG(clean_risk_score), 2) AS avg_risk_score,
       COUNT(*) AS total_transactions
FROM transactions
WHERE clean_risk_score IS NOT NULL
  AND clean_region IS NOT NULL
GROUP BY clean_region
HAVING avg_risk_score > 50
   AND total_transactions > 20
ORDER BY avg_risk_score DESC;
"""



--Q7: Users with 3+ failed/chargeback on same day
q7 = """
SELECT user_id,
       clean_date,
       COUNT(*) AS fail_count
FROM transactions
WHERE clean_status IN ('failed_timeout', 'chargeback')
GROUP BY user_id, clean_date
HAVING fail_count >= 3
ORDER BY fail_count DESC;
"""



--Q8: Chargeback summary by merchant
q8 = """
SELECT clean_merchant,
       COUNT(*) AS chargeback_count,
       COUNT(DISTINCT user_id) AS unique_affected_users,
       ROUND(SUM(amount_usd), 2) AS chargeback_amount
FROM transactions
WHERE clean_status = 'chargeback'
GROUP BY clean_merchant
ORDER BY chargeback_amount DESC;
"""

