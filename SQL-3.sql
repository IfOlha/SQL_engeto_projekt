/*Která kategorie potravin zdražuje nejpomaleji (je u ní nejnižší percentuální meziroční nárůst)?*/

WITH yearly_price_change AS (
    SELECT 
        category_name,
        year,
        AVG(average_price_value) AS average_price_value, -- Аггрегируем цену по годам для каждого продукта
        LAG(AVG(average_price_value)) OVER (PARTITION BY category_name ORDER BY year) AS previous_year_price,
        CASE 
            WHEN LAG(AVG(average_price_value)) OVER (PARTITION BY category_name ORDER BY year) IS NULL THEN NULL
            ELSE ROUND(
                ((AVG(average_price_value) - LAG(AVG(average_price_value)) OVER (PARTITION BY category_name ORDER BY year)) 
                / LAG(AVG(average_price_value)) OVER (PARTITION BY category_name ORDER BY year)) * 100, 2)
        END AS price_change_percent
    FROM t_olha_berezovska_project_sql_primary_final
    WHERE category_name IS NOT NULL
    GROUP BY category_name, year
)
SELECT 
    category_name,
    year,
    price_change_percent
FROM yearly_price_change
WHERE price_change_percent IS NOT NULL
ORDER BY category_name, year;



WITH yearly_price_change AS (
    SELECT 
        category_name,
        year,
        AVG(average_price_value) AS average_price_value,
        LAG(AVG(average_price_value)) OVER (PARTITION BY category_name ORDER BY year) AS previous_year_price,
        CASE 
            WHEN LAG(AVG(average_price_value)) OVER (PARTITION BY category_name ORDER BY year) IS NULL THEN NULL
            ELSE ROUND(
                ((AVG(average_price_value) - LAG(AVG(average_price_value)) OVER (PARTITION BY category_name ORDER BY year)) 
                / LAG(AVG(average_price_value)) OVER (PARTITION BY category_name ORDER BY year)) * 100, 2)
        END AS price_change_percent
    FROM t_olha_berezovska_project_sql_primary_final
    WHERE category_name IS NOT NULL
    GROUP BY category_name, year
)
SELECT 
    category_name,
    ROUND(AVG(price_change_percent), 2) AS avg_price_growth_percent
FROM yearly_price_change
WHERE price_change_percent IS NOT NULL
GROUP BY category_name
ORDER BY avg_price_growth_percent ASC
LIMIT 3;






