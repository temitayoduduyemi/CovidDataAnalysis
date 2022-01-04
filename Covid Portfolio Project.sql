--I selected the data that I will be using

select location, date, total_cases, new_cases, total_deaths, population
from PortfolioProject..CovidDeaths

--Taking a look at the total cases versus the total death
select location, date, total_cases, total_deaths, round((total_deaths/total_cases)*100,2) as percentage_death_cases, (total_cases - total_deaths) as  rate_death
from PortfolioProject..CovidDeaths

--Checking rate of death in United States
select location, date, total_cases, total_deaths, round((total_deaths/total_cases)*100,2) as percentage_death_cases, (total_cases - total_deaths) as  rate_death
from PortfolioProject..CovidDeaths
where location like '%states%'

--Checking rate of death in Africa
select location, date, total_cases, total_deaths, round((total_deaths/total_cases)*100,2) as percentage_death_cases, (total_cases - total_deaths) as  rate_death
from PortfolioProject..CovidDeaths
where location like '%africa%'

--Looking at the population versus total cases i.e what percentage of the population was infected
select location, date, population, total_cases, round((total_cases/population)*100,2) as percentage_death_population, (total_cases - total_deaths) as  rate_death
from PortfolioProject..CovidDeaths
where location like '%states%'

--Looking at the population versus total cases in Africa i.e what percentage of the population was infected
select location, date, population, total_cases, round((total_cases/population)*100,2) as percentage_death_population, (total_cases - total_deaths) as  rate_death
from PortfolioProject..CovidDeaths
where location like '%africa%'
order by location

--Looking at the country with the highest and lowest infection rate compared to population.
select location, population, MAX(total_cases) as Highest_infected, Max ((total_cases/population))*100 as percent_Infected_population
from PortfolioProject..CovidDeaths
Group by location, population
order by percent_Infected_population desc

-- converting total_death to bigint. int does not work because the sum exceeded 2,147,483,647
--select SUM(cast(total_deaths as bigint)) as total
--from PortfolioProject..CovidDeaths


--Showing the countries with the highest death count per population
select location,population, MAX(cast(total_deaths as bigint)) as TotalDeathCount
From PortfolioProject..CovidDeaths
where continent is not null
Group by location, population
order by TotalDeathCount desc

--Showing the continents with the hightest and lowest death counts.
select continent, MAX(cast(total_deaths as bigint)) as TotalDeathCount
From PortfolioProject..CovidDeaths
where continent is not null
Group by continent
order by TotalDeathCount desc

--Grouping total cases and total death globally by date
select date, SUM(new_cases) as total_cases, SUM(cast(new_deaths as bigint)) as total_death, SUM(cast(new_deaths as bigint))/ SUM(new_cases )*100 as DeathPercentage
from PortfolioProject..CovidDeaths
--where location like '%states%'
where continent is not null
group by date
order by 1,2


select SUM(new_cases) as total_cases, SUM(cast(new_deaths as bigint)) as total_death, SUM(cast(new_deaths as bigint))/ SUM(new_cases )*100 as DeathPercentage
from PortfolioProject..CovidDeaths
--where location like '%states%'
where continent is not null
--group by date
order by 1,2


--Joining both tables
select *
from PortfolioProject..CovidDeaths 
join PortfolioProject..CovidVaccinations 
	on CovidDeaths.location = CovidVaccinations.location
	and CovidDeaths.date = CovidVaccinations.date


select CovidDeaths.continent, CovidDeaths.location, CovidDeaths.date, CovidDeaths.population,CovidVaccinations.new_vaccinations
from PortfolioProject..CovidDeaths 
join PortfolioProject..CovidVaccinations 
	on CovidDeaths.location = CovidVaccinations.location
	and CovidDeaths.date = CovidVaccinations.date
where CovidDeaths.continent is not null
order by 2,3

Select CovidDeaths.continent, CovidDeaths.location, CovidDeaths.population, CovidVaccinations.new_vaccinations, SUM(cast(CovidVaccinations.new_vaccinations as bigint))OVER (Partition by CovidDeaths.location order by CovidDeaths.location, CovidDeaths.date) as RollingPeopleVaccinated
from PortfolioProject..CovidDeaths 
join PortfolioProject..CovidVaccinations 
	on CovidDeaths.location = CovidVaccinations.location
	and CovidDeaths.date = CovidVaccinations.date
where CovidDeaths.continent is not null
order by 2,3


