/*
2.List the Top 10 Countries by year over year % GDP per capita growth between 2011 & 2012.
% year over year growth is defined as (GDP Per Capita in 2012 - GDP Per Capita in 2011) / (GDP Per Capita in 2011)
The final product should include columns for:
Rank
Country Name
Country Code
Continent
Growth Percent
*/


-- create view to subset the data where year was 2011
CREATE VIEW eleven
AS
SELECT gdp_per_capita , country_code , year
FROM per_capita
WHERE year = 2011;

-- create view to subset the data where year was 2012
CREATE VIEW twelve
AS
SELECT gdp_per_capita , country_code , year
FROM per_capita
WHERE year = 2012;

--selecting rank and ordering by growth 
SELECT RANK() OVER(ORDER BY ((twelve.gdp_per_capita - eleven.gdp_per_capita)/ eleven.gdp_per_capita) DESC) Rank, 
countries.country_name AS "Country Name", 
eleven.country_code AS "Country Code",
continents.continent_name AS "Continent", 
--round, x100, and convert to string to include %
CAST(ROUND((((twelve.gdp_per_capita - eleven.gdp_per_capita)/ eleven.gdp_per_capita)*100 ),2) AS text)||'%' AS "Growth Percentage"
-- (GDP Per Capita in 2012 - GDP Per Capita in 2011) / (GDP Per Capita in 2011)
FROM eleven 
JOIN twelve ON twelve.country_code=eleven.country_code
JOIN countries ON countries.country_code=eleven.country_code
JOIN continent_map ON continent_map.country_code=eleven.country_code
JOIN continents ON continents.continent_code=continent_map.continent_code
--dropped these because there where places included that were not countries-those didn't have a continent assocaited with them
WHERE continent_name IS NOT NULL
LIMIT 10;