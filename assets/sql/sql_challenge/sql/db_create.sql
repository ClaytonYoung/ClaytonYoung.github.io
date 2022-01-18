--COPIED FROM PGADMIN GUI
------------------------------------
-- CREATE DB
CREATE DATABASE salesloft
    WITH 
    OWNER = postgres
    ENCODING = 'UTF8'
    LC_COLLATE = 'en_US.UTF-8'
    LC_CTYPE = 'en_US.UTF-8'
    TABLESPACE = pg_default
    CONNECTION LIMIT = -1;
------------------------------------

--CONTINENT MAP TABLE 
CREATE TABLE IF NOT EXISTS public.continent_map
(
    country_code text COLLATE pg_catalog."default",
    continent_code text COLLATE pg_catalog."default"
)
TABLESPACE pg_default;
ALTER TABLE IF EXISTS public.continent_map
    OWNER to postgres;
	
--CONTINENTS TABLE 
CREATE TABLE IF NOT EXISTS public.continents
(
    continent_code text COLLATE pg_catalog."default",
    continent_name text COLLATE pg_catalog."default"
)
TABLESPACE pg_default;
ALTER TABLE IF EXISTS public.continents
    OWNER to postgres;
	
--COUNTRIES TABLE
CREATE TABLE IF NOT EXISTS public.countries
(
    country_code text COLLATE pg_catalog."default",
    country_name text COLLATE pg_catalog."default"
)
TABLESPACE pg_default;
ALTER TABLE IF EXISTS public.countries
    OWNER to postgres;
	
--PER CAPITA TABLE
CREATE TABLE IF NOT EXISTS public.per_capita
(
    country_code text COLLATE pg_catalog."default",
    year numeric,
    gdp_per_capita numeric
)
TABLESPACE pg_default;
ALTER TABLE IF EXISTS public.per_capita
    OWNER to postgres;
---------------------------------------

--COPY CSVS TO TABLES

--CONTINENT MAP
COPY continent_map
FROM '/Users/ClaytonYoung/data-analyst-exercise/sql_challenge/continent_map.csv'
DELIMITER ','
CSV HEADER;

--CONTINENTS
COPY continents
FROM '/Users/ClaytonYoung/data-analyst-exercise/sql_challenge/continents.csv'
DELIMITER ','
CSV HEADER;

--COUNTRIES
COPY countries
FROM '/Users/ClaytonYoung/data-analyst-exercise/sql_challenge/countries.csv'
DELIMITER ','
CSV HEADER;

--PER CAPITA
COPY per_capita
FROM '/Users/ClaytonYoung/data-analyst-exercise/sql_challenge/per_capita.csv'
DELIMITER ','
CSV HEADER;
