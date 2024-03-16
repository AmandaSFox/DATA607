-- Create tbl_job_posting: one row per job posting

drop table if exists tbl_job_posting;
create table tbl_job_posting (
	posting_id varchar(8) primary key,
    URL longtext,
    first_seen varchar(255),
    last_processed varchar(255),
    title_id varchar(8),
    company_id varchar(8),
    location_id varchar(8),
    city_id varchar(8),
    country_id varchar(8),
    search_position_id varchar(8),
    job_level_id varchar(8),
    onsite_flag_id varchar(8)
	);
load data local infile 'C:/Users/amand/Git_Projects/DATA607/project_3/tbl_job_posting.txt'
into table tbl_job_posting
ignore 1 rows;
select * from tbl_job_posting;
select count(*) from tbl_job_posting;


drop table if exists tbl_job_posting_skills;
create table tbl_job_posting_skills(
	posting_id varchar(8),
    skill_id varchar(8)
	);
load data local infile 'C:/Users/amand/Git_Projects/DATA607/project_3/tbl_job_posting_skills2.txt'
into table tbl_job_posting_skills
ignore 1 rows;
select count(*) from tbl_job_posting_skills;
select * from tbl_job_posting_skills;
-- -----------------------------------------------------------
-- Create all lookup tables

drop table if exists tbl_title;
create table tbl_title (
	title_id varchar(8) primary key,
    title_desc longtext
	);
load data local infile 'C:/Users/amand/Git_Projects/DATA607/project_3/tbl_title.txt'
into table tbl_title
ignore 1 rows;
select * from tbl_title;
select count(*) from tbl_title;


drop table if exists tbl_company;
create table tbl_company (
	company_id varchar(8) primary key,
    company_desc longtext
	);
load data local infile 'C:/Users/amand/Git_Projects/DATA607/project_3/tbl_company.txt'
into table tbl_company
ignore 1 rows;
select * from tbl_company;
select count(*) from tbl_company;


drop table if exists tbl_city;
create table tbl_city (
	city_id varchar(8) primary key,
    city_desc longtext
	);
load data local infile 'C:/Users/amand/Git_Projects/DATA607/project_3/tbl_city.txt'
into table tbl_city
ignore 1 rows;
select * from tbl_city;
select count(*) from tbl_city;


drop table if exists tbl_country;
create table tbl_country (
	country_id varchar(8) primary key,
    country_desc longtext
	);
load data local infile 'C:/Users/amand/Git_Projects/DATA607/project_3/tbl_country.txt'
into table tbl_country
ignore 1 rows;
select * from tbl_country;
select count(*) from tbl_country;


drop table if exists tbl_search_position;
create table tbl_search_position (
	search_pos_id varchar(8) primary key,
    search_pos_desc longtext
	);
load data local infile 'C:/Users/amand/Git_Projects/DATA607/project_3/tbl_search_pos.txt'
into table tbl_search_position
ignore 1 rows;
select * from tbl_search_position;
select count(*) from tbl_search_position;


drop table if exists tbl_job_level;
create table tbl_job_level(
	job_level_pos_id varchar(8) primary key,
    job_level_pos_desc longtext
	);
load data local infile 'C:/Users/amand/Git_Projects/DATA607/project_3/tbl_job_level.txt'
into table tbl_job_level
ignore 1 rows;
select * from tbl_job_level;
select count(*) from tbl_job_level;


drop table if exists tbl_onsite_flag;
create table tbl_onsite_flag(
	onsite_flag_id varchar(8) primary key,
    onsite_flag_desc longtext
	);
load data local infile 'C:/Users/amand/Git_Projects/DATA607/project_3/tbl_onsite_flag.txt'
into table tbl_onsite_flag
ignore 1 rows;
select * from tbl_onsite_flag;

drop table if exists tbl_skills_master;
create table tbl_skills_master(
	skill_id varchar(8),
    skill_desc longtext
	);
load data local infile 'C:/Users/amand/Git_Projects/DATA607/project_3/tbl_skills_master2.txt'
into table tbl_skills_master
ignore 1 rows;
select * from tbl_skills_master;
select count(*) from tbl_skills_master;