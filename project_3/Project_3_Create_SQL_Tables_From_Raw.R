# To create a table of unique skills and assign IDs. For use as lookup table in Project_3 schema.
# Original table listed skills by job_posting_ID as VERY long strings of skills separated by commas

# This codes parses that list of skills for each posting and creates a normalized table 
# to be linked back to job posting by a new skill_id key

# Also creates df_skills_melt, which retains the position # of each skill in each job posting: Fares
# wanted to look at these patterns

# to export: tbl_skills_master, tmp_tbl_skills_w_count for validations, df_skills_melt (stores position of each skill in each posting)

library (tidyverse)
library (dplyr)
library (DBI)
library (RMySQL)

#-------- Create database connection to project_team_3 schema

db_con <- dbConnect(MySQL(),user='mazzaa',password='V7K-hU9z',dbname='project_3_team',host='data607-afox03.mysql.database.azure.com')

#-------- Create Job Skills dataframe: # SELECT * FROM job_skills 
# db_res <- dbSendQuery(db_con,paste0("SELECT * FROM `project_3_team`.job_skills;"))
# df_skills<-fetch(db_res,n=-1)


# Import raw postings from github (note - these were lightly cleaned  for rogue commas and invalid characters)

df_job_posting_raw <- read_csv("https://raw.githubusercontent.com/unsecuredAMRAP/607pr3/main/raw_job_postings.csv")

df_job_posting_work <- df_job_posting_raw %>% 
  select(posting_id = id_simple,
         URL = job_link,
         first_seen = first_seen,
         last_processed = last_processed_time,
         title_desc = job_title,
         company_desc = company,
         location_raw = job_location,
         city_desc = search_city,
         country_desc = search_country,
         search_pos_desc = search_position,
         job_level_desc = job_level,
         onsite_flag_desc = job_type
  )


#-------- Create all lookup tables and unique keys for each, add key to job_postings table

# Title
df_title <- df_job_posting_work %>% 
  distinct(title_desc) 

df_title <- df_title %>% 
  mutate(title_id = 1:nrow(df_title))

df_title <- df_title[,c(2,1)]

df_job_posting_work <- mutate(left_join(df_job_posting_work,df_title,by = "title_desc"))

# Company
df_company <- df_job_posting_work %>% 
  distinct(company_desc) 

df_company <- df_company %>% 
  mutate(company_id = 1:nrow(df_company))

df_company <- df_company[,c(2,1)]

df_job_posting_work <- mutate(left_join(df_job_posting_work,
                                        df_company,
                                        by = "company_desc"))

# City
df_city <- df_job_posting_work %>% 
  distinct(city_desc) 

df_city <- df_city %>% 
  mutate(city_id = 1:nrow(df_city))

df_city <- df_city[,c(2,1)]

df_job_posting_work <- mutate(left_join(df_job_posting_work,
                                        df_city,
                                        by = "city_desc"))

# country
df_country <- df_job_posting_work %>% 
  distinct(country_desc) 

df_country <- df_country %>% 
  mutate(country_id = 1:nrow(df_country))

df_country <- df_country[,c(2,1)]

df_job_posting_work <- mutate(left_join(df_job_posting_work,
                                        df_country,
                                        by = "country_desc"))

# search_position (appears to group job titles)
df_search_pos <- df_job_posting_work %>% 
  distinct(search_pos_desc) 

df_search_pos <- df_search_pos %>% 
  mutate(search_pos_id = 1:nrow(df_search_pos))

df_search_pos <- df_search_pos[,c(2,1)]

df_job_posting_work <- mutate(left_join(df_job_posting_work,
                                        df_search_pos,
                                        by = "search_pos_desc"))

# job_level
df_job_level <- df_job_posting_work %>% 
  distinct(job_level_desc) 

df_job_level <- df_job_level %>% 
  mutate(job_level_id = 1:nrow(df_job_level))

df_job_level <- df_job_level[,c(2,1)]

df_job_posting_work <- mutate(left_join(df_job_posting_work,
                                        df_job_level,
                                        by = "job_level_desc"))

# onsite_flag
df_onsite_flag <- df_job_posting_work %>% 
  distinct(onsite_flag_desc) 

df_onsite_flag <- df_onsite_flag %>% 
  mutate(onsite_flag_id = 1:nrow(df_onsite_flag))

df_onsite_flag <- df_onsite_flag[,c(2,1)]

df_job_posting_work <- mutate(left_join(df_job_posting_work,
                                        df_onsite_flag,
                                        by = "onsite_flag_desc"))


str(df_job_posting_work)  
summary(df_job_posting_work)

# Create job_posting normalized table with keys

df_job_posting <- df_job_posting_work %>% 
  select(posting_id,
         URL,
         first_seen,
         last_processed,
         title_id,
         company_id,
         location_raw,
         city_id,
         country_id,
         search_pos_id,
         job_level_id,
         onsite_flag_id
         )




#-------- Parse comma delimited list of skills into columns: 

# NOTE I capped this at 200 skills; 32 positions had more than 200


# Import skills by posting from github (note - these were lightly cleaned for rogue commas and invalid characters)

