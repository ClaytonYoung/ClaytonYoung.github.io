/*
For the year 2012, compare the percentage share of GDP Per Capita for the following regions: 
North America (NA), Europe (EU), and the Rest of the World.
Your result should look something like:

North America		Europe	Rest of the World
		X%					Y%				Z%
*/

-- create view to subset the data where year was 2012--could pull from previous query but keeping this so query can stand alone
CREATE VIEW twelve
AS
SELECT gdp_per_capita , country_code , year
FROM per_capita
WHERE year = 2012
GROUP BY country_code, year;



--selects and finds all contnents want to use this to only get one row for each 
SELECT 
-- for each, summed up where desired continent (or not), divided by sum of all continents gdp, rounded to 4, X by 100, casted to text, and appended "%" to a new column with cont of interest
	CAST(round(sum(CASE WHEN continents.continent_code IS "NA" THEN twelve.gdp_per_capita END)/ (sum(twelve.gdp_per_capita)),4)*100 AS TEXT)||"%" AS "North America",
	CAST(round(sum(CASE WHEN continents.continent_code IS "EU" THEN twelve.gdp_per_capita  END)/ (sum(twelve.gdp_per_capita)),4)*100  AS TEXT)||"%" AS "Europe",
	CAST(round(sum(CASE WHEN continents.continent_code IS NOT "NA" AND continents.continent_code IS NOT "EU" 
			THEN twelve.gdp_per_capita  END)/ (sum(twelve.gdp_per_capita)),4)*100 AS TEXT)||"%"  AS "Rest of World"
		FROM twelve 
		-- probably didn't need to cast to text but that's what the viz showed...
LEFT JOIN countries ON twelve.country_code=countries.country_code
LEFT JOIN continent_map ON twelve.country_code=continent_map.country_code
LEFT JOIN continents ON  continent_map.continent_code=continents.continent_code
--again, there are some places included that aren't really a country, so excluded to prevent double dippin
WHERE continents.continent_name IS NOT NULL;






