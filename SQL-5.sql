/*Má výška HDP vliv na změny ve mzdách a cenách potravin? Neboli, pokud HDP vzroste výrazněji v jednom roce, 
projeví se to na cenách potravin či mzdách ve stejném nebo násdujícím roce výraznějším růstem?*/


 SELECT 
        year,
        GDP,
        LAG(GDP) OVER (PARTITION BY country ORDER BY year) AS previous_year_GDP,
        CASE 
            WHEN LAG(GDP) OVER (PARTITION BY country ORDER BY year) IS NULL THEN NULL
            ELSE ROUND(((GDP - LAG(GDP) OVER (PARTITION BY country ORDER BY year)) / LAG(GDP) OVER (PARTITION BY country ORDER BY year)) * 100, 2)
        END AS GDP_growth_percent
    FROM t_olha_berezovska_project_sql_secondary_final
    WHERE country = 'Czech Republic';
   
   
SELECT 
        year,
        ROUND(AVG(average_price_value), 2) AS avg_price, 
        ROUND(AVG(average_payroll_value), 2) AS avg_payroll 
    FROM t_olha_berezovska_project_sql_primary_final
    GROUP BY YEAR;
   



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
        ROUND(AVG(average_price_value), 2) AS avg_price, 
        ROUND(AVG(average_payroll_value), 2) AS avg_payroll 
    FROM t_olha_berezovska_project_sql_primary_final
    GROUP BY year
),
price_and_wage_growth AS (
    SELECT 
        year,
        avg_price,
        avg_payroll,
        LAG(avg_price) OVER (ORDER BY year) AS previous_year_price, 
        LAG(avg_payroll) OVER (ORDER BY year) AS previous_year_payroll, 
        CASE 
            WHEN LAG(avg_price) OVER (ORDER BY year) IS NULL THEN NULL 
            ELSE ROUND(((avg_price - LAG(avg_price) OVER (ORDER BY year)) / LAG(avg_price) OVER (ORDER BY year)) * 100, 2) 
        END AS price_growth_percent,
        CASE 
            WHEN LAG(avg_payroll) OVER (ORDER BY year) IS NULL THEN NULL
            ELSE ROUND(((avg_payroll - LAG(avg_payroll) OVER (ORDER BY year)) / LAG(avg_payroll) OVER (ORDER BY year)) * 100, 2) 
        END AS payroll_growth_percent
    FROM aggregated_data
)
SELECT 
    pg.year,
    pg.GDP_growth_percent,  
    pp.price_growth_percent,  
    pp.payroll_growth_percent 
FROM GDP_growth pg
JOIN price_and_wage_growth pp ON pg.year = pp.year
ORDER BY pg.year;





