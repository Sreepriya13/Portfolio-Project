select * from CovidDeaths
where continent is not null
order by 3,4

select * from CovidVaccinations
order by 3,4

--selecting the data needed
select location,date,total_cases,new_cases,total_deaths,population
from CovidDeaths
where continent is not null
order by 1,2

--Total cases vs deaths
select location,date,total_cases,total_deaths,population,(total_deaths/total_cases)*100 as DeathPercentage
from CovidDeaths
where location = 'India'

order by 1,2

--Totalcases vs Population
select location,date,total_cases,population,(total_cases/population)*100 as PercentageInfected
from CovidDeaths
where location = 'India'
order by 1,2

--Countries with highest infection rate compared to population
select location,max(total_cases) as HighestInfectionRate,population,max((total_cases/population))*100 as PercentagePopulationInfected
from CovidDeaths
where continent is not null
group by location,population
order by PercentagePopulationInfected desc

--Countries with highest death count per population
select location,max(cast(total_deaths as int)) as TotalDeathCount
from CovidDeaths
where continent is not null
group by location
order by TotalDeathCount desc


--Showing continents with highest death count
select continent,max(cast(total_deaths as int)) as TotalDeathCount
from CovidDeaths
where continent is not null
group by continent
order by TotalDeathCount desc

--Global numbers
select date,sum(new_cases) as total_cases,sum(new_deaths)as total_deaths,sum(new_deaths)/sum(new_cases)*100 as DeathPercentage
from CovidDeaths
--where location = 'India'
where continent is not NULL
group by date
order by 1,2

select sum(new_cases) as total_cases,sum(new_deaths)as total_deaths,sum(new_deaths)/sum(new_cases)*100 as DeathPercentage
from CovidDeaths
--where location = 'India'
where continent is not NULL
order by 1,2

select dea.continent,dea.location,dea.date,dea.population,vac.new_vaccinations,
sum(cast(vac.new_vaccinations as float)) over (partition by dea.location order by dea.location,dea.date) as RollingPeopleVaccinated
from CovidDeaths dea
join CovidVaccinations vac
on dea.location=vac.location
and dea.date=vac.date
where dea.continent is not NULL
and vac.new_vaccinations is not null
order BY 2,3

--Using CTE because you cannot use the rollingpeoplevaccinated column you created for further calculaitons

with populationVSvaccination (continent,location,date,population,new_vaccinations,rollingpeoplevaccinated)
as
(
select dea.continent,dea.location,dea.date,dea.population,vac.new_vaccinations,
sum(cast(vac.new_vaccinations as float)) over (partition by dea.location order by dea.location,dea.date) as RollingPeopleVaccinated
from CovidDeaths dea
join CovidVaccinations vac
on dea.location=vac.location
and dea.date=vac.date
where dea.continent is not NULL
and vac.new_vaccinations is not null
--order BY 2,3
)
select *,(rollingpeoplevaccinated/population)*100
from populationVSvaccination


--Temp Table
drop table if exists  #Percentofpopulationvaccinated
create table #Percentofpopulationvaccinated
(
    continent nvarchar(300),
    location NVARCHAR(255),
    date DATETIME,
    population NUMERIC,
    new NUMERIC,
    rollingpeoplevaccinated NUMERIC
)

Insert into #Percentofpopulationvaccinated
select dea.continent,dea.location,dea.date,dea.population,vac.new_vaccinations,
sum(cast(vac.new_vaccinations as float)) over (partition by dea.location order by dea.location,dea.date) as RollingPeopleVaccinated
from CovidDeaths dea
join CovidVaccinations vac
on dea.location=vac.location
and dea.date=vac.date
where dea.continent is not NULL
and vac.new_vaccinations is not null
--order BY 2,3

-- Creating view for future data visualtion

create view Percentofpopulationvaccinated as
select dea.continent,dea.location,dea.date,dea.population,vac.new_vaccinations,
sum(cast(vac.new_vaccinations as float)) over (partition by dea.location order by dea.location,dea.date) as RollingPeopleVaccinated
from CovidDeaths dea
join CovidVaccinations vac
on dea.location=vac.location
and dea.date=vac.date
where dea.continent is not NULL
and vac.new_vaccinations is not null
--order BY 2,3

select * from Percentofpopulationvaccinated