Drop table  if exists cc_details;
create table cc_details (

Client_Num INT,
Card_Category VARCHAR(20),
Annual_Fees  INT,
Activation_30_Days  INT,
Customer_Acq_Cost  INT,
Week_Start_Date	 DATE,
Week_Num VARCHAR(20),
Qtr	VARCHAR(20),
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


Select * From cc_details

Copy cc_details
From 'C:\CV\credit_card.csv'
DELIMITER ','
CSV HEADER


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

































