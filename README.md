# Global COVID-19 Tracker: Cases, Death Toll, and Trends by Region

## 📌 Overview
This Tableau dashboard offers a comprehensive analysis of COVID-19 data, explored and structured in SQL. The dashboard provides a detailed examination of global cases, mortality statistics, and infection trends over time. The SQL analysis done before Tableau focuses on  infection rates, death percentages, vaccination trends, and country-specific insights. The queries demonstrate advanced SQL techniques like **window functions, CTEs, temporary tables, and views**.

## Dashboad:

![image](https://github.com/edwin-samuel-giftson/My-Projects/blob/main/My%20Projects/Global-Pandemic-Tracker/Pandemic-Tracker-Dashboard.png?raw=true)
​
## Key highlights
- **Global Overview:** An interactive map visualizes the geographical spread of infection rates by country, highlighting regions with the highest case counts and mortality rates.
- **Mortality Analysis:** Comparative mortality statistics across different continents showcase the variation in death tolls and case fatality rates.
- **Infection Trends:** Dynamic line charts and bar graphs depict infection trends over time, enabling users to observe the rise and fall of cases in various regions.
- **Continental Comparison:** Detailed breakdowns of COVID-19 impacts on different continents, including case counts, deaths, and recovery rates.

## 🔍 Key Analyses Performed using SQL

#### 1. Global Metrics
```sql
-- Total cases, deaths, and death percentage worldwide
SELECT SUM(new_cases) AS total_cases, 
       SUM(CAST(new_deaths AS INT)) AS total_deaths, 
       SUM(CAST(new_deaths AS INT))/SUM(new_cases)*100 AS death_percentage
FROM coviddeaths
WHERE continent IS NOT NULL;
```

#### 2. Continent-Level Death Analysis
```sql
-- Total deaths by continent (excluding aggregates like 'World')
SELECT location, SUM(CAST(new_deaths AS INT)) AS total_death_count
FROM coviddeaths
WHERE continent IS NULL 
  AND location NOT IN ('World', 'European Union', 'International')
GROUP BY location
ORDER BY total_death_count DESC;
```

#### 3. Infection Hotspots
```sql
-- Countries with highest infection rates relative to population
SELECT location, population, 
       MAX(total_cases) AS highest_infection_count,  
       MAX((total_cases/population))*100 AS percent_population_infected
FROM coviddeaths
GROUP BY location, population
ORDER BY percent_population_infected DESC;
```

#### 4. Vaccination Trends

Demonstrated three methods to calculate rolling vaccination percentages:

- CTEs
- Temporary Tables
- Subqueries

```sql
-- Using CTE to calculate vaccination progress over time
WITH roll_vac AS (
  SELECT dea.location, dea.date, dea.population, vac.new_vaccinations,
         SUM(CAST(vac.new_vaccinations AS INT)) OVER (PARTITION BY dea.location ORDER BY dea.date) AS rolling_vaccinations
  FROM coviddeaths dea
  JOIN covidvaccinations vac ON dea.location = vac.location AND dea.date = vac.date
  WHERE dea.continent IS NOT NULL
)
SELECT *, (rolling_vaccinations/population)*100 AS rolling_vaccinations_percent
FROM roll_vac;
```

## 🛠 Technical Highlights
- **Complex Joins:** Linked `coviddeaths` and `covidvaccinations` tables
- **Advanced SQL Features:**
  - Window functions (`OVER PARTITION BY`) for rolling calculations
  - Multiple approaches to solve the same problem (CTEs vs. temp tables)
  - Created reusable database views
- **Data Quality Checks:** Handled NULL values and excluded aggregate regions

<!--
## Tools and Technologies
- **SQL:** Initially data was explored in SQL and structured into different tables.
- **Tableau:** Used for data visualization and creating an interactive dashboard.
- **Data Analysis:** Performed comprehensive data analysis to derive insights and trends from the dataset.
- **Data Visualization:** Utilized various visualization techniques including line charts, bar charts, tables and geography maps to represent data effectively.

## Dashboad:

![image](https://github.com/edwin-samuel-giftson/My-Projects/blob/main/My%20Projects/Global-Pandemic-Tracker/Pandemic-Tracker-Dashboard.png?raw=true)

-->
