/*Alphabetically list all the country codes in the continent map table that appear more than once. 
For countries with no country code make them display as "N/A" and display them first in the list.*/

SELECT 
--selecting country code as temp_cc and converting null cases to 'n/a'
	CASE 
		WHEN country_code IS NULL THEN "N/A"
		ELSE country_code
	END AS temp_cc
--base further querying on temp_cc
FROM continent_map
--grou[ by temp country code (temp_cc)
GROUP BY temp_cc
--select cases where temp_cc occurs more than once
HAVING count(temp_cc) >1
--sets na to zero so comes first. otherwise sorted based on alphabetically order (as desired)
ORDER BY (CASE WHEN temp_cc = 'N/A' THEN 0 ELSE 1 END), temp_cc
