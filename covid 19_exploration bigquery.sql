-- THIS QUERY IS USED FOR BIGQUERY DATABASE.
-- NOTE I RUN INTO SOME DIFFICULTY WHEN CALCULATING SOME OF THE COMPLEX DATA IN MYSQL(SINCE I WAS USING A LOCALHOST SERVER) SO I SHIFTED TO USING BIGQUERY WHICH IS MORE POWERFUL FOR ANALYSIS.



-- arctic-operand-386417.covid_19; this is the name of my prohect on bigquery

SELECT * From `arctic-operand-386417.covid_19.covid_deaths`;

SELECT * FROM `arctic-operand-386417.covid_19.covid_vaccinations`;

SELECT location, date, population, new_cases, total_cases, new_deaths, total_deaths
FROM `arctic-operand-386417.covid_19.covid_deaths`
ORDER BY location, date;


-- How many total cases are there in a country and how many total deaths have occured.
-- (total cases vs total deeaths)

SELECT location, date, population, total_cases, total_deaths, (total_deaths/total_cases)*100 AS Death_Percentage
FROM `arctic-operand-386417.covid_19.covid_deaths`
ORDER BY location, date;

-- looking at some individual locations
SELECT location, date, population, total_cases, total_deaths, (total_deaths/total_cases)*100 AS Death_Percentage
FROM `arctic-operand-386417.covid_19.covid_deaths`
where location like "%states%"
ORDER BY location, date;

SELECT location, date, population, total_cases, total_deaths, (total_deaths/total_cases)*100 AS Death_Percentage
FROM `arctic-operand-386417.covid_19.covid_deaths`
where location like "%banglad%"
ORDER BY location, date;

-- Checking out Total cases that occured over the entire location(Population)
-- Looking at the total population that got covid-19

SELECT location, date, population, total_cases, total_deaths, (total_cases/population)*100 AS Cases_Percentage
FROM `arctic-operand-386417.covid_19.covid_deaths`
where location like "%states%"
ORDER BY location, date;

-- Looking at countries with the highest infection rate compared to population

SELECT location, population,
	MAX(total_cases) AS Highest_Contracted_Cases,
	MAX((total_cases/population))*100 AS MaxContractedPop_Percent
FROM `arctic-operand-386417.covid_19.covid_deaths`
WHERE continent is not null
Group By location, population
-- where location like "%states%"
ORDER BY 4 DESC;

-- Showing the highest death count in a country(population)
SELECT location, population,
	MAX(total_deaths) AS Highest_death_Cases,
	MAX((total_deaths/population))*100 AS MaxdeathPop_Percent
FROM `arctic-operand-386417.covid_19.covid_deaths`
WHERE continent is not null
Group By location, population
ORDER BY 4 DESC;

-- Notice that for location column where it is supposed to be only countires we find fields with cotinents in them and having corresponding null values. A quick fix to this is to take out the continents with null values aslo taking out the location with these continent characters to have only contries. Since a continent in location won't have a value for continent in the continent column.
SELECT location, population,date,
	MAX(total_deaths) AS Highest_death_Cases,
	MAX((total_deaths/population))*100 AS MaxdeathPop_Percent
FROM `arctic-operand-386417.covid_19.covid_deaths`
WHERE continent is not null
Group By location, population, date
ORDER BY 5 DESC;

-- Showing by continent
SELECT continent,
	MAX(total_deaths) AS Highest_death_Cases,
	MAX((total_deaths/population))*100 AS MaxdeathPop_Percent
FROM `arctic-operand-386417.covid_19.covid_deaths`
WHERE continent is not null
Group By continent
ORDER BY 2 DESC;
-- note from above query, removing the where statement the null will be the world  

-- another way to do it is to use the location column  wiith the continent fields by filtering it with where continent is null
SELECT location,
	MAX(total_deaths) AS Highest_death_Cases,
	MAX((total_deaths/population))*100 AS MaxdeathPop_Percent
FROM `arctic-operand-386417.covid_19.covid_deaths`
WHERE continent is null
Group By location
ORDER BY 2 DESC;

-- Checking the global numbers

SELECT date, SUM(new_cases)
FROM `arctic-operand-386417.covid_19.covid_deaths`
WHERE continent is not null
Group By date
ORDER BY 2 DESC;

-- Checking the total new cases and new deaths recorded across the globe;
SELECT SUM(new_cases) AS Total_New_World_Cases,
	SUM(new_deaths) AS Total_New_World_Deaths,
    SUM(new_deaths)/SUM(new_cases)*100 AS NewDeath_Percent
FROM `arctic-operand-386417.covid_19.covid_deaths`
WHERE continent is not null
-- Group By date
ORDER BY 1,2;


-- Checking the total new cases recorded each day and total deaths each day across the globe;
SELECT date, SUM(new_cases) AS New_World_Cases,
	SUM(new_deaths) AS New_World_Deaths,
    SUM(new_deaths)/SUM(new_cases)*100 AS NewDeath_Percent
FROM `arctic-operand-386417.covid_19.covid_deaths`
WHERE continent is not null
Group By date
ORDER BY 1,2;


-- PHASE TWO


-- Checking the covid vaccinations
SELECT * FROM `arctic-operand-386417.covid_19.covid_vaccinations`;

