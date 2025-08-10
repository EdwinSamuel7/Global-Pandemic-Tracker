# Global Pandemic Tracker: Cases, Death Toll, and Trends by Region

## 📌 Overview
- This *Tableau* dashboard offers a comprehensive analysis of COVID-19 data that was explored and structured in *SQL*. <br>
- The dashboard provides a detailed examination of global cases, mortality statistics, and infection trends over time. <br>
- The *SQL* analysis done before Tableau focuses on  infection rates, death percentages, vaccination trends, and country-specific insights. The queries demonstrate advanced SQL techniques like **window functions, CTEs, temporary tables, and views**.

## Interactive Dashboard:

**Click the dashboard to explore the interactive version | Scroll down to see the SQL commands** <br>

[![Pandemic Dashboard](https://github.com/edwin-samuel-giftson/My-Projects/blob/main/My%20Projects/Global-Pandemic-Tracker/Pandemic-Tracker-Dashboard.png?raw=true)](https://public.tableau.com/app/profile/edwinsamuel7/viz/Covid-Dashboard_from-sql/Dashboard1)
​
## Key highlights
- **Global Overview:** An interactive map visualizes the geographical spread of infection rates by country, highlighting regions with the highest case counts and mortality rates.
- **Mortality Analysis:** Comparative mortality statistics across different continents showcase the variation in death tolls and case fatality rates.
- **Infection Trends:** Dynamic line charts and bar graphs depict infection trends over time, enabling users to observe the rise and fall of cases in various regions.
- **Continental Comparison:** Detailed breakdowns of COVID-19 impacts on different continents, including case counts, deaths, and recovery rates.

## 🔍 Key Analyses Performed using SQL

#### 1. Global Totals & Death Percentage
```sql
-- Calculates total global cases, total global deaths, and the death percentage for all recorded cases.
SELECT 
    SUM(new_cases) AS total_cases, 
    SUM(CAST(new_deaths AS INT)) AS total_deaths, 
    SUM(CAST(new_deaths AS INT)) / SUM(new_cases) * 100 AS DeathPercentage
FROM coviddeaths
WHERE continent IS NOT NULL
ORDER BY 1, 2;
```

#### 2. Death Count by Continents / Regions
```sql
SELECT 
    location, 
    SUM(CAST(new_deaths AS INT)) AS TotalDeathCount
FROM coviddeaths
WHERE continent IS NULL
  AND location NOT IN ('World', 'European Union', 'International')
GROUP BY location
ORDER BY TotalDeathCount DESC;
```

#### 3. Highest Infection Rates by Country
```sql
-- Finds countries with the highest percentage of their population infected over the recorded period.
SELECT 
    Location, Population, 
    MAX(total_cases) AS HighestInfectionCount,  
    MAX((total_cases / population)) * 100 AS PercentPopulationInfected
FROM coviddeaths
GROUP BY Location, Population
ORDER BY PercentPopulationInfected DESC;
```

#### 4. Highest Infection Rates by Country & Date
```sql
SELECT 
    Location, Population, date,
    MAX(total_cases) AS HighestInfectionCount,  
    MAX((total_cases / population)) * 100 AS PercentPopulationInfected
FROM coviddeaths
GROUP BY Location, Population, date
ORDER BY PercentPopulationInfected DESC;
```

#### 5. Likelihood of Death (Case Fatality Rate)
```sql
-- Calculates the daily death percentage for a specific country (Germany in this example).
SELECT 
    location, date, total_cases, total_deaths, 
    (total_deaths / total_cases) * 100 AS DeathPercent
FROM coviddeaths
WHERE location ILIKE '%germany%'
  AND continent IS NOT NULL
ORDER BY 1, 2;
```

#### 6. Population Infection Percentage (by Date)
```sql
-- Tracks the percentage of population diagnosed with COVID‑19 per location over time.
SELECT 
    location, date, population, total_cases, 
    (total_cases / population) * 100 AS PercentDiagnosed
FROM coviddeaths
ORDER BY location, date;
```

#### 7. Highest Death Rate by Country
```sql
SELECT 
    location, 
    MAX(total_deaths) AS HighestDeathCount, 
    MAX((total_deaths / total_cases) * 100) AS death_rate
FROM coviddeaths
GROUP BY location
ORDER BY death_rate DESC;
```

#### 8. Death Rate Till Date
```sql
SELECT 
    location, 
    MAX(total_cases) AS total_cases_till_date, 
    MAX(total_deaths) AS total_deaths_till_date, 
    (MAX(total_deaths) / MAX(total_cases)) AS death_rate_till_date
FROM coviddeaths
GROUP BY location
ORDER BY death_rate_till_date DESC;
```

#### 9. Rolling Sum of Vaccinations
```sql
-- Tracks cumulative vaccinations given over time in each location.
SELECT 
    dea.location, dea.date, dea.population,
    vac.new_vaccinations,
    SUM(CAST(vac.new_vaccinations AS INT)) OVER (
        PARTITION BY dea.location 
        ORDER BY dea.date
    ) AS rolling_vaccinations
FROM coviddeaths dea
JOIN covidvaccinations vac
  ON dea.location = vac.location
 AND dea.date = vac.date
WHERE dea.continent IS NOT NULL
ORDER BY location, date;
```

#### 10. Rolling Vaccination Percent — Method 1 (CTE)
```sql
WITH roll_vac AS (
    SELECT 
        dea.location, dea.date, dea.population,
        vac.new_vaccinations,
        SUM(CAST(vac.new_vaccinations AS INT)) OVER (
            PARTITION BY dea.location 
            ORDER BY dea.date
        ) AS rolling_vaccinations
    FROM coviddeaths dea
    JOIN covidvaccinations vac
      ON dea.location = vac.location
     AND dea.date = vac.date
    WHERE dea.continent IS NOT NULL
    ORDER BY location, date
)
SELECT *,
       (rolling_vaccinations / population) * 100 AS rolling_vaccinations_percent
FROM roll_vac;
```

#### 11. Rolling Vaccination Percent — Method 2 (Temporary Table)
```sql
DROP TABLE IF EXISTS roll_vac2;

CREATE TEMPORARY TABLE roll_vac2 (
    location VARCHAR(255),
    pate DATE,
    population NUMERIC,
    new_vaccinations NUMERIC,
    rolling_vaccinations NUMERIC
);

INSERT INTO roll_vac2
SELECT 
    dea.location, dea.date, dea.population,
    vac.new_vaccinations,
    SUM(CAST(vac.new_vaccinations AS INT)) OVER (
        PARTITION BY dea.location 
        ORDER BY dea.date
    ) AS rolling_vaccinations
FROM coviddeaths dea
JOIN covidvaccinations vac
  ON dea.location = vac.location
 AND dea.date = vac.date
WHERE dea.continent IS NOT NULL
ORDER BY location, date;

SELECT *,
       (rolling_vaccinations / population) * 100 AS rolling_vaccinations_percent
FROM roll_vac2;
```

#### 12. Rolling Vaccination Percent — Method 3 (Subquery)
```sql
SELECT *,
       (rolling_vaccinations / population) * 100 AS rolling_vaccinations_percent
FROM (
    SELECT 
        dea.location, dea.date, dea.population,
        vac.new_vaccinations,
        SUM(CAST(vac.new_vaccinations AS INT)) OVER (
            PARTITION BY dea.location 
            ORDER BY dea.date
        ) AS rolling_vaccinations
    FROM coviddeaths dea
    JOIN covidvaccinations vac
      ON dea.location = vac.location
     AND dea.date = vac.date
    WHERE dea.continent IS NOT NULL
    ORDER BY location, date
) ;
```

#### 13. View for Rolling Vaccinations
```sql
CREATE VIEW RollingVaccinations AS
SELECT 
    dea.location, dea.date, dea.population,
    vac.new_vaccinations,
    SUM(CAST(vac.new_vaccinations AS INT)) OVER (
        PARTITION BY dea.location 
        ORDER BY dea.date
    ) AS rolling_vaccinations
FROM coviddeaths dea
JOIN covidvaccinations vac
  ON dea.location = vac.location
 AND dea.date = vac.date
WHERE dea.continent IS NOT NULL
ORDER BY location, date;

SELECT * FROM RollingVaccinations;
```

## 🛠 Techniques Used
- Aggregate functions: SUM, MAX, CAST
- Window functions: SUM() OVER (PARTITION BY … ORDER BY …)
- Common Table Expressions (CTEs)
- Temporary tables
- Views
- Filtering logic to exclude aggregate rows (continent IS NULL/NOT NULL)
- Custom percentage calculations

## 📊 Insights Possible
- Global and country‑level mortality rate
- Peak infection rates per country, both absolute and percentage
- Cumulative and percentage vaccination progress
- Country comparison by infection and death severity

<!--
## Tools and Technologies
- **SQL:** Initially data was explored in SQL and structured into different tables.
- **Tableau:** Used for data visualization and creating an interactive dashboard.
- **Data Analysis:** Performed comprehensive data analysis to derive insights and trends from the dataset.
- **Data Visualization:** Utilized various visualization techniques including line charts, bar charts, tables and geography maps to represent data effectively.

## Dashboad:

![image](https://github.com/edwin-samuel-giftson/My-Projects/blob/main/My%20Projects/Global-Pandemic-Tracker/Pandemic-Tracker-Dashboard.png?raw=true)

-->
