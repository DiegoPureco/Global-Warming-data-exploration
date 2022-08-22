SELECT *
FROM GLOBAL_TEMPERATURES
;

--- Average global temperature per year.
SELECT  DISTINCT(EXTRACT(YEAR FROM date)) AS anio,
		AVG(LAND_AVERAGE_TEMPERATURE) AS avg_temp, 
		AVG(LAND_MAX_TEMPERATURE) AS max_temp,
		AVG(LAND_MIN_TEMPERATURE) AS min_temp
FROM GLOBAL_TEMPERATURES
GROUP BY ANIO
ORDER BY anio
;

-- Average global temperature per year, taking into consideration ocean temperatures.
SELECT  DISTINCT(DATE_PART('YEAR', date)) AS anio,
		AVG(land_and_ocean_average_temperature) AS avg_ocean_temp
FROM global_temperatures
GROUP BY anio
HAVING AVG(land_and_ocean_average_temperature) IS NOT NULL
ORDER BY anio
;

-- Average temperature ordered by country and year.
SELECT  DISTINCT(DATE_PART('YEAR', date)) AS anio,
		country,
		AVG(average_temperature)
FROM temperatures_by_country
GROUP BY country, anio
ORDER BY country, anio
;

-- Top 10 hottest countries in the world in 1970
SELECT  DISTINCT(DATE_PART('YEAR', date)) AS anio,
		country,
		AVG(average_temperature) AS avg_temp,
		ROW_NUMBER() OVER(ORDER BY AVG(average_temperature) DESC) AS rank
FROM temperatures_by_country
WHERE EXTRACT(YEAR FROM date) = 1970
GROUP BY country, anio
HAVING AVG(average_temperature) IS NOT NULL
ORDER BY avg_temp DESC
LIMIT 10
;

-- Top 10 hottest countries in the world in 2013
SELECT  DISTINCT(DATE_PART('YEAR', date)) AS anio,
		country,
		AVG(average_temperature) AS avg_temp,
		ROW_NUMBER() OVER(ORDER BY AVG(average_temperature) DESC) AS rank
FROM temperatures_by_country
WHERE EXTRACT(YEAR FROM date) = 2013
GROUP BY country, anio
HAVING AVG(average_temperature) IS NOT NULL
ORDER BY avg_temp DESC
LIMIT 10
;

-- Top 10 coldest countries in the world in 1970
SELECT  DISTINCT(EXTRACT(YEAR FROM date)) AS anio,
		country,
		AVG(average_temperature) AS avg_temp,
		ROW_NUMBER() OVER(ORDER BY AVG(average_temperature)) AS rank
FROM temperatures_by_country
WHERE DATE_PART('YEAR',date) = 1970
GROUP BY country, anio
ORDER BY avg_temp
LIMIT 10
;

-- Top 10 coldest countries in the world in 2013
SELECT  DISTINCT(EXTRACT(YEAR FROM date)) AS anio,
		country,
		AVG(average_temperature) AS avg_temp,
		ROW_NUMBER() OVER(ORDER BY AVG(average_temperature))
FROM temperatures_by_country
WHERE DATE_PART('YEAR',date) = 2013
GROUP BY country, anio
ORDER BY avg_temp
LIMIT 10
;

-- Average temperature ordered by city, country, and year
SELECT  DISTINCT EXTRACT(YEAR FROM date) AS anio,
		city,
		country,
		AVG(average_temperature) AS avg_temp
FROM temperatures_by_city
GROUP BY anio, city, country
ORDER BY city, anio
;

-- Top 10 hottest cities in the world in 1970
SELECT  EXTRACT(YEAR FROM date) AS anio,
		city,
		country,
		AVG(average_temperature) AS avg_temp,
		ROW_NUMBER() OVER(ORDER BY AVG(average_temperature) DESC) AS Rank
FROM temperatures_by_city
WHERE DATE_PART('YEAR', date) = 1970
GROUP BY anio, city, country
ORDER BY avg_temp DESC
LIMIT 10
;

-- Top 10 hottest cities in the world in 2013
SELECT  EXTRACT(YEAR FROM date) AS anio,
		city,
		country,
		AVG(average_temperature) AS avg_temp,
		ROW_NUMBER() OVER(ORDER BY AVG(average_temperature) DESC) AS Rank
FROM temperatures_by_city
WHERE DATE_PART('YEAR', date) = 2013
GROUP BY anio, city, country
ORDER BY avg_temp DESC
LIMIT 10
;

