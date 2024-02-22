-- Market Basket Analysis
-- Support = (frequancy of products A$B/total no of transaction) * 100
-- Confidence = (frequancy of both products/frequancy of the product on the LHS)*100
-- Lift = Support (Both products)/(Support(product A) * Support(Product B))

WITH Market as (
SELECT T1.Product_name as product1, T2.Product_name as product2,
COUNT(1) AS frequancy,
(SELECT COUNT(transaction_id) FROM Transaction_Data) as total_transaction,
(SELECT COUNT(transaction_id) FROM Transaction_Data e WHERE T1.product_name = e.Product_name) as frequancy_lhs,
(SELECT COUNT(transaction_id) FROM Transaction_Data e WHERE T2.product_name = e.Product_name) as frequancy_rhs
FROM Transaction_data as T1
JOIN Transaction_data as T2
ON T1.Transaction_id = T2.Transaction_id
WHERE T1.Product_name > T2.Product_name
GROUP BY T1.Product_name, T2.Product_name
)
SELECT TOP (5) product1 
  product1, 
  product2, 
  FORMAT (frequancy*100.00/total_transaction,'0.00') as support, 
  FORMAT(frequancy*100.00/frequancy_lhs,'0.00') as confidence,
  FORMAT(frequancy*100.00/total_transaction/
  (frequancy_lhs*100.00/total_transaction) * (frequancy_rhs*100.00/total_transaction),'0.00') as Lift
FROM Market 
ORDER BY frequancy DESC 