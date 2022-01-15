/*
For the year 2012, compare the percentage share of GDP Per Capita for the following regions: 
North America (NA), Europe (EU), and the Rest of the World. 
Your result should look something like:

North America		Europe	Rest of the World
		X%					Y%					Z%
*/


-- Again, there were cases here that contained values that didn't represent a country-filtered these out by continent == NULL

--sum gdp-these are grouped by later on 
SELECT (sum(twelve.gdp_per_capita)) / (SELECT sum(twelve.gdp_per_capita)--start of subquery to summ all gdp for denominator
	FROM twelve 
	LEFT JOIN countries ON twelve.country_code=countries.country_code
	LEFT JOIN continent_map ON twelve.country_code=continent_map.country_code
	LEFT JOIN continents ON  continent_map.continent_code=continents.continent_code
	WHERE continents.continent_name IS NOT NULL) AS percentage_of_gdp,
	CASE 
		WHEN continents.continent_code IS NOT "NA" AND continents.continent_code IS NOT "EU" THEN "Rest of the World"
		ELSE continents.continent_name
	END AS continent
FROM twelve 
LEFT JOIN countries ON twelve.country_code=countries.country_code
LEFT JOIN continent_map ON twelve.country_code=continent_map.country_code
LEFT JOIN continents ON  continent_map.continent_code=continents.continent_code
WHERE continents.continent_name IS NOT NULL
GROUP BY continent ;
 
 

-- sandbox


SELECT (sum(twelve.gdp_per_capita)) / (SELECT sum(twelve.gdp_per_capita)--start of subquery to summ all gdp for denominator
	FROM twelve 
	LEFT JOIN countries ON twelve.country_code=countries.country_code
	LEFT JOIN continent_map ON twelve.country_code=continent_map.country_code
	LEFT JOIN continents ON  continent_map.continent_code=continents.continent_code
	WHERE continents.continent_name IS NOT NULL) AS test,
	CASE WHEN continents.continent_code IS "NA" THEN "North America" END AS "North America",
	CASE WHEN continents.continent_code IS "EU" THEN "Europe" END AS "Europe",
	CASE WHEN continents.continent_code IS NOT "NA" AND continents.continent_code IS NOT "EU" THEN "Rest of the World" END AS "Rest of World"	--END AS n_a
FROM twelve 
LEFT JOIN countries ON twelve.country_code=countries.country_code
LEFT JOIN continent_map ON twelve.country_code=continent_map.country_code
LEFT JOIN continents ON  continent_map.continent_code=continents.continent_code
WHERE continents.continent_name IS NOT NULL
--GROUP BY n_a ;





--selects and finds all contnents
SELECT 
	CASE WHEN continents.continent_code IS "NA" THEN "North America" END AS "North America",
	CASE WHEN continents.continent_code IS "EU" THEN "Europe" END AS "Europe",
	CASE WHEN continents.continent_code IS NOT "NA" AND continents.continent_code IS NOT "EU" THEN "Rest of the World" END AS "Rest of World"
	FROM twelve 
LEFT JOIN countries ON twelve.country_code=countries.country_code
LEFT JOIN continent_map ON twelve.country_code=continent_map.country_code
LEFT JOIN continents ON  continent_map.continent_code=continents.continent_code
WHERE continents.continent_name IS NOT NULL




SELECT (sum(twelve.gdp_per_capita)) / (SELECT sum(twelve.gdp_per_capita)--start of subquery to summ all gdp for denominator
	FROM twelve 
	LEFT JOIN countries ON twelve.country_code=countries.country_code
	LEFT JOIN continent_map ON twelve.country_code=continent_map.country_code
	LEFT JOIN continents ON  continent_map.continent_code=continents.continent_code
	WHERE continents.continent_name IS NOT NULL) AS test,
	CASE WHEN continents.continent_code IS "NA" THEN "North America" END AS "North America",
	CASE WHEN continents.continent_code IS "EU" THEN "Europe" END AS "Europe",
	CASE WHEN continents.continent_code IS NOT "NA" AND continents.continent_code IS NOT "EU" THEN "Rest of the World" END AS "Rest of World"	--END AS n_a
FROM twelve 
LEFT JOIN countries ON twelve.country_code=countries.country_code
LEFT JOIN continent_map ON twelve.country_code=continent_map.country_code
LEFT JOIN continents ON  continent_map.continent_code=continents.continent_code
WHERE continents.continent_name IS NOT NULL
--GROUP BY n_a ;


