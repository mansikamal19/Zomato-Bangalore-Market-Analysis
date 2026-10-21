create database zomato_market_analysis;
use zomato_market_analysis;


1.How many total restaurants records are present?
select count(*)
from `zomato_final_sql       zomato_restaurants`;

2.what is the average restaurants rating?
SELECT ROUND(AVG(CAST(NULLIF(cleaned_ratings, '') AS DECIMAL(4,2))), 2)
AS average_rating
FROM `zomato_final_sql       zomato_restaurants`;

3.What is the average cost for two people across restaurants in Bangalore?
SELECT ROUND(AVG(CAST(NULLIF(cleaned_cost, '') AS DECIMAL(10,2))), 2)
as averagae_cost_for_two
FROM `zomato_final_sql       zomato_restaurants;

4.Which are the top 10 locations in Bangalore with the highest number of restaurant records?
SELECT cleaned_location, COUNT(cleaned_location) as highest_no_of_restaurants_records
FROM `zomato_final_sql       zomato_restaurants`
group by cleaned_location
order by highest_no_of_restaurants_records desc
limit 10;

5.Which are the top 5 most common restaurant types in Bangalore?
select cleaned_rest_type,count(cleaned_rest_type) as common_restaurants_type
from `zomato_final_sql       zomato_restaurants`
group by cleaned_rest_type
order by common_restaurants_type desc
limit 5;

6.Which locations in Bangalore have the highest average restaurant ratings?
select cleaned_location,COUNT(NULLIF(cleaned_ratings, '')) as rated_restuarants,ROUND(AVG(CAST(NULLIF (cleaned_ratings,'') AS DECIMAL(4,2))), 2) as highest_avg_restaurant_rating
from `zomato_final_sql       zomato_restaurants`
group by cleaned_location
having COUNT(NULLIF(cleaned_ratings, ''))>=20
order by highest_avg_restaurant_rating desc
limit 10;

7.What percentage of restaurants in Bangalore offer online ordering?
SELECT
    ROUND(
        SUM(CASE WHEN online_order = 'Yes' THEN 1 ELSE 0 END)
        * 100.0 / COUNT(*),
        2
    ) AS online_order_percentage
FROM `zomato_final_sql       zomato_restaurants`;

8.What percentage of restaurants in Bangalore offer table booking facilities?
SELECT
    ROUND(
        SUM(CASE WHEN book_table = 'Yes' THEN 1 ELSE 0 END)
        * 100.0 / COUNT(*),
        2

) as table_booking_percentage
FROM `zomato_final_sql       zomato_restaurants`;


9.Do restaurants offering table booking have higher average ratings than restaurants without table booking?
SELECT online_order,
       ROUND(AVG(CAST(NULLIF(cleaned_ratings, '') AS DECIMAL(4,2))), 2)
       AS higher_avg_rating
FROM `zomato_final_sql       zomato_restaurants`
GROUP BY online_order
ORDER BY higher_avg_rating DESC;

Q10.Do restaurants offering table booking have higher average ratings than restaurants without table booking?
 Compare average ratings by table booking availability

SELECT
    book_table,
    ROUND(
        AVG(CAST(NULLIF(cleaned_ratings, '') AS DECIMAL(4,2))),
        2
    ) AS average_rating
FROM `zomato_final_sql       zomato_restaurants`
GROUP BY book_table
ORDER BY average_rating DESC;


Q11. Which restaurant types have the highest average cost for two people
SELECT
    cleaned_rest_type,
    ROUND(AVG(CAST(NULLIF(cleaned_cost, '') AS DECIMAL(10,2))), 2)
        AS average_cost_for_two
FROM `zomato_final_sql       zomato_restaurants`
GROUP BY cleaned_rest_type
ORDER BY average_cost_for_two DESC
LIMIT 10;

Q12. Top 10 locations with the highest average dining cost
-- Include only locations with at least 20 valid cost records
SELECT
    cleaned_location,
    COUNT(NULLIF(cleaned_cost, '')) AS restaurant_count,
    ROUND(AVG(CAST(NULLIF(cleaned_cost, '') AS DECIMAL(10,2))), 2)
        AS average_cost_for_two
FROM `zomato_final_sql       zomato_restaurants`
GROUP BY cleaned_location
HAVING COUNT(NULLIF(cleaned_cost, '')) >= 20
ORDER BY average_cost_for_two DESC
LIMIT 10;

 Q13. Top 10 restaurants by number of votes

SELECT
    cleaned_name,
    cleaned_location,
    CAST(NULLIF(votes, '') AS UNSIGNED) AS total_votes
FROM `zomato_final_sql       zomato_restaurants`
ORDER BY total_votes DESC
LIMIT 10;

 Q14. How do restaurant ratings vary across different price ranges?

SELECT
    CASE
        WHEN CAST(NULLIF(cleaned_cost, '') AS DECIMAL(10,2)) < 500
            THEN 'Budget (Below 500)'
        WHEN CAST(NULLIF(cleaned_cost, '') AS DECIMAL(10,2)) BETWEEN 500 AND 1000
            THEN 'Mid-range (500-1000)'
        WHEN CAST(NULLIF(cleaned_cost, '') AS DECIMAL(10,2)) > 1000
            THEN 'Premium (Above 1000)'
        ELSE 'Unknown'
    END AS price_category,
    COUNT(*) AS restaurant_count,
    ROUND(AVG(CAST(NULLIF(cleaned_ratings, '') AS DECIMAL(4,2))), 2)
        AS average_rating
FROM `zomato_final_sql       zomato_restaurants`
GROUP BY price_category
ORDER BY average_rating DESC;

Q15. Which locations offer the best combination of high ratings and affordable dining?
 Consider locations with at least 20 valid rated and priced records

WITH location_analysis AS (
    SELECT
        cleaned_location,
        COUNT(*) AS restaurant_count,
        ROUND(AVG(CAST(NULLIF(cleaned_ratings, '') AS DECIMAL(4,2))), 2)
            AS average_rating,
        ROUND(AVG(CAST(NULLIF(cleaned_cost, '') AS DECIMAL(10,2))), 2)
            AS average_cost
    FROM `zomato_final_sql       zomato_restaurants`
    WHERE NULLIF(cleaned_ratings, '') IS NOT NULL
      AND NULLIF(cleaned_cost, '') IS NOT NULL
    GROUP BY cleaned_location
    HAVING COUNT(*) >= 20
)
SELECT
    cleaned_location,
    restaurant_count,
    average_rating,
    average_cost,
    DENSE_RANK() OVER (
        ORDER BY average_rating DESC, average_cost ASC
    ) AS location_rank
FROM location_analysis
WHERE average_cost <= 800
ORDER BY location_rank
LIMIT 10;