-- Joining the two dataset(covid_deaths and covid_vaccinations)
SELECT * FROM `arctic-operand-386417.covid_19.covid_deaths` AS cd
JOIN `arctic-operand-386417.covid_19.covid_vaccinations` AS cv
	ON cd.location = cv.location
      and cd.date = cv.date
WHERE cd.continent is not null;


-- Checking total population Vs vacinnations
SELECT  cd.continent, cd.location, cd.population, cv.new_vaccinations
FROM `arctic-operand-386417.covid_19.covid_deaths` AS cd
JOIN `arctic-operand-386417.covid_19.covid_vaccinations` AS cv
	ON cd.location = cv.location
	 and cd.date = cv.date
WHERE cd.continent is not null
ORDER BY cd.location, cd.population;


-- "Rolling Total of New Vaccinations and Population for Each Location by Continent"
-- This title reflects the main aspects of the query, which calculates the rolling total of new vaccinations and the population for each location, considering the continent information. It showcases the dynamic nature of the rolling total calculation and emphasizes the grouping by continent and ordering by location.

SELECT  cd.continent, cd.location, cd.population, cv.new_vaccinations,
	SUM(cv.new_vaccinations) OVER (PARTITION BY cd.location ORDER BY cv.location, cd.date) AS rollingpeoplevaccinated
FROM `arctic-operand-386417.covid_19.covid_deaths` AS cd
JOIN `arctic-operand-386417.covid_19.covid_vaccinations` AS cv
	ON cd.location = cv.location
	and cd.date = cv.date
WHERE cd.continent is not null
ORDER BY 2,3;

-- calculating the vaccination percentage for each location based on the new vaccinations and population. 
SELECT
  cd.continent,
  cd.location,
  cd.population,
  cv.new_vaccinations,
  (cv.new_vaccinations / cd.population) * 100 AS vaccination_percentage
FROM
  `arctic-operand-386417.covid_19.covid_deaths` AS cd
JOIN
  `arctic-operand-386417.covid_19.covid_vaccinations` AS cv
ON
  cd.location = cv.location
WHERE
  cd.continent IS NOT NULL
ORDER BY
cd.location;

  
-- Using CTE to perform Calculation on Partition By in previous query
-- "Percentage of Population Vaccinated with Rolling Total of New Vaccinations"
-- COVID-19 Vaccination Progress by Location
-- Comment: This query provides an overview of the COVID-19 vaccination progress by location. It calculates the rolling total of new vaccinations and the vaccination percentage based on the population. This information is valuable for monitoring the vaccination efforts and assessing the progress made in each location. The results can help stakeholders understand the impact of vaccination campaigns and make informed decisions related to public health and resource allocation.

WITH Pop_Vaccinated AS (
    SELECT cd.continent, cd.location, cd.population, cv.new_vaccinations,
        SUM(cv.new_vaccinations) OVER (PARTITION BY cd.location ORDER BY cv.location, cd.date) AS rollingpeoplevaccinated
    FROM `arctic-operand-386417.covid_19.covid_deaths` AS cd
    JOIN `arctic-operand-386417.covid_19.covid_vaccinations` AS cv 
			ON cd.location = cv.location AND cd.date = cv.date
    WHERE cd.continent IS NOT NULL
)
SELECT Pop_Vaccinated.*, (Pop_Vaccinated.rollingpeoplevaccinated / Pop_Vaccinated.population) * 100 AS vaccination_percentage
FROM Pop_Vaccinated;

-- Using Temp Table to perform Calculation on Partition By in previous query
-- "Percentage of Population Vaccinated Over Time"
-- Comment: "This query calculates the rolling percentage of population vaccinated over time. It provides valuable insights into the progress of COVID-19 vaccination efforts across different locations.

CREATE TEMPORARY TABLE PercentPopulationVaccinated (
  Continent STRING,
  Location STRING,
  Date DATE,
  Population NUMERIC,
  New_vaccinations NUMERIC,
  RollingPeopleVaccinated NUMERIC
) AS
SELECT
  cd.continent,
  cd.location,
  cd.date,
  cd.population,
  cv.new_vaccinations,
  SUM(cv.new_vaccinations) OVER (PARTITION BY cd.location ORDER BY cd.location, cd.date) AS RollingPeopleVaccinated
FROM
  `arctic-operand-386417.covid_19.covid_deaths` AS cd
JOIN
  `arctic-operand-386417.covid_19.covid_vaccinations` AS cv
ON
  cd.location = cv.location
  AND cd.date = cv.date;

SELECT
  *,
  (RollingPeopleVaccinated / Population) * 100 AS VaccinationPercentage
FROM
  PercentPopulationVaccinated;



-- Creating View to store data for later visualizations

Create View PercentPopulationVaccinated as
SELECT  cd.continent, cd.location, cd.population, cv.new_vaccinations,
	SUM(cv.new_vaccinations) OVER (PARTITION BY cd.location ORDER BY cv.location,covid_deaths.date) AS rollingpeoplevaccinated
FROM `arctic-operand-386417.covid_19.covid_deaths` AS cd
JOIN `arctic-operand-386417.covid_19.covid_vaccinations` AS cv
	ON cd.location = cv.location
	and cd.date = cv.date
WHERE cd.continent is not null
-- ORDER BY 2,3;
