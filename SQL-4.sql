/*Existuje rok, ve kterém byl meziroční nárůst cen potravin výrazně vyšší než růst mezd (větší než 10 %)?*/


SELECT 
    tobpspf.`year`, 
    ROUND(AVG(tobpspf.average_price_value), 2) AS avg_price, 
    LAG(ROUND(AVG(tobpspf.average_price_value), 2)) OVER (ORDER BY tobpspf.`year`) AS previous_year_price,
    CASE 
        WHEN LAG(ROUND(AVG(tobpspf.average_price_value), 2)) OVER (ORDER BY tobpspf.`year`) IS NULL THEN NULL 
        ELSE ROUND(
            ((ROUND(AVG(tobpspf.average_price_value), 2) - LAG(ROUND(AVG(tobpspf.average_price_value), 2)) OVER (ORDER BY tobpspf.`year`)) 
            / LAG(ROUND(AVG(tobpspf.average_price_value), 2)) OVER (ORDER BY tobpspf.`year`)) * 100, 2) 
    END AS per_price 
FROM 
    t_olha_berezovska_project_sql_primary_final tobpspf
GROUP BY 
    tobpspf.`year`
ORDER BY 
    tobpspf.`year`;

SELECT 
    tobpspf.`year`, 
    ROUND(AVG(tobpspf.average_payroll_value), 2) AS avg_payroll, 
    LAG(ROUND(AVG(tobpspf.average_payroll_value), 2)) OVER (ORDER BY tobpspf.`year`) AS previous_year_payroll, 
    CASE 
        WHEN LAG(ROUND(AVG(tobpspf.average_payroll_value), 2)) OVER (ORDER BY tobpspf.`year`) IS NULL THEN NULL 
        ELSE ROUND(
            ((ROUND(AVG(tobpspf.average_payroll_value), 2) - LAG(ROUND(AVG(tobpspf.average_payroll_value), 2)) OVER (ORDER BY tobpspf.`year`)) 
            / LAG(ROUND(AVG(tobpspf.average_payroll_value), 2)) OVER (ORDER BY tobpspf.`year`)) * 100, 2) 
    END AS per_payroll
FROM 
    t_olha_berezovska_project_sql_primary_final tobpspf
GROUP BY 
    tobpspf.`year`
ORDER BY 
    tobpspf.`year`;


WITH price_data AS (
    SELECT 
        tobpspf.`year`, 
        ROUND(AVG(tobpspf.average_price_value), 2) AS avg_price,
        LAG(ROUND(AVG(tobpspf.average_price_value), 2)) OVER (ORDER BY tobpspf.`year`) AS previous_year_price, 
        CASE 
            WHEN LAG(ROUND(AVG(tobpspf.average_price_value), 2)) OVER (ORDER BY tobpspf.`year`) IS NULL THEN NULL 
            ELSE ROUND(
                ((ROUND(AVG(tobpspf.average_price_value), 2) - LAG(ROUND(AVG(tobpspf.average_price_value), 2)) OVER (ORDER BY tobpspf.`year`)) 
                / LAG(ROUND(AVG(tobpspf.average_price_value), 2)) OVER (ORDER BY tobpspf.`year`)) * 100, 2) 
        END AS per_price
    FROM 
        t_olha_berezovska_project_sql_primary_final tobpspf
    GROUP BY 
        tobpspf.`year`
),
payroll_data AS (
    SELECT 
        tobpspf.`year`, 
        ROUND(AVG(tobpspf.average_payroll_value), 2) AS avg_payroll,
        LAG(ROUND(AVG(tobpspf.average_payroll_value), 2)) OVER (ORDER BY tobpspf.`year`) AS previous_year_payroll,
        CASE 
            WHEN LAG(ROUND(AVG(tobpspf.average_payroll_value), 2)) OVER (ORDER BY tobpspf.`year`) IS NULL THEN NULL 
            ELSE ROUND(
                ((ROUND(AVG(tobpspf.average_payroll_value), 2) - LAG(ROUND(AVG(tobpspf.average_payroll_value), 2)) OVER (ORDER BY tobpspf.`year`)) 
                / LAG(ROUND(AVG(tobpspf.average_payroll_value), 2)) OVER (ORDER BY tobpspf.`year`)) * 100, 2) 
        END AS per_payroll
    FROM 
        t_olha_berezovska_project_sql_primary_final tobpspf
    GROUP BY 
        tobpspf.`year`
)
SELECT 
    p.`year`, 
    p.avg_price, 
    p.per_price, 
    pd.avg_payroll, 
    pd.per_payroll
FROM 
    price_data p
JOIN 
    payroll_data pd
ON 
    p.`year` = pd.`year`
ORDER BY 
    p.`year`;



