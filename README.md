# Global COVID-19 Tracker: Cases, Death Toll, and Trends by Region

## 📌 Overview
This Tableau dashboard offers a comprehensive analysis of COVID-19 data, explored and structured in SQL. The dashboard provides a detailed examination of global cases, mortality statistics, and infection trends over time. The SQL analysis done before Tableau focuses on  infection rates, death percentages, vaccination trends, and country-specific insights. The queries demonstrate advanced SQL techniques like **window functions, CTEs, temporary tables, and views**.

​
## Key highlights
- **Global Overview:** An interactive map visualizes the geographical spread of infection rates by country, highlighting regions with the highest case counts and mortality rates.
- **Mortality Analysis:** Comparative mortality statistics across different continents showcase the variation in death tolls and case fatality rates.
- **Infection Trends:** Dynamic line charts and bar graphs depict infection trends over time, enabling users to observe the rise and fall of cases in various regions.
- **Continental Comparison:** Detailed breakdowns of COVID-19 impacts on different continents, including case counts, deaths, and recovery rates.

## 🔍 Key Analyses Performed

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


## Tools and Technologies
- **SQL:** Initially data was explored in SQL and structured into different tables.
- **Tableau:** Used for data visualization and creating an interactive dashboard.
- **Data Analysis:** Performed comprehensive data analysis to derive insights and trends from the dataset.
- **Data Visualization:** Utilized various visualization techniques including line charts, bar charts, tables and geography maps to represent data effectively.

## Impact

Enables offers deeper insights into the impact of the pandemic therby empowering informed decision-making in public health




## Dashboad:

![image](https://github.com/edwin-samuel-giftson/My-Projects/blob/main/My%20Projects/Global-Pandemic-Tracker/Pandemic-Tracker-Dashboard.png?raw=true)


