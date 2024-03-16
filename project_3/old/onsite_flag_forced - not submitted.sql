drop table if exists tbl_onsite_flag;
create table tbl_onsite_flag as
SELECT distinct onsite_flag_id
FROM project_3_team.tbl_job_posting;

ALTER TABLE tbl_onsite_flag ADD COLUMN onsite_desc varchar(20);
UPDATE 
  tbl_onsite_flag 
SET onsite_desc = CASE onsite_flag_id 
                  WHEN 1 THEN "On_Site"
                  WHEN 2 THEN "Hybrid"
                  ELSE "Remote"
                END;

