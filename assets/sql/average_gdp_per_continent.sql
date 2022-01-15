/*For years 2004 through 2012, calculate the average GDP Per Capita for every continent for every year. 
The average in this case is defined as the Sum of GDP Per Capita for All Countries in the Continent / Number of Countries in the Continent

The final product should include columns for:

Year
Continent
Average GDP Per Capita
*/


SELECT sum(per_capita.gdp_per_capita), per_capita.year, per_capita.country_code, countries.country_name,
--keeping country names as a check 
 continent_map.continent_code, continents.continent_name
FROM per_capita
LEFT JOIN countries ON per_capita.country_code = countries.country_code
LEFT JOIN continent_map ON per_capita.country_code = continent_map.country_code
LEFT JOIN continents ON continent_map.continent_code = continents.continent_code
WHERE year BETWEEN 2004 AND 2012 AND continents.continent_name IS NOT NULL
GROUP BY continents.continent_name, per_capita.year




SELECT continents.continent_name,COUNT(countries.country_name)
FROM countries
JOIN continent_map ON countries.country_code = continent_map.country_code
JOIN continents ON continent_map.continent_code = continents.continent_code
GROUP BY continent_map.continent_code



-- think this is the answer
SELECT sum(per_capita.gdp_per_capita)/COUNT(countries.country_name), per_capita.year, per_capita.country_code, countries.country_name,
--keeping country names as a check 
 continent_map.continent_code, continents.continent_name
FROM per_capita
LEFT JOIN countries ON per_capita.country_code = countries.country_code
LEFT JOIN continent_map ON per_capita.country_code = continent_map.country_code
LEFT JOIN continents ON continent_map.continent_code = continents.continent_code
WHERE year BETWEEN 2004 AND 2012 AND continents.continent_name IS NOT NULL
GROUP BY continents.continent_name, per_capita.year





