# Credit_Card_Customer_Analytics

# 💳 Credit Card Customer Analytics — SQL Project

Analyze customer credit card spending, utilization, delinquency, and profitability using **SQL**.  
This project demonstrates data cleaning, aggregation, and advanced analytics techniques with business insights — perfect for your SQL portfolio.

---

📦 credit_card_customer_analytics
│
├── 📁 data
│ └── customer_transactions.csv
│
├── 📁 sql
│ ├── 01_create_table.sql
│ ├── 02_data_cleaning.sql
│ ├── 03_easy_queries.sql
│ ├── 04_medium_queries.sql
│ └── 05_hard_queries.sql
│
├── 📁 outputs
│ └── query_results.xlsx
│
├── README.md

## 📚 Table of Contents

## 📚 Table of Contents

1. [Project Overview](#-credit-card-customer-analytics-using-sql)
2. [Project Workflow](#-project-workflow)
   - [Step 1: Data Extraction](#-step-1-data-extraction)
   - [Step 2: Data Cleaning & Preparation](#-step-2-data-cleaning--preparation)
   - [Step 3: Data Analysis & Insights](#-step-3-data-analysis--insights)
3. [Key Findings](#-key-findings)
4. [Tools & Technologies](#-tools--technologies)
5. [How to Run](#-how-to-run)
6. [Author](#-author)


---

# 💳 Credit Card Customer Analytics using SQL

A complete SQL-based analytics project exploring **customer credit card behavior**, from **data extraction** to **data cleaning** to **business insights**.  
This project demonstrates real-world SQL skills using aggregations, window functions, and subqueries to uncover customer spending patterns, utilization efficiency, and profitability.

---

## 📘 Project Workflow

### 🥇 **Step 1: Data Extraction**
The dataset `credit_card.csv` is imported into SQL using the following command:

```sql
DROP TABLE IF EXISTS cc_details;

CREATE TABLE cc_details (
    Client_Num INT,
    Card_Category VARCHAR(20),
    Annual_Fees INT,
    Activation_30_Days INT,
    Customer_Acq_Cost INT,
    Week_Start_Date DATE,
    Week_Num VARCHAR(20),
    Qtr VARCHAR(20),
    current_year INT,
    Credit_Limit DECIMAL(10,2),
    Total_Revolving_Bal INT,
    Total_Trans_Amt INT,
    Total_Trans_Vol INT,
    Avg_Utilization_Ratio DECIMAL(10,3),
    Use_Chip VARCHAR(20),
    Exp_Type VARCHAR(50),
    Interest_Earned DECIMAL(10,3),
    Delinquent_Acc VARCHAR(5)
);

COPY cc_details
FROM 'C:\\CV\\credit_card.csv'
DELIMITER ','
CSV HEADER;

Step 2: Data Cleaning & Preparation

Before running analysis:

Checked for null values in important columns (e.g., Credit_Limit, Total_Trans_Amt).

Ensured correct data types for numeric columns like Credit_Limit and Interest_Earned.

Standardized categorical data such as Exp_Type and Delinquent_Acc.

Removed duplicates and invalid entries using simple WHERE filters.
Examples:
SELECT * FROM cc_details WHERE Credit_Limit IS NULL;
SELECT DISTINCT Exp_Type FROM cc_details;

Step 3: Data Analysis & Insights

Exploratory Queries

Customers with Credit Limit above average

SELECT * FROM cc_details
WHERE Credit_Limit > (SELECT AVG(Credit_Limit) FROM cc_details);


Top 10 customers by transaction amount per week

SELECT Client_Num, Total_Trans_Amt, EXTRACT(WEEK FROM Week_Start_Date) AS Week
FROM cc_details
ORDER BY Total_Trans_Amt DESC
LIMIT 10;

Average utilization ratio by expense type

SELECT Exp_Type, AVG(Avg_Utilization_Ratio)
FROM cc_details
GROUP BY Exp_Type;


## 💼 Business Questions & Objectives
This project explores customer spending, profitability, and risk patterns through the following business questions:

Business Questions
No.	Business Question	Purpose / Insight
Q1	Which customers have a credit limit higher than the company’s overall average?	To identify premium or high-value customers who may deserve special rewards or risk assessment.
Q2	Who are the top 10 customers by total transaction amount in a given week?	To recognize top spenders and optimize marketing or loyalty programs for them.
Q3	What is the total transaction amount generated in each quarter?	To analyze seasonal spending patterns and quarterly performance trends.
Q4	What is the average utilization ratio for each expense type?	To understand how different spending categories impact credit usage behavior.
Q5	How much total interest has been earned each year?	To measure annual revenue from customer credit usage.
Q6	What percentage of total transactions comes from each expense type?	To determine which expense categories drive the most spending and revenue.
Q7	Who are the top 5 most profitable customers in each quarter?	To find customers generating the highest net profit (interest earned minus acquisition cost).
Q8	Which customers are most efficient in using their credit (transaction amount per utilization ratio)?	To rank customers based on credit utilization efficiency and spending power.
Q9	Which customers have the highest utilization ratio compared to their credit limit?	To flag potential credit risk customers who are close to their credit limit.
Q10	Who are the top 10 non-delinquent customers with the highest profit margins?	To identify financially responsible and profitable customers for retention programs.
Q11	How does spending behavior differ between delinquent and non-delinquent customers across expense types?	To compare risk segments and design better credit management strategies.
Q12	What is the total revolving balance and total interest earned for each year?	To assess yearly growth in outstanding balances and interest income.
Q13	Which expense type contributes the highest revolving balance among delinquent customers?	To pinpoint risky expense categories driving high unpaid balances.


-- Q1.Find all customers whose Credit_Limit is above the average?
select * from cc_details
where Credit_Limit >(Select avg(Credit_Limit)
from cc_details);

-- Q2.List top 10 customers by Total_Trans_Amt in any given week.
select Client_Num, Total_Trans_Amt, extract (week from Week_Start_Date) as week
from cc_details
where week 
order by Total_Trans_Amt desc
limit 10;

-- Q3.Calculate total transaction amount per Qtr.
select Qtr, sum(Total_Trans_Amt) from cc_details
group by Qtr;

-- Q4.Find the average Avg_Utilization_Ratio by expense type (Exp Type)
select Exp_Type, avg(Avg_Utilization_Ratio
)
from cc_details
group by Exp_Type;

-- Q5.Get the total Interest_Earned by year.

select sum(Interest_Earned), current_year
from cc_details
group by current_year;


-- Q6.Find the contribution of each expense type to total transactions (percentage share)
SELECT 
    Exp_Type,
    SUM(Total_Trans_Amt) AS Total_Spent,
    SUM(Total_Trans_Amt) * 100.0 / (SELECT SUM(Total_Trans_Amt) FROM customer_transactions) AS Percentage_Contribution
FROM cc_details
GROUP BY Exp_Type
ORDER BY Percentage_Contribution DESC;


-- 07.Find the Top 5 most profitable customers per quarter.
select Interest_Earned, Customer_Acq_Cost, (Interest_Earned- Customer_Acq_Cost),Qtr
from cc_details
order by (Interest_Earned- Customer_Acq_Cost) , Qtr
limit 5;

-- Q8.Rank customers by credit utilization efficiency (transaction amount per utilization ratio)
SELECT 
    Customer_ID,
    (Total_Trans_Amt / NULLIF(Avg_Utilization_Ratio,0)) AS Utilization_Efficiency,
    RANK() OVER (ORDER BY (Total_Trans_Amt / NULLIF(Avg_Utilization_Ratio,0)) DESC) AS efficiency_rank
FROM cc_details
ORDER BY efficiency_rank
LIMIT 10;



-- Q9.Which customers have the highest utilization ratio relative to their Credit_Limit?
select Avg_Utilization_Ratio, Client_Num, Credit_Limit
from cc_details
order by Avg_Utilization_Ratio desc
limit 1

-- Q10.Identify top 10 customers with highest profit margins (Interest – Acquisition Cost) who are not delinquent
SELECT 
    Customer_ID,
    (Interest_Earned - Customer_Acq_Cost) AS Profit_Margin
FROM ccc_details
WHERE Delinquent_Acc = 'No'
ORDER BY Profit_Margin DESC
LIMIT 10;


-- Q11.Compare spending behavior between delinquent and non-delinquent customers across expense types
SELECT 
    Exp_Type,
    Delinquent_Acc,
    AVG(Total_Trans_Amt) AS Avg_Spending,
    AVG(Avg_Utilization_Ratio) AS Avg_Utilization
FROM cc_details
GROUP BY Exp_Type, Delinquent_Acc
ORDER BY Exp_Type, Delinquent_Acc;


-- Q12.Find the total revolving balance and total interest earned for each year

select Total_Revolving_Bal, sum(Interest_Earned) as total_interest_earned, current_year
from cc_details
group by current_year, Total_Revolving_Bal;


-- Q13.Find the expense type with the highest total revolving balance among delinquent customers

select Exp_Type, Total_Revolving_Bal, Delinquent_Acc, Client_Num
from cc_details
group by Exp_Type
order by Total_Revolving_Bal desc
where Delinquent_Acc ='Yes';




