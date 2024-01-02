
--retrieve all details--
select * from Bank_loan;

--count the total number of loans in the dataset--
select count(*) as total_loans from Bank_loan;


--display distinct loan statuses--
select distinct loan_status from Bank_loan;


--find the average loan amount--
select avg(loan_amount) as avg_loan_amount from Bank_loan;


--calculate the average annual income for each term--
select term, avg(annual_income) as avg_annual_income 
from Bank_loan
group by term;


--Find the loan with the highest installment amount and display its details--
SELECT *
FROM Bank_loan
WHERE installment = (SELECT MAX(installment) FROM Bank_loan);


--total amount received from borrowers from august--
select sum(total_payment) as total_amount_received from Bank_loan
where month(issue_date)= 8 and year(issue_date)= 2021;


--retrieve loans with an amount greater than 10000--
select * from Bank_loan
where loan_amount >= 10000;


--calculate the total loan amount for each loan status--
select loan_status , sum(loan_amount) as Total_loan_amount from Bank_loan
group by loan_status;


--list the top 5 loan purposes with the highest average annual income--
SELECT top 5 purpose, AVG(annual_income) AS avg_income
FROM Bank_loan
GROUP BY purpose
ORDER BY avg_income DESC;


--retrieve loans with a loan amount greater than the average loan amount--
select * from Bank_loan
where loan_amount>
      (select avg(loan_amount) from Bank_loan);


--Calculate the avg loan amount for each grade and sub grade--
select grade , sub_grade , avg(loan_amount) as avg_amount 
from Bank_loan
group by grade,sub_grade;


--Calculate the total payment-to-loan amount ratio for each loan and address state--
SELECT address_state,
  total_payment / loan_amount AS payment_to_loan_ratio
FROM Bank_loan;


--calculate average interest rate acc to PMTD variation--
select round(avg(int_rate),4)*100 as PMTD_avg_interest_rate
from Bank_loan
where month(issue_date) = 6 and year(issue_date) = 2021;


--evaluating average debt to income ratio acc to PMTD variation--
select round(avg(dti),4)*100 as PMTD_avg_dti_rate
from Bank_loan
where month(issue_date) = 12 and year(issue_date) = 2021;


--calculate good loan percentage acc to loan_status-- 
select
   count(case when loan_status = 'fully paid' or loan_status = 'current' then id end)*100
   /
   count(id) as good_loan_percentage
   from Bank_loan;


--what are the total loan application , total loan amount and total amount received acc to each month--
select month(issue_date) as month_number,
       datename(month,issue_date) as month_name,
       count(id) as total_loan_application,
	   sum(loan_amount) as total_loan_amount,
	   sum(total_payment) as total_amount_received
from Bank_loan
group by month(issue_date), datename(month,issue_date)
order by month(issue_date);


--acc to home ownership for specific grade and address state--
select 
      home_ownership,
      count(id) as total_loan_application,
	   sum(loan_amount) as total_loan_amount,
	   sum(total_payment) as total_amount_received
from Bank_loan
where grade = 'A' and address_state = 'CA'
group by home_ownership
order by count(id) desc;
 
 
 --Calculate the percentage change in annual income from the previous month for each state--
WITH IncomeCTE AS (
  SELECT
    address_state,
    DATEPART(MONTH, issue_date) AS month,
    AVG(annual_income) AS avg_income
  FROM Bank_loan
  GROUP BY address_state, DATEPART(MONTH, issue_date)
)

SELECT
  cte.address_state,
  cte.month,
  ROUND((cte.avg_income - LAG(cte.avg_income, 1, 0) OVER (PARTITION BY cte.address_state ORDER BY cte.month)) / NULLIF(LAG(cte.avg_income, 1, 1) OVER (PARTITION BY cte.address_state ORDER BY cte.month), 0) * 100, 2) AS percentage_change
FROM IncomeCTE cte;








