-- ================================================
-- Irish Housing Market Analysis — Business Queries
-- Author: Ramya
-- Database: irish_housing
-- ================================================

USE irish_housing;

-- ------------------------------------------------
-- Query 1: Most Unaffordable Counties 2021
-- Shows top 5 counties where housing is hardest
-- to afford based on years of salary needed
-- ------------------------------------------------
SELECT county, 
       avg_price, 
       affordability_ratio
FROM ppr_summary
WHERE year = 2021
ORDER BY affordability_ratio DESC
LIMIT 5;

-- ------------------------------------------------
-- Query 2: Total Market Value by County 2021
-- Shows which counties had highest total property
-- market activity by value and number of sales
-- ------------------------------------------------
SELECT county,
       ROUND(SUM(price), 0)  AS total_market_value,
       COUNT(*)               AS num_sales
FROM ppr_clean
WHERE year = 2021
GROUP BY county
ORDER BY total_market_value DESC
LIMIT 10;

-- ------------------------------------------------
-- Query 3: National Average Price by Year
-- Shows Ireland-wide price trend and affordability
-- getting worse year on year
-- ------------------------------------------------
SELECT year,
       ROUND(AVG(avg_price), 0)           AS national_avg_price,
       ROUND(AVG(affordability_ratio), 2)  AS national_affordability
FROM ppr_summary
GROUP BY year
ORDER BY year;

-- ------------------------------------------------
-- Query 4: Fastest Growing Counties 2021
-- Shows which counties had biggest price jump
-- in 2021 — Longford surprising leader at 28%+
-- ------------------------------------------------
SELECT county, 
       price_growth_pct
FROM ppr_summary
WHERE year = 2021
ORDER BY price_growth_pct DESC
LIMIT 5;

-- ------------------------------------------------
-- Query 5: Dublin Premium vs National Average
-- Shows exactly how much more expensive Dublin
-- is vs national average every year 2010-2021
-- Uses subquery and JOIN — advanced SQL
-- ------------------------------------------------
SELECT s.year,
       s.avg_price                             AS dublin_avg,
       n.national_avg,
       ROUND(s.avg_price - n.national_avg, 0)  AS dublin_premium
FROM ppr_summary s
JOIN (
    SELECT year,
           ROUND(AVG(avg_price), 0) AS national_avg
    FROM ppr_summary
    GROUP BY year
) n ON s.year = n.year
WHERE s.county = 'Dublin'
ORDER BY s.year;
