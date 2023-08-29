--a. Retrieve the cumulative counts of confirmed, deceased, and recovered cases.

SELECT
  SUM(confirmed) AS confirmed,
  SUM(deaths) AS deaths,
  SUM(recovered) AS recovered
FROM
  covid_19_data
GROUP BY
  province,
  country

--b. Extract the aggregate counts of confirmed, deceased, and recovered cases for the first quarter of each observation year.

SELECT
 observationdate AS observation_year,
  SUM(confirmed) AS confirmed,
  SUM(deaths) AS deceased,
  SUM(recovered) AS recovered
FROM covid_19_data
WHERE 
EXTRACT(quarter from observationdate) = 1
AND EXTRACT(year from observationdate) IN (2019,2020)
GROUP BY observationdate

--c. Formulate a comprehensive summary encompassing the following for each
--country:
--Total confirmed cases
--Total deaths
--Total recoveries

SELECT
 country,
SUM(confirmed) AS Total_confirmed_cases, 
SUM(deaths) AS Total_deaths,
SUM(confirmed) AS Total_recoveries FROM covid_19_data
GROUP BY
 country

--d. Determine the percentage increase in the number of death cases from 2019 to 2020.

 SELECT
    (SUM(deaths_2020) - SUM(deaths_2019)) / SUM(deaths_2019) * 100 AS death_increase_percentage
FROM (
    SELECT
        SUM(CASE WHEN EXTRACT(YEAR FROM observationdate) = 2019 THEN deaths ELSE 0 END) AS deaths_2019,
        SUM(CASE WHEN EXTRACT(YEAR FROM observationdate) = 2020 THEN deaths ELSE 0 END) AS deaths_2020
    FROM covid_19_data
) subquery;

--e. Compile data for the top 5 countries with the highest confirmed cases.

SELECT country, sum(confirmed) as highest_confirmed_cases
FROM covid_19_data 
group by country 
order by total_confirmed desc limit 5


--f. Calculate the net change (increase or decrease) in confirmed cases on a monthly basis over the two-year period.

SELECT
    DATE_TRUNC('month', observationdate) AS month,
    SUM(confirmed) - LAG(SUM(confirmed), 1, 0) OVER (ORDER BY DATE_TRUNC('month', observationdate)) AS net_change_confirmed
FROM covid_19_data
GROUP BY month
ORDER BY month;