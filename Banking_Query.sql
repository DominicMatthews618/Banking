-- View  Entire Customers table
select *
from customers;

-- View  Entire Transactions table
select *
from transactions;

-- 1. Total Monthly Spend per Customer
SELECT
    customer_id,
    DATE_FORMAT(txn_date, '%Y-%m') AS txn_month,
    SUM(amount) AS total_monthly_spend
FROM transactions
WHERE status = 'Success'
GROUP BY customer_id, txn_month
ORDER BY customer_id, txn_month;

-- 2. Average Spend per Category
SELECT
    category,
    AVG(amount) AS avg_spend
FROM transactions
WHERE status = 'Success'
GROUP BY category
ORDER BY avg_spend DESC;

-- 3. Number of Transactions per Month
SELECT
    DATE_FORMAT(txn_date, '%Y-%m') AS txn_month,
    COUNT(*) AS num_transactions
FROM transactions
WHERE status = 'Success'
GROUP BY txn_month
ORDER BY txn_month;

-- 4. Top 5 Merchants by Total Spend
SELECT merchant_name, SUM(amount) AS total_spend
FROM transactions
WHERE status = 'Success'
GROUP BY merchant_name
ORDER BY total_spend DESC
LIMIT 5;

-- 5. Spend by Payment Method (Credit vs. Debit)
SELECT method, COUNT(*) AS txn_count, SUM(amount) AS total_spent
FROM transactions
WHERE status = 'Success'
GROUP BY method;

-- 6. Day of Week Transaction Patterns
SELECT 
  DAYNAME(txn_date) AS day_of_week,
  COUNT(*) AS txn_count,
  SUM(amount) AS total_spent
FROM transactions
WHERE status = 'Success'
GROUP BY day_of_week
ORDER BY FIELD(day_of_week, 'Sunday', 'Monday', 'Tuesday', 'Wednesday', 'Thursday', 'Friday', 'Saturday');

-- 7. High Value Transactions example over $1000
SELECT * 
FROM transactions
WHERE amount > 1000
ORDER BY amount DESC;
-- ----------------------------------------------------------- Fraud Detection ------------------------------------------------------------------------------------------------------------
-- 8. Failed Transaction Rate by Customer
SELECT customer_id,
  COUNT(*) AS total_txns,
  SUM(CASE WHEN status = 'Failed' THEN 1 ELSE 0 END) AS failed_txns,
  ROUND(SUM(CASE WHEN status = 'Failed' THEN 1 ELSE 0 END) / COUNT(*) * 100, 2) AS failure_rate_pct
FROM transactions
GROUP BY customer_id
ORDER BY failure_rate_pct DESC;

-- 9. Transactions over $3000(Approaching Bank Limit)
SELECT * 
FROM transactions
WHERE amount > 3000
ORDER BY amount DESC;

-- 10. Flag Total Daily Spending $5000 or more
SELECT 
    customer_id,
    txn_date,
    SUM(amount) AS total_daily_spend
FROM transactions
-- WHERE status = 'Success'  -- Optional: include only successful transactions
GROUP BY customer_id, txn_date
HAVING SUM(amount) >= 5000
ORDER BY txn_date, customer_id;

-- 11. Flagging Transactions made by 1 customer in two or more different cities on the same day
SELECT 
    t.customer_id,
    t.txn_date,
    t.txn_city,
    t.amount,
    t.merchant_name,
    t.method
FROM transactions t
JOIN (
    SELECT
        customer_id,
        txn_date
    FROM transactions
    WHERE status = 'Success'
    GROUP BY customer_id, txn_date
    HAVING COUNT(DISTINCT txn_city) >= 2
) flagged
ON t.customer_id = flagged.customer_id AND t.txn_date = flagged.txn_date
WHERE t.status = 'Success'
ORDER BY t.customer_id, t.txn_date, t.txn_city,t.merchant_name, t.method;

-- 12. Average Transaction Amount per Customer
SELECT 
    customer_id,
    ROUND(AVG(amount), 2) AS avg_txn_amount,
    COUNT(*) AS txn_count
FROM transactions
WHERE status = 'Success'
GROUP BY customer_id
ORDER BY avg_txn_amount DESC;

-- 13. Month-over-Month Spend Change
SELECT 
    DATE_FORMAT(txn_date, '%Y-%m') AS txn_month,
    SUM(amount) AS total_spend,
    LAG(SUM(amount)) OVER (ORDER BY DATE_FORMAT(txn_date, '%Y-%m')) AS prev_month_spend,
    ROUND(SUM(amount) - LAG(SUM(amount)) OVER (ORDER BY DATE_FORMAT(txn_date, '%Y-%m')), 2) AS diff
FROM transactions
WHERE status = 'Success'
GROUP BY txn_month;

-- 14 Top Cities by Total Spend
SELECT txn_city, SUM(amount) AS total_spent
FROM transactions
WHERE status = 'Success'
GROUP BY txn_city
ORDER BY total_spent DESC
LIMIT 10;


-- 15. Category Contribution to Total Revenue
SELECT 
    category,
    ROUND(SUM(amount), 2) AS total_spend,
    ROUND(SUM(amount) / (SELECT SUM(amount) FROM transactions WHERE status = 'Success') * 100, 2) AS percent_of_total
FROM transactions
WHERE status = 'Success'
GROUP BY category
ORDER BY percent_of_total DESC;