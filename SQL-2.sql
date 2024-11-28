/*Kolik je možné si koupit litrů mléka a kilogramů chleba za první a poslední srovnatelné období v dostupných datech cen a mezd? */


WITH price_data AS (
    -- Získávání údajů o cenách mléka a chleba
    SELECT 
        year,
        category_name,
        average_price_value,
        CASE 
            WHEN category_name = 'Mléko polotučné pasterované' THEN 'L'
            WHEN category_name = 'Chléb konzumní kmínový' THEN 'KG'
            ELSE 'неизвестно'
        END AS units
    FROM t_olha_berezovska_project_sql_primary_final
    WHERE category_name IN ('Mléko polotučné pasterované', 'Chléb konzumní kmínový')
),
payroll_data AS (
    -- Pro všechna odvětví počítáme průměrnou mzdu za rok
    SELECT 
        year,
        ROUND(AVG(average_payroll_value), 2) AS average_salary
    FROM t_olha_berezovska_project_sql_primary_final
    GROUP BY year
),
min_max_years AS (
    -- Stanovení minimálních a maximálních let
    SELECT 
        MIN(year) AS first_year,
        MAX(year) AS last_year
    FROM t_olha_berezovska_project_sql_primary_final
),
comparison_data AS (
    -- Spojujeme údaje o platech, cenách a letech za první a poslední rok
    SELECT 
        pd.year,
        pd.average_salary,
        pr.category_name,
        pr.average_price_value,
        pr.units
    FROM payroll_data pd
    JOIN price_data pr 
        ON pd.year = pr.year
    WHERE pd.year IN (SELECT first_year FROM min_max_years UNION SELECT last_year FROM min_max_years)
)
SELECT 
    year,
    category_name,
    units,
    average_salary,
    average_price_value,
    ROUND(average_salary / average_price_value, 2) AS units_can_buy
FROM comparison_data
GROUP BY year, category_name, units, average_salary, average_price_value
ORDER BY year, category_name;



