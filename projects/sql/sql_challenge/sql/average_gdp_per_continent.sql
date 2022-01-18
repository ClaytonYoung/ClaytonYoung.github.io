/*For years 2004 through 2012, calculate the average GDP Per Capita for every continent for every year. 
The average in this case is defined as the Sum of GDP Per Capita for All Countries in the Continent / Number of Countries in the Continent
The final product should include columns for:
Year
Continent
Average GDP Per Capita
*/

SELECT per_capita.year AS "Year", --select and cap year
continents.continent_name AS "Continent", --select and cap cont
--sum gdp per capita (later grouped by continent name and year) / count of country names (again, grouped by continent--verified this works as desired)
ROUND(sum(per_capita.gdp_per_capita)/COUNT(countries.country_name),2) AS "Average GDP Per Capita"
FROM per_capita
LEFT JOIN countries ON per_capita.country_code = countries.country_code
LEFT JOIN continent_map ON per_capita.country_code = continent_map.country_code
LEFT JOIN continents ON continent_map.continent_code = continents.continent_code
--year not needed since data betwween those years but kept. Again filter out the non-country data by filtering where cont name not null
WHERE year BETWEEN 2004 AND 2012 AND continents.continent_name IS NOT NULL
--need to group by both continent and year 
GROUP BY continents.continent_name, per_capita.year
ORDER BY per_capita.year, continents.continent_name;

