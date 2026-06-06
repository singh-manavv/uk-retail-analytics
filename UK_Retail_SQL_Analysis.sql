-- All Tables

SELECT * FROM transactions

SELECT * FROM customers

SELECT * FROM products

SELECT * FROM stores

SELECT * FROM rfm_segments


-- Total revenue, number of orders, and average order value by customer segment

SELECT
    rfm.segment,
    ROUND(SUM(trans.total_revenue), 2)                               AS TotalRevenue,
    COUNT(trans.transaction_id)                                      AS NumOfOrders,
    ROUND(SUM(trans.total_revenue) / COUNT(trans.transaction_id), 2) AS AvgOrderValue
FROM transactions trans
JOIN rfm_segments rfm
    ON trans.customer_id = rfm.customer_id
GROUP BY rfm.segment
ORDER BY TotalRevenue DESC;


-- Average RFM score by loyalty tier, ordered Platinum to Bronze

SELECT
    loyalty_tier,
    ROUND(AVG(rfm_avg), 2) AS AverageRFM
FROM rfm_segments
GROUP BY loyalty_tier
ORDER BY
    CASE loyalty_tier
        WHEN 'Platinum' THEN 1
        WHEN 'Gold'     THEN 2
        WHEN 'Silver'   THEN 3
        WHEN 'Bronze'   THEN 4
    END;


-- Top 10 customers by total spend, including segment and loyalty tier

SELECT TOP 10
    trans.customer_id                           AS CustomerID,
    ROUND(SUM(trans.total_revenue), 2)          AS TotalRevenue,
    COUNT(trans.transaction_id)                 AS NumOfOrders,
    rfm.segment                                 AS Segment,
    rfm.loyalty_tier                            AS LoyaltyTier
FROM transactions trans
JOIN rfm_segments rfm
    ON trans.customer_id = rfm.customer_id
GROUP BY trans.customer_id, rfm.segment, rfm.loyalty_tier
ORDER BY TotalRevenue DESC;


-- Total revenue and customer count by loyalty tier
-- filtered to Champion and Loyal segments only

SELECT
    rfm.loyalty_tier                            AS LoyaltyTier,
    rfm.segment                                 AS Segment,
    COUNT(trans.customer_id)                    AS NumOfCustomers,
    ROUND(SUM(trans.total_revenue), 2)          AS TotalRevenue
FROM transactions trans
JOIN rfm_segments rfm
    ON trans.customer_id = rfm.customer_id
WHERE rfm.segment IN ('Champion', 'Loyal')
GROUP BY rfm.loyalty_tier, rfm.segment
ORDER BY rfm.segment, rfm.loyalty_tier;


-- Total revenue by product category, completed orders only

SELECT
    prod.category                               AS ProductCategory,
    ROUND(SUM(trans.total_revenue), 2)          AS TotalRevenue
FROM transactions trans
JOIN products prod
    ON trans.product_id = prod.product_id
WHERE trans.order_status = 'Completed'
GROUP BY prod.category
ORDER BY TotalRevenue DESC;


-- Monthly revenue trend across the full dataset period, completed orders only

SELECT
    YEAR(transaction_date)                      AS Year,
    MONTH(transaction_date)                     AS Month,
    ROUND(SUM(total_revenue), 2)                AS TotalRevenue
FROM transactions
WHERE order_status = 'Completed'
GROUP BY YEAR(transaction_date), MONTH(transaction_date)
ORDER BY Year, Month;


-- At Risk and Lost customers with historical spend above £500

SELECT
    customer_id                                 AS CustomerID,
    segment                                     AS Segment,
    ROUND(monetary, 2)                          AS TotalSpend,
    loyalty_tier                                AS LoyaltyTier
FROM rfm_segments
WHERE segment IN ('At Risk', 'Lost')
  AND monetary > 500
ORDER BY monetary DESC;


-- Total revenue by region, completed orders only

SELECT
    st.region                                   AS Region,
    ROUND(SUM(trans.total_revenue), 2)          AS TotalRevenue
FROM transactions trans
JOIN stores st
    ON trans.store_id = st.store_id
WHERE trans.order_status = 'Completed'
GROUP BY st.region
ORDER BY TotalRevenue DESC;



-- Top 10 customers by total spend within each segment, ranked independently

WITH RankedCustomers AS (
    SELECT
        customer_id,
        segment,
        ROUND(monetary, 2)                          AS TotalSpend,
        RANK() OVER (
            PARTITION BY segment
            ORDER BY monetary DESC
        )                                           AS SpendRank
    FROM rfm_segments
)
SELECT *
FROM RankedCustomers
WHERE SpendRank <= 10
ORDER BY segment, SpendRank;


-- Monthly revenue for 2023 with cumulative running total, completed orders only

WITH MonthlyRevenue AS (
    SELECT
        MONTH(transaction_date)                     AS Month,
        ROUND(SUM(total_revenue), 2)                AS MonthlyRevenue
    FROM transactions
    WHERE YEAR(transaction_date) = 2023
      AND order_status = 'Completed'
    GROUP BY MONTH(transaction_date)
)
SELECT
    Month,
    MonthlyRevenue,
    ROUND(SUM(MonthlyRevenue) OVER (ORDER BY Month), 2) AS RunningTotal
FROM MonthlyRevenue
ORDER BY Month;


-- Number of customers and total revenue by spend band
-- High Value (>£1,000) | Mid Value (£500–£1,000) | Low Value (<£500)

WITH SpendBands AS (
    SELECT
        customer_id,
        monetary,
        CASE
            WHEN monetary > 1000  THEN 'High Value'
            WHEN monetary >= 500  THEN 'Mid Value'
            ELSE                       'Low Value'
        END AS SpendBand
    FROM rfm_segments
)
SELECT
    SpendBand,
    COUNT(customer_id)              AS NumOfCustomers,
    ROUND(SUM(monetary), 2)         AS TotalRevenue
FROM SpendBands
GROUP BY SpendBand
ORDER BY TotalRevenue DESC;


-- Customers whose total spend exceeds the average spend of their segment

SELECT
    r.customer_id                               AS CustomerID,
    r.segment                                   AS Segment,
    ROUND(r.monetary, 2)                        AS TotalSpend,
    ROUND(avg_table.AvgSegmentSpend, 2)         AS SegmentAvg
FROM rfm_segments r
JOIN (
    SELECT
        segment,
        AVG(monetary) AS AvgSegmentSpend
    FROM rfm_segments
    GROUP BY segment
) avg_table
    ON r.segment = avg_table.segment
WHERE r.monetary > avg_table.AvgSegmentSpend
ORDER BY r.segment, r.monetary DESC;
