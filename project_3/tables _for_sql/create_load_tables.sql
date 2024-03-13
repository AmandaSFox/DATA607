

-- Create job_posting table
drop table if exists job_posting;
create table job_posting (
	ID_simple tinytext,
    job_link longtext,
    last_processed tinytext,
    last_status tinytext,
    got_summary tinytext,
    got_ner tinytext,
    is_being_worked tinytext,
    job_title tinytext,
    company tinytext,
    location tinytext,
    first_seen tinytext,
    search_city tinytext,
    search_country tinytext,
    search_position tinytext,
    job_level tinytext,
    onsite_flag tinytext
);

-- truncate job_posting;
LOAD DATA LOCAL INFILE 'C:/Users/amand/Downloads/project_3_data/job_postings.txt' INTO TABLE job_posting
	IGNORE 1 LINES;

select * from job_posting;

-- -----------------------------------------------------------
-- Create job_skills table
drop table if exists job_skills;

create table job_skills (
	ID_simple tinytext,
    job_link longtext,
    job_skills longtext
);

load data local infile  'C:/Users/amand/Downloads/project_3_data/job_skills2.txt' into table job_skills
    ignore 1 lines;

-- truncate job_skills;

select * from job_skills;

-- -----------------------------------------------------------
-- Create job_summary table: formatted original job postings
-- NOT USED - REMOVED ALL SPECIAL CHARACTERS/FORMATTING, TOO MANY INVALID CHARACTERS/ERRORS. 
-- USE CLEANED FILES: job_skills AND job_posting

drop table if exists job_summary;

create table job_summary (
	ID_simple tinytext,
    job_link longtext,
    job_summary longtext
);

LOAD DATA LOCAL INFILE 'C:/Users/amand/Downloads/project_3_data/job_summary.txt' INTO TABLE job_skills
        IGNORE 1 LINES;

select * from job_summary
