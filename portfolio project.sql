select *
from portfolioproject..CovidDeaths$
where continent is not null
order by 3,4

select *
from portfolioproject..CovidVaccinations$
order by 3,4

select  location, date, total_cases, new_cases, total_deaths, population
from portfolioproject..CovidDeaths$
order by 1,2

--loking at total cases vs total death

select  location, date, total_cases, total_deaths,(total_deaths/total_cases)*100 as deathpercentage
from portfolioproject..CovidDeaths$
where location like '%states%'
order by 1,2 

--looking at the total cases vs population

select  location, date,population, total_cases, (total_cases/population)*100 as percentagepupulation
from portfolioproject..CovidDeaths$
where location like '%states%'
order by 1,2 


--highest infected countries compared to population

select location, population, continent, max(total_cases) as highestinfectioncount, max((total_cases/population))*100 percentageinfected
from portfolioproject..CovidDeaths$
where continent is not null
group by location, population, continent
order by percentageinfected desc

--showing continent with highest death count per population

select continent, max(cast(total_deaths as int)) as totaldeathcount
from portfolioproject..CovidDeaths$
where continent is not null
group by continent
order by totaldeathcount desc

--global number

select sum(new_cases) as total_cases,sum(cast(new_deaths as int)) as total_deaths,
sum(cast(new_deaths as int))/sum(new_cases)*100 as deathpercentage
from portfolioproject..CovidDeaths$
where continent is not null
--group by date
order by 1,2

--looking at total population vs vaccination

--using cte

with popvsvac (continent, location, date, population, new_vaccinations, rollingpeoplevaccination)
as
(
select dea.continent, dea.location, dea.date, dea.population, vac.new_vaccinations,
sum(convert(int,vac.new_vaccinations)) over (partition by dea.location order by dea.location, dea.date) as rollingpeoplevaccination
from portfolioproject..CovidVaccinations$ as vac
join portfolioproject..CovidDeaths$ as dea
on dea.date = vac.date
and dea.location= vac.location
where dea.continent is not null
--order by 2,3
)
select *, (rollingpeoplevaccination/population)*100 as percentpopulationvaccinated
from popvsvac
 

 --create temp table

 drop table if exists #percentagepopulationvaccination
 create table  #percentagepopulationvaccination
 (
 continent nvarchar (255),
 location nvarchar (255),
 date datetime,
 population numeric,
 new_vaccinations numeric,
 rollingpeoplevaccination numeric,
 )
 
 insert into #percentagepopulationvaccination
 select dea.continent, dea.location, dea.date, dea.population, vac.new_vaccinations,
sum(convert(int,vac.new_vaccinations)) over (partition by dea.location order by dea.location, dea.date) as rollingpeoplevaccination
from portfolioproject..CovidVaccinations$ as vac
join portfolioproject..CovidDeaths$ as dea
on dea.date = vac.date
and dea.location= vac.location
where dea.continent is not null
--order by 2,3

select *
from #percentagepopulationvaccination


--creating data for view store data later visualization

create view percentagepopulationvaccinated
as
select dea.continent, dea.location, dea.date, dea.population, vac.new_vaccinations,
sum(convert(int,vac.new_vaccinations)) over (partition by dea.location order by dea.location, dea.date) as rollingpeoplevaccination
from portfolioproject..CovidVaccinations$ as vac
join portfolioproject..CovidDeaths$ as dea
on dea.date = vac.date
and dea.location= vac.location
--where dea.continent is not null
--order by 2,3

select *
from percentagepopulationvaccinated





