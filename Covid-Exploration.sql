-- 1

Select SUM(new_cases) as total_cases, SUM(cast(new_deaths as int)) as total_deaths, SUM(cast(new_deaths as int))/SUM(New_Cases)*100 as DeathPercentage
From coviddeaths
--Where location like '%states%'
where continent is not null 
--Group By date
order by 1,2


--2

Select location, SUM(cast(new_deaths as int)) as TotalDeathCount
From coviddeaths
--Where location like '%states%'
Where continent is null 
and location not in ('World', 'European Union', 'International')
Group by location
order by TotalDeathCount desc


--3

Select Location, Population, MAX(total_cases) as HighestInfectionCount,  Max((total_cases/population))*100 as PercentPopulationInfected
From coviddeaths
--Where location like '%states%'
Group by Location, Population
order by PercentPopulationInfected desc


--4

Select Location, Population,date, MAX(total_cases) as HighestInfectionCount,  Max((total_cases/population))*100 as PercentPopulationInfected
From coviddeaths
--Where location like '%states%'
Group by Location, Population, date
order by PercentPopulationInfected desc



/*
-- INITIAL VIEW OF COLUMNS

select * 
from coviddeaths
where continent is not null
order by location , date;


-- IMPORTANT COLUMNS TO CONSIDER AND WORK ON

select location , date , total_cases , new_cases , total_deaths , population
from coviddeaths
where continent is not null
order by location ,  date;


-- HOW LIKELY IS A PERSON TO DIE
-- CAN FILTER ON A SPECIFIC LOCATION

select location , date , total_cases ,total_deaths, (total_deaths/total_cases)*100 as DeathPercent
from coviddeaths
where location ilike '%germany%'
and continent is not null
order by 1 , 2;


-- WHAT PERCENT OF THE TOTAL POPULATION WAS DIAGNOSED WITH COVID
-- CAN FILTER ON A SPECIFIC LOCATION

select location , date , population , total_cases , (Total_cases/population)*100 as PercentDiagnosed
from coviddeaths
-- where location ilike '%germany%'
order by location , date;


-- HIGHEST ALL TIME RECORD OF INFECTION COUNT & INFECTION PERCENT BY COUNTRIES

select location , max(total_cases) as HighestInfectionCount , max((total_cases/population)*100) as PercentPopulationInfected
from coviddeaths
group by location
order by PercentPopulationInfected desc;


-- HIGHEST ALL TIME RECORD OF DEATH COUNT & DEATH RATE BY COUNTRIES

select location , max(total_deaths) as HighestDeathCount , max((total_deaths/total_cases)*100) as death_rate
from coviddeaths
-- where location ilike '%germany%'
group by location
order by death_rate desc;


-- DEATH RATE BY COUNTRIES TILL DATE

select location , max(total_cases) as total_cases_till_date , max(total_deaths) as total_deaths_till_date , (max(total_deaths)/max(total_cases)) as death_rate_till_date
from coviddeaths
group by location
order by death_rate_till_date desc;


-- alternate method

select location , sum(new_cases) as total_cases_till_date , sum(new_deaths) as total_deaths_till_date , (sum(new_deaths)/sum(new_cases)) as death_rate_till_date
from coviddeaths
group by location
order by death_rate_till_date desc;


-- COUNTRIES WITH HIGHEST DEATH RATES BY DATE FROM LATEST TO EARLIEST

SELECT date, location,total_deaths,total_cases,DeathPercent
FROM (
    SELECT 
        date, 
        location,
		total_deaths,
		total_cases,
        (total_deaths/ total_cases) * 100 AS DeathPercent
    FROM 
        coviddeaths
    WHERE 
        continent IS NOT NULL
) subquery
WHERE 
    DeathPercent IS NOT NULL
ORDER BY 
	date desc,
    DeathPercent DESC;
	
	



-- ROLLING SUM OF VACCINATIONS

select dea.location,dea.date,dea.population,vac.new_vaccinations,
sum(cast(vac.new_vaccinations as int)) over (partition by dea.location order by dea.date) as rolling_vaccinations
from coviddeaths dea
join covidvaccinations vac
on dea.location = vac.location
and dea.date = vac.date
where dea.continent is not null
order by location,date;



-- PERCENT OF ROLLING SUM OF VACCINATIONS

-- method 1 (using CTE)

with roll_vac (location , date , population , new_vaccinations , rolling_vaccinations)
as
(
select dea.location,dea.date,dea.population,vac.new_vaccinations,
sum(cast(vac.new_vaccinations as int)) over (partition by dea.location order by dea.date) as rolling_vaccinations
from coviddeaths dea
join covidvaccinations vac
on dea.location = vac.location
and dea.date = vac.date
where dea.continent is not null
order by location,date
)
select * , (rolling_vaccinations/population)*100 as rolling_vaccinations_percent
from roll_vac;


-- method 2 (using temporary table)

DROP Table if exists roll_vac2;

create temporary table roll_vac2
(
location varchar(255),
pate date,
population numeric,
new_vaccinations numeric,
rolling_vaccinations numeric
);

insert into roll_vac2
select dea.location,dea.date,dea.population,vac.new_vaccinations,
sum(cast(vac.new_vaccinations as int)) over (partition by dea.location order by dea.date) as rolling_vaccinations
from coviddeaths dea
join covidvaccinations vac
on dea.location = vac.location
and dea.date = vac.date
where dea.continent is not null
order by location,date;

select * , (rolling_vaccinations/population)*100 as rolling_vaccinations_percent
from roll_vac2;


-- method 3 (using subquery)

select * , (rolling_vaccinations/population)*100 as rolling_vaccinations_percent
from 
(
select dea.location,dea.date,dea.population,vac.new_vaccinations,
sum(cast(vac.new_vaccinations as int)) over (partition by dea.location order by dea.date) as rolling_vaccinations
from coviddeaths dea
join covidvaccinations vac
on dea.location = vac.location
and dea.date = vac.date
where dea.continent is not null
order by location,date
);
-- subquery keyword optional





-- VIEW OF ROLLING SUM OF VACCINATIONS
-- just the sum , not percent

create view RollingVaccinations as
select dea.location,dea.date,dea.population,vac.new_vaccinations,
sum(cast(vac.new_vaccinations as int)) over (partition by dea.location order by dea.date) as rolling_vaccinations
from coviddeaths dea
join covidvaccinations vac
on dea.location = vac.location
and dea.date = vac.date
where dea.continent is not null
order by location,date;


select * from RollingVaccinations;
*/