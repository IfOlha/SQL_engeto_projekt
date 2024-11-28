/*Má výška HDP vliv na změny ve mzdách a cenách potravin? Neboli, pokud HDP vzroste výrazněji v jednom roce, 
projeví se to na cenách potravin či mzdách ve stejném nebo násdujícím roce výraznějším růstem?*/


WITH GDP_growth AS (
    SELECT 
        year,
        GDP,
        LAG(GDP) OVER (PARTITION BY country ORDER BY year) AS previous_year_GDP,
        CASE 
            WHEN LAG(GDP) OVER (PARTITION BY country ORDER BY year) IS NULL THEN NULL
            ELSE ROUND(((GDP - LAG(GDP) OVER (PARTITION BY country ORDER BY year)) / LAG(GDP) OVER (PARTITION BY country ORDER BY year)) * 100, 2)
        END AS GDP_growth_percent
    FROM t_olha_berezovska_project_sql_secondary_final
    WHERE country = 'Czech Republic'
),
aggregated_data AS (
    SELECT 
        year,
        ROUND(AVG(average_price_value), 2) AS avg_price, -- Average price for the year
        ROUND(AVG(average_payroll_value), 2) AS avg_payroll -- Average payroll for the year
    FROM t_olha_berezovska_project_sql_primary_final
    GROUP BY year
),
price_and_wage_growth AS (
    SELECT 
        year,
        avg_price,
        avg_payroll,
        LAG(avg_price) OVER (ORDER BY year) AS previous_year_price, -- Previous year's price
        LAG(avg_payroll) OVER (ORDER BY year) AS previous_year_payroll, -- Previous year's payroll
        CASE 
            WHEN LAG(avg_price) OVER (ORDER BY year) IS NULL THEN NULL -- No previous year, return NULL
            ELSE ROUND(((avg_price - LAG(avg_price) OVER (ORDER BY year)) / LAG(avg_price) OVER (ORDER BY year)) * 100, 2) -- Price growth
        END AS price_growth_percent,
        CASE 
            WHEN LAG(avg_payroll) OVER (ORDER BY year) IS NULL THEN NULL -- No previous year, return NULL
            ELSE ROUND(((avg_payroll - LAG(avg_payroll) OVER (ORDER BY year)) / LAG(avg_payroll) OVER (ORDER BY year)) * 100, 2) -- Payroll growth
        END AS payroll_growth_percent
    FROM aggregated_data
)
SELECT 
    pg.year,
    pg.GDP_growth_percent,  -- GDP growth percentage
    pp.price_growth_percent,  -- Price growth percentage
    pp.payroll_growth_percent  -- Payroll growth percentage
FROM GDP_growth pg
JOIN price_and_wage_growth pp ON pg.year = pp.year
ORDER BY pg.year;








