/*Alphabetically list all the country codes in the continent map table that appear more than once. 
For countries with no country code make them display as "N/A" and display them first in the list.*/

--create with statement converting nulls to N/A
WITH temp_refined AS(
--selecting country code as temp_cc and converting null cases to 'n/a'
SELECT
	CASE 
		WHEN country_code IS NULL THEN 'N/A'
		ELSE country_code
	END AS temp_country_code
FROM continent_map)
--base further querying on temp_refined
SELECT temp_country_code --could use * 
FROM temp_refined
GROUP BY temp_country_code
--select cases where temp_cc occurs more than once
HAVING count(temp_country_code) >1
--setting na to 0 so appears first when ordering by
ORDER BY (CASE WHEN temp_country_code = 'N/A' THEN 0 ELSE 1 END), temp_country_code;