df_job_skills_raw <- read_csv("https://raw.githubusercontent.com/unsecuredAMRAP/607pr3/main/raw_job_skills2.csv")


df_skills_work <- df_job_skills_raw %>% 
  separate_wider_delim(job_skills, delim=",",names=c("Skill_1","Skill_2","Skill_3","Skill_4","Skill_5",
                                                     "Skill_6","Skill_7","Skill_8","Skill_9","Skill_10",
                                                     "Skill_11","Skill_12","Skill_13","Skill_14","Skill_15",
                                                     "Skill_16","Skill_17","Skill_18","Skill_19","Skill_20",
                                                     "Skill_21","Skill_22","Skill_23","Skill_24","Skill_25",
                                                     "Skill_26","Skill_27","Skill_28","Skill_29","Skill_30",
                                                     "Skill_31","Skill_32","Skill_33","Skill_34","Skill_35",
                                                     "Skill_36","Skill_37","Skill_38","Skill_39","Skill_40",
                                                     "Skill_41","Skill_42","Skill_43","Skill_44","Skill_45",
                                                     "Skill_46","Skill_47","Skill_48","Skill_49","Skill_50",
                                                     "Skill_51","Skill_52","Skill_53","Skill_54","Skill_55",
                                                     "Skill_56","Skill_57","Skill_58","Skill_59","Skill_60",
                                                     "Skill_61","Skill_62","Skill_63","Skill_64","Skill_65",
                                                     "Skill_66","Skill_67","Skill_68","Skill_69","Skill_70",
                                                     "Skill_71","Skill_72","Skill_73","Skill_74","Skill_75",
                                                     "Skill_76","Skill_77","Skill_78","Skill_79","Skill_80",
                                                     "Skill_81","Skill_82","Skill_83","Skill_84","Skill_85",
                                                     "Skill_86","Skill_87","Skill_88","Skill_89","Skill_90",
                                                     "Skill_91","Skill_92","Skill_93","Skill_94","Skill_95",
                                                     "Skill_96","Skill_97","Skill_98","Skill_99","Skill_100",
                                                     "Skill_101","Skill_102","Skill_103","Skill_104","Skill_105",
                                                     "Skill_106","Skill_107","Skill_108","Skill_109","Skill_110",
                                                     "Skill_111","Skill_112","Skill_113","Skill_114","Skill_115",
                                                     "Skill_116","Skill_117","Skill_118","Skill_119","Skill_120",
                                                     "Skill_121","Skill_122","Skill_123","Skill_124","Skill_125",
                                                     "Skill_126","Skill_127","Skill_128","Skill_129","Skill_130",
                                                     "Skill_131","Skill_132","Skill_133","Skill_134","Skill_135",
                                                     "Skill_136","Skill_137","Skill_138","Skill_139","Skill_140",
                                                     "Skill_141","Skill_142","Skill_143","Skill_144","Skill_145",
                                                     "Skill_146","Skill_147","Skill_148","Skill_149","Skill_150",
                                                     "Skill_151","Skill_152","Skill_153","Skill_154","Skill_155",
                                                     "Skill_156","Skill_157","Skill_158","Skill_159","Skill_160",
                                                     "Skill_161","Skill_162","Skill_163","Skill_164","Skill_165",
                                                     "Skill_166","Skill_167","Skill_168","Skill_169","Skill_170",
                                                     "Skill_171","Skill_172","Skill_173","Skill_174","Skill_175",
                                                     "Skill_176","Skill_177","Skill_178","Skill_179","Skill_180",
                                                     "Skill_181","Skill_182","Skill_183","Skill_184","Skill_185",
                                                     "Skill_186","Skill_187","Skill_188","Skill_189","Skill_190",
                                                     "Skill_191","Skill_192","Skill_193","Skill_194","Skill_195",
                                                     "Skill_196","Skill_197","Skill_198","Skill_199","Skill_200"
                                                     ), 
                       too_many = "drop",
                       too_few = "align_start")

head(df_skills_work)

#-------- Melt skills and remove white spaces

df_skills_melt <- df_skills_work %>% 
  pivot_longer(-c(ID_simple),
               names_to = "skill_order", 
               values_to = "skill_name",
               values_drop_na = TRUE,)

df_skills_melt$skill_name <- str_trim(df_skills_melt$skill_name)

#-------- Create skills master table - Group skills and assign IDs, hold temp table w counts

df_temp_skills_w_count <- df_skills_melt %>% 
  group_by(skill_name) %>% 
  summarize(n=n()) 

df_skills_master <- df_temp_skills_w_count %>% 
  select(-n)

df_skills_master <- df_skills_master %>% 
  mutate(Skill_ID = 1:nrow(df_skills_master))

df_skills_master <- df_skills_master[,c(2,1)]


head(df_skills_master)

#-------- Create table of skills where n>50
# temp_tbl_skills_w_count_50 <- temp_tbl_skills_w_count %>% 
#   filter(n>50) 

#----------- Write all to .csv for SQL
write.csv(tbl_skills,"c:/users/amand/Git_Projects/DATA607/Project_3/skill_counts.csv", row.names=FALSE)
