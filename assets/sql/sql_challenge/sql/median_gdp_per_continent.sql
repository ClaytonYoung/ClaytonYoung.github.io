/*
For years 2004 through 2012, calculate the median GDP Per Capita for every continent for every year. 
The median in this case is defined as The value at which half of the samples for a continent are higher and half are lower

The final product should include columns for:

Year
Continent
Median GDP Per Capita
*/

SELECT continents.continent_name AS "Continent", per_capita.year AS "Year",
--selecting median 'percentile_cont(0.5)' from grouped data by year and continent
percentile_cont(0.5) WITHIN GROUP (ORDER BY per_capita.gdp_per_capita) AS "Median GDP Per Capita"
FROM per_capita
LEFT JOIN countries ON per_capita.country_code = countries.country_code
LEFT JOIN continent_map ON per_capita.country_code = continent_map.country_code
LEFT JOIN continents ON continent_map.continent_code = continents.continent_code
WHERE year BETWEEN 2004 AND 2012 AND continents.continent_name IS NOT NULL 
GROUP BY continents.continent_name, per_capita.year
ORDER BY continents.continent_name, per_capita.year;