-- Top 10 coldest cities in the world in 1970
SELECT  DATE_PART('YEAR', date) AS anio,
		city,
		country,
		AVG(average_temperature) AS avg_temp,
		ROW_NUMBER() OVER(ORDER BY AVG(average_temperature)) AS rank
FROM temperatures_by_city
WHERE EXTRACT(YEAR FROM date) = 1970
GROUP BY anio, city, country
ORDER BY avg_temp
LIMIT 10
;

-- Top 10 coldest cities in the world in 2013
SELECT  DATE_PART('YEAR', date) AS anio,
		city,
		country,
		AVG(average_temperature) AS avg_temp,
		ROW_NUMBER() OVER(ORDER BY AVG(average_temperature)) AS rank
FROM temperatures_by_city
WHERE EXTRACT(YEAR FROM date) = 2013
GROUP BY anio, city, country
ORDER BY avg_temp
LIMIT 10
;

------------------------------------------------------------
/*  
CANADA ANALYSIS 
By doing this query I realize that in the temperatures_by_state table there is no data from Quebec 
(it does not appear on the 'state' column)
*/
SELECT DISTINCT(state)
FROM temperatures_by_state
WHERE country = 'Canada'
ORDER BY state
;


/*
Nevertheless, the temperatures_by_city table does contain that data, we verify that with the next query
*/
SELECT *
FROM temperatures_by_city
WHERE city LIKE '%Quebec%'
ORDER BY date 
;

/*
We save the data that returns from that query on a CSV and then we import that CSV con 
the temperatures_by_state table, we are interested in getting the data from that table.
*/

/*
Finally, we do the analysis.

Average temperature from the territories and provinces of Canada. 
Ordered by province/territory and year.
*/
SELECT  DISTINCT(DATE_PART('YEAR',DATE)) AS anio,
		state,
		country,
		AVG(average_temperature) AS avg_temp
FROM temperatures_by_state
WHERE country = 'Canada'
GROUP BY anio, state, country
ORDER BY state, anio 
;


--Average temperature from the territories on 1970
SELECT  EXTRACT(YEAR FROM DATE) AS anio,
		STATE,
		COUNTRY,
		AVG(AVERAGE_TEMPERATURE) AS avg_temp,
		ROW_NUMBER() OVER(ORDER BY AVG(AVERAGE_TEMPERATURE) DESC) AS rank
FROM TEMPERATURES_BY_STATE
WHERE COUNTRY = 'Canada' AND DATE_PART('YEAR',DATE) = 1970
GROUP BY anio, state, country
ORDER BY avg_temp DESC
;

--Average temperature from the territories on 2013
SELECT  EXTRACT(YEAR FROM DATE) AS anio,
		STATE,
		COUNTRY,
		AVG(AVERAGE_TEMPERATURE) AS avg_temp
FROM TEMPERATURES_BY_STATE
WHERE COUNTRY = 'Canada' AND DATE_PART('YEAR',DATE) = 2013
GROUP BY anio, state, country
ORDER BY avg_temp DESC
;

------------------------------------------


-- United States analysis
-- Verifying that the temperatures_by_state table contains all data from all 50 states.
SELECT COUNT(DISTINCT(STATE))
FROM TEMPERATURES_BY_STATE
WHERE COUNTRY = 'United States'
;

-- Average temperature ordered by state and year.
SELECT  DISTINCT(EXTRACT(YEAR FROM date)) AS anio,
		state,
		country,
		AVG(average_temperature) AS avg_temp
FROM TEMPERATURES_BY_STATE
WHERE COUNTRY = 'United States'
GROUP BY anio, state, country
ORDER BY state, anio
;

-- Average temperature from the states on 1970.
SELECT  EXTRACT(YEAR FROM DATE) AS anio,
		state,
		country,
		AVG(average_temperature) AS avg_temp,
		ROW_NUMBER() OVER(ORDER BY AVG(average_temperature) DESC) AS rank
FROM temperatures_by_state
WHERE country = 'United States' AND DATE_PART('YEAR', date) = 1970
GROUP BY anio, state, country
ORDER BY avg_temp DESC
;

-- Average temperature from the states on 2013.
SELECT  EXTRACT(YEAR FROM DATE) AS anio,
		state,
		country,
		AVG(average_temperature) AS avg_temp,
		ROW_NUMBER() OVER(ORDER BY AVG(average_temperature) DESC) AS rank
FROM temperatures_by_state
WHERE country = 'United States' AND DATE_PART('YEAR', date) = 2013
GROUP BY anio, state, country
ORDER BY avg_temp DESC
;