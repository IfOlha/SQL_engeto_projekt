-- t_{jmeno}_{prijmeni}_project_SQL_secondary_final (pro dodatečná data o dalších evropských státech).


SELECT e.`year`, c.country, c.population , c.surface_area , e.GDP , e.gini , e.taxes  FROM countries c 
LEFT JOIN economies e 
ON c.country =e.country 
WHERE c.continent ='Europe' AND  c.country != 'Czech Republic'
AND e.`year` BETWEEN 2014 AND 2018 ;

CREATE OR REPLACE TABLE t_olha_berezovska_project_SQL_secondary_final AS
SELECT 
    e.`year`, 
    c.country, 
    c.population, 
    c.surface_area, 
    e.GDP, 
    e.gini, 
    e.taxes
FROM 
    countries c
LEFT JOIN 
    economies e 
    ON c.country = e.country
WHERE 
    c.continent = 'Europe' 
    AND e.`year` BETWEEN 2006 AND 2018;
  
   
SELECT * FROM t_olha_berezovska_project_SQL_secondary_final;
