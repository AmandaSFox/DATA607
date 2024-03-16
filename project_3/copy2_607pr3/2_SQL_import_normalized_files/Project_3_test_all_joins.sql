-- This script tests the joins in the new (mostly) normalized tables 

-- ---------------------------------------------------------
-- Link to skills by job_posting (now includes description due to errors with skills_master lookup table joins)
-- ---------------------------------------------------------

select * from tbl_job_posting a
	left join tbl_job_posting_skills_w_desc b
    on a.posting_id = b.posting_id;

-- ---------------------------------------------------------
-- Link to all other description fields    
-- ---------------------------------------------------------

select * from tbl_job_posting a
	left join tbl_city b
    on a.city_id = b.city_id
    left join tbl_country c
    on a.country_id = c.country_id
    left join tbl_company d
    on a.company_id = d.company_id
    left join tbl_job_level e
    on a.job_level_id = e.job_level_id
    left join tbl_onsite_flag f
    on a.onsite_flag_id = f.onsite_flag_id
    left join tbl_search_position g
    on a.search_pos_id = g.search_pos_id
    left join tbl_title h
    on a.title_id = h.title_id;
