-- Objective: create R data frame with country, year, rate (cases/pop)

-- Create tb_case table with total cases by country and year
-- fix nulls in table tb 

select * from tb limit 20

Update tb
set child = 0 
where child is null

update tb
set adult = 0
where adult is null

update tb 
set elderly = 0 
where elderly is null

-- create tb_cases with country, year, and total cases

drop table if exists tb_cases;
create table tb_cases as 
	select country,year,sum(child+adult+elderly) as tot_cases
	from tb
	group by country, year

-- Load population.csv into new table tb.pop using table data import wizard
-- Rename year column to avoid reserved word

ALTER TABLE pop 
RENAME COLUMN Year TO yr

-- identify any country/year pairs missing from each table

select tb.country,tb.yr,pop.country,pop.yr
from tb_cases tb
left join pop 
on tb.country = pop.country and tb.yr = pop.yr
where pop.country is null

select tb.country,tb.yr,pop.country,pop.yr
from pop
left join tb_cases tb
on pop.country = tb.country and pop.yr = tb.yr
where tb.country is null

-- standardize mismatched country names for Cote d'Ivoire

Update pop
set country = 'Cote d Ivoire'
where country like '%te___Ivoire'

Update tb_cases
set country = 'Cote d Ivoire'
where country like 'C_te d_Ivoire'


-- Match using inner join as all records line up and create table with rates

DROP TABLE IF EXISTS tb_rate;
CREATE TABLE tb_rate AS
	select tb.country, tb.yr, tb.tot_cases, pop.population, tb.tot_cases/pop.population as rate
	from tb_cases tb
	left join pop 
		on tb.country = pop.country
		and tb.yr = pop.yr

-- validations - didn't drop any population OR cases

select count(*),sum(tot_cases),sum(population)
from tb_rate
select count(*),sum(tot_cases)
from tb_cases
select count(*),sum(population)
from pop

-- export .csv for import into R

SELECT * 
INTO OUTFILE 'C:/ProgramData/MySQL/MySQL Server 8.0/Uploads/tb_rates.csv'
	FIELDS TERMINATED BY ',' OPTIONALLY ENCLOSED BY '"'
	ESCAPED BY '\\'
	LINES TERMINATED BY '\n'
FROM tb_rate
ORDER BY country, yr;
