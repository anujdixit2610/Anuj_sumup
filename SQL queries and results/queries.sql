# SQL Queries

--  Top 10 stores per transacted amount

SELECT 

store_name,
sum(amount) total_amount

FROM `supple-hangout-394013.dbt_adixit.fact_transaction`  

where status = 'accepted' -- considering only accepted transactions
group by store_name
order by 2 desc           -- decreased order by total amount
limit 10;


--  	Top 10 products sold

SELECT 

product_name,
count(transaction_id) total_products_sold

FROM `supple-hangout-394013.dbt_adixit.fact_transaction`  

where status = 'accepted' -- considering only accepted transactions
group by product_name
order by total_products_sold desc -- decreased order by total amount
limit 10;


--  Average transacted amount per store typology and country

SELECT 

store_typology,
store_country,
round(avg(amount),2) avg_per_typology_country

FROM `supple-hangout-394013.dbt_adixit.fact_transaction`  

where status = 'accepted'  -- considering only accepted transactions
group by 1,2
order by 1,2;


--  Percentage of transactions per device type
-- (transaction by one type of devide divided by total transactions ) * 100
SELECT

  t.device_type,
  COUNT(*) AS total_transactions,
  round(
    (COUNT(*) * 100.0) / SUM(COUNT(*)) OVER()
     ,2) AS percentage_of_total          
FROM `supple-hangout-394013.dbt_adixit.fact_transaction` t

GROUP BY device_type
ORDER BY device_type
;


--  	Average time for a store to perform its 5 first transactions (from store created at day)
WITH ranked_transactions AS (
  SELECT
    t.store_id,
    t.transaction_happened_at,
    ROW_NUMBER() OVER (PARTITION BY t.store_id ORDER BY t.transaction_happened_at) AS transaction_rank -- window function to assign a row number to each transaction within each store, ordered by the transaction time
  FROM `supple-hangout-394013.dbt_adixit.fact_transaction` t
)

-- considering the time when the store was created
-- keeping the granularity to daily for the business context
-- since store_created date calculating the number of days a store took to make 5 transactions and dividing it by 5 to get average number of days it took for a store to make its first 5 transactions
SELECT
  r.store_id,
  (TIMESTAMP_DIFF( d.store_created_at,
                      r.transaction_happened_at, DAY)+1)/transaction_rank AS avg_time_for_5_transactions
FROM ranked_transactions r
join `supple-hangout-394013.dbt_adixit.dim_store` d
on r.store_id = d.store_id
WHERE transaction_rank = 5
;

