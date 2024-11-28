/*Tabulky pojmenujte t_{jmeno}_{prijmeni}_project_SQL_primary_final 
 * (pro data mezd a cen potravin za Českou republiku sjednocených na totožné porovnatelné období – společné roky) 
 * a t_{jmeno}_{prijmeni}_project_SQL_secondary_final (pro dodatečná data o dalších evropských státech).*/

SELECT * FROM czechia_payroll cp 
ORDER BY payroll_year DESC ; -- 2000-2021

SELECT * FROM czechia_price cp 
ORDER BY date_from DESC; -- 2006-2018




SELECT 
    cp.payroll_year, 
    ROUND(AVG(cp.value), 2) AS average_value, 
    cpvt.name AS value_type_name, 
    cpu.name AS unit_name, 
    cpc.name AS calculation_name, 
    cpib.name AS branch_name
FROM 
    czechia_payroll cp
LEFT JOIN 
    czechia_payroll_value_type cpvt 
    ON cp.value_type_code = cpvt.code
LEFT JOIN 
    czechia_payroll_unit cpu 
    ON cp.unit_code = cpu.code
LEFT JOIN 
    czechia_payroll_calculation cpc 
    ON cp.calculation_code = cpc.code
LEFT JOIN 
    czechia_payroll_industry_branch cpib 
    ON cp.industry_branch_code = cpib.code
WHERE 
    cp.value IS NOT NULL 
    AND cpib.name IS NOT NULL 
    AND cp.payroll_year BETWEEN 2006 AND 2018 
    AND cp.value_type_code = 5958 
    AND cp.unit_code = 200 
    AND cp.calculation_code = 100
GROUP BY 
    cp.payroll_year, 
    cpib.name
ORDER BY 
    cp.payroll_year DESC;


SELECT 
    YEAR(cp.date_from) AS year_price, 
    cpc.name AS category_name, 
    ROUND(AVG(cp.value), 2) AS average_value
FROM 
    czechia_price cp
LEFT JOIN 
    czechia_price_category cpc 
    ON cp.category_code = cpc.code
WHERE 
    YEAR(cp.date_from) BETWEEN 2006 AND 2018
GROUP BY 
    year_price, 
    cpc.name;


CREATE OR REPLACE TABLE t_olha_berezovska_project_SQL_primary_final  AS
SELECT 
    pd.year_data AS year, 
    pd.branch_name, 
    pd.average_payroll_value, 
    pr.category_name, 
    pr.average_price_value
FROM (
    SELECT 
        cp.payroll_year AS year_data, 
        cpib.name AS branch_name, 
        ROUND(AVG(cp.value), 2) AS average_payroll_value
    FROM czechia_payroll cp
    LEFT JOIN czechia_payroll_value_type cpvt 
        ON cp.value_type_code = cpvt.code
    LEFT JOIN czechia_payroll_unit cpu 
        ON cp.unit_code = cpu.code
    LEFT JOIN czechia_payroll_calculation cpc 
        ON cp.calculation_code = cpc.code
    LEFT JOIN czechia_payroll_industry_branch cpib 
        ON cp.industry_branch_code = cpib.code
    WHERE cp.value IS NOT NULL 
      AND cpib.name IS NOT NULL 
      AND cp.payroll_year BETWEEN 2006 AND 2018 
      AND cp.value_type_code = 5958 
      AND cp.unit_code = 200 
      AND cp.calculation_code = 100
    GROUP BY cp.payroll_year, cpib.name
) AS pd
LEFT JOIN (
    SELECT 
        YEAR(cp.date_from) AS year_data, 
        cpc.name AS category_name, 
        ROUND(AVG(cp.value), 2) AS average_price_value
    FROM czechia_price cp
    LEFT JOIN czechia_price_category cpc 
        ON cp.category_code = cpc.code
    WHERE YEAR(cp.date_from) BETWEEN 2006 AND 2018
    GROUP BY YEAR(cp.date_from), cpc.name
) AS pr
ON pd.year_data = pr.year_data
UNION
SELECT 
    pr.year_data AS year, 
    pd.branch_name, 
    pd.average_payroll_value, 
    pr.category_name, 
    pr.average_price_value
FROM (
    SELECT 
        YEAR(cp.date_from) AS year_data, 
        cpc.name AS category_name, 
        ROUND(AVG(cp.value), 2) AS average_price_value
    FROM czechia_price cp
    LEFT JOIN czechia_price_category cpc 
        ON cp.category_code = cpc.code
    WHERE YEAR(cp.date_from) BETWEEN 2014 AND 2018
    GROUP BY YEAR(cp.date_from), cpc.name
) AS pr
LEFT JOIN (
    SELECT 
        cp.payroll_year AS year_data, 
        cpib.name AS branch_name, 
        ROUND(AVG(cp.value), 2) AS average_payroll_value
    FROM czechia_payroll cp
    LEFT JOIN czechia_payroll_value_type cpvt 
        ON cp.value_type_code = cpvt.code
    LEFT JOIN czechia_payroll_unit cpu 
        ON cp.unit_code = cpu.code
    LEFT JOIN czechia_payroll_calculation cpc 
        ON cp.calculation_code = cpc.code
    LEFT JOIN czechia_payroll_industry_branch cpib 
        ON cp.industry_branch_code = cpib.code
    WHERE cp.value IS NOT NULL 
      AND cpib.name IS NOT NULL 
      AND cp.payroll_year BETWEEN 2006 AND 2018 
      AND cp.value_type_code = 5958 
      AND cp.unit_code = 200 
      AND cp.calculation_code = 100
    GROUP BY cp.payroll_year, cpib.name
) AS pd
ON pd.year_data = pr.year_data
ORDER BY year DESC;

SELECT * FROM t_olha_berezovska_project_sql_primary_final tobpspf ;







