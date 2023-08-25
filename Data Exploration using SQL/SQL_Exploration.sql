-- Data Exploaration of CovidDeath Table
SELECT * FROM CovidDeath;

--Working Data
SELECT location,date, total_cases, new_cases, total_deaths, population
FROM CovidDeath
ORDER BY 1,2

--Comparing Total Cases and Total Deaths on basis of location
SELECT location,date, total_cases, total_deaths, (total_deaths/total_cases)*100 AS Mortality_Rate
FROM CovidDeath
WHERE location LIKE 'India'
ORDER BY 1,2

--Total number of cases in a country compared to its population and infection rate
SELECT location, population, MAX(total_cases) AS Highest_Cases, MAX((total_cases/population))*100 AS Infection_Rate
FROM CovidDeath
GROUP BY location, population
ORDER BY Infection_Rate DESC

--Countries with highest death count
SELECT location, population, MAX(total_deaths) AS DeathCount
FROM CovidDeath
WHERE continent IS NOT NULL
GROUP BY location, population
ORDER BY location 

--Continent with highest death count
SELECT location, population, MAX(total_deaths) AS DeathCount
FROM CovidDeath
WHERE continent IS NULL
GROUP BY location, population
ORDER BY DeathCount DESC


-- New Cases, New Deaths and Moratlity rate by Date
SELECT date, SUM(new_cases) AS Daliy_New_Cases, SUM(new_deaths) AS Daliy_New_Deaths
FROM CovidDeath
WHERE continent IS NOT NULL
GROUP BY date
ORDER BY 1,2

-- New Cases, New Deaths and Moratlity rate by Date
SELECT SUM(new_cases) AS Total_New_Cases, SUM(new_deaths) AS Total_New_Deaths
FROM CovidDeath
WHERE continent IS NOT NULL
ORDER BY 1,2




-- Data Exploaration of CovidVaccine Table
SELECT * 
FROM CovidVaccine AS CV
INNER JOIN CovidDeath AS CD
	ON CV. location = CD.location
	AND CV.date = CD.date;

-- Total Population and New Vaccinations per day
SELECT CD.continent, CD.location, CD.date, CD.population, CV.new_vaccinations,
SUM(CV.new_vaccinations) OVER (PARTITION BY CD.location ORDER BY CD.location, CD.date) AS New_Vaccinations_Per_Day
FROM CovidVaccine AS CV
INNER JOIN CovidDeath AS CD
	ON CV. location = CD.location
	AND CV.date = CD.date
WHERE CD.continent IS NOT NULL
ORDER BY 1,2,3

--Population and Vaccination using CTE
WITH CTEVac (continent, location, date, population, new_vaccinations, new_vaccinations_per_day)
AS
(
SELECT CD.continent, CD.location, CD.date, CD.population, CV.new_vaccinations,
SUM(CV.new_vaccinations) OVER (PARTITION BY CD.location ORDER BY CD.location, CD.date) AS New_Vaccinations_Per_Day
FROM CovidVaccine AS CV
INNER JOIN CovidDeath AS CD
	ON CV. location = CD.location
	AND CV.date = CD.date
WHERE CD.continent IS NOT NULL
)
SELECT *, (new_vaccinations_per_day/population)*100 FROM CTEVac

--TEMP Table
DROP TABLE IF EXISTS #PercentPopulationVaccinated
CREATE TABLE #PercentPopulationVaccinated
(
	continent varchar(255),
	location varchar(255),
	date datetime,
	population float,
	new_vaccinations float,
	new_vaccinations_per_day float,
)

INSERT INTO #PercentPopulationVaccinated
SELECT CD.continent, CD.location, CD.date, CD.population, CV.new_vaccinations,
SUM(CV.new_vaccinations) OVER (PARTITION BY CD.location ORDER BY CD.location, CD.date) AS New_Vaccinations_Per_Day
FROM CovidVaccine AS CV
INNER JOIN CovidDeath AS CD
	ON CV. location = CD.location
	AND CV.date = CD.date
WHERE CD.continent IS NOT NULL
--ORDER BY 1,2,3

SELECT *, (new_vaccinations_per_day/population)*100 FROM #PercentPopulationVaccinated

-- View for PercentPopulationVaccinated

CREATE VIEW PercentVaccinated AS 
SELECT CD.continent, CD.location, CD.date, CD.population, CV.new_vaccinations,
SUM(CV.new_vaccinations) OVER (PARTITION BY CD.location ORDER BY CD.location, CD.date) AS New_Vaccinations_Per_Day
FROM CovidVaccine AS CV
INNER JOIN CovidDeath AS CD
	ON CV. location = CD.location
	AND CV.date = CD.date
WHERE CD.continent IS NOT NULL
