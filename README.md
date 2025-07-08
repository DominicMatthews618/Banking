# Banking

# 💳 Banking Transactions Analysis (SQL Project)

This project analyzes customer banking transactions to uncover behavioral patterns, business insights, and potential fraud indicators using **structured SQL queries**. The dataset includes synthetic transaction-level data linked to customer profiles, designed to mimic real-world banking environments.

---

## 📁 Dataset Overview

**1. `customers.csv`**
- `customer_id`
- `name`
- `city`
- `zip_code`
- `join_date`

**2. `transactions.csv`**
- `txn_id`
- `customer_id`
- `txn_date`
- `amount`
- `merchant_name`
- `category`
- `status` (Success / Failed)
- `method` (Credit / Debit)
- `txn_city`

---

## 📊 Key Analyses

### 🔹 Exploratory Analysis
- View all records from `customers` and `transactions`
- Monthly transaction volume and total spend
- Average spend by category
- Top merchants and payment method breakdown
- Daily/weekly transaction patterns

### 🔹 Customer Behavior
- Total and average monthly spend per customer
- Transaction frequency and lifetime value (LTV) approximation
- Top 10 most valuable customers
- City-based spending comparisons

### 🔹 Fraud Detection
- Transactions over $1,000 or $3,000
- Customers spending over $5,000 in a single day
- Customers transacting in 2+ cities on the same day
- Back-to-back transactions within 1 minute
- Failed transaction rates by customer

---

## 📈 Sample SQL Snippets

**Total Monthly Spend per Customer**
```sql
SELECT
  customer_id,
  DATE_FORMAT(txn_date, '%Y-%m') AS txn_month,
  SUM(amount) AS total_monthly_spend
FROM transactions
WHERE status = 'Success'
GROUP BY customer_id, txn_month
ORDER BY customer_id, txn_month;
High-Value Daily Transactions ($5,000+)

sql
Copy
Edit
SELECT 
  customer_id,
  txn_date,
  SUM(amount) AS total_daily_spend
FROM transactions
GROUP BY customer_id, txn_date
HAVING SUM(amount) >= 5000;
🎯 Tools & Technologies
SQL (MySQL) for data querying and logic

Excel / CSV for initial data manipulation

(Optional) Tableau for dashboard visualizations

(Optional) Python (pandas) for ETL and dataset generation

📌 Project Goals
Practice real-world SQL querying and data transformation

Analyze transaction behaviors and financial patterns

Identify suspicious activity using fraud detection logic

Create a portfolio-ready project with clear documentation

📤 Next Steps (Optional Enhancements)
Visualize insights in Tableau or Power BI

Build stored procedures or views for reuse

Add Jupyter Notebook with query outputs + commentary

Export top queries as .sql files or create a reporting dashboard

📂 File Structure
cpp
Copy
Edit
banking/
├── customers.csv
├── transactions.csv
├── Banking Query.sql
├── README.md
└── visuals/ (optional)
👤 Author
Dominic Matthews
📍 Brandywine, MD
📫 LinkedIn
💼 Portfolio

