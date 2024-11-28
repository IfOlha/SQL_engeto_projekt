-- Rostou v průběhu let mzdy ve všech odvětvích, nebo v některých klesají?

SELECT *
FROM (
    SELECT 
        branch_name,
        year,
        average_payroll_value,
        LAG(average_payroll_value) OVER (PARTITION BY branch_name ORDER BY year) AS previous_year_value,
        CASE 
            WHEN LAG(average_payroll_value) OVER (PARTITION BY branch_name ORDER BY year) IS NULL THEN 'N/A'
            WHEN average_payroll_value > LAG(average_payroll_value) OVER (PARTITION BY branch_name ORDER BY year) THEN 'Rise'
            WHEN average_payroll_value < LAG(average_payroll_value) OVER (PARTITION BY branch_name ORDER BY year) THEN 'Fall'
            ELSE 'No change'
        END AS trend
    FROM t_olha_berezovska_project_sql_primary_final
) subquery
WHERE trend = 'Fall'
ORDER BY  `year`;



