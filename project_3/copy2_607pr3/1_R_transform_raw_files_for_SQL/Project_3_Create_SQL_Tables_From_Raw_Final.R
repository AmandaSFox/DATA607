# This script contains code to do the following:
# 1. Import two raw files from github repo (df_job_posting_raw and df_job_skills_raw)
# 2. Create ten tables to normalize the original two
# 3. Export to .csv for import into SQL (see SQL script)



library (tidyverse)
library (dplyr)


#-------- Import raw postings from github and transform to include necessary columns & good names
#-------- note - these were lightly cleaned  for rogue commas and invalid characters before import here


df_job_posting_raw <- read_csv("https://raw.githubusercontent.com/unsecuredAMRAP/607pr3/main/1_R_transform_raw_files_for_SQL/raw_job_postings.csv")

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




#-------- Prepare skills data to create (1) tbl_job_posting_skills and (2) tb_skills_master
#---------Parse comma delimited list of skills into columns: NOTE I capped this at 200 skills; 32 positions had more than 200


# Import skills by posting from github (note - these were lightly cleaned for rogue commas and invalid characters)

df_job_skills_raw <- read_csv("https://raw.githubusercontent.com/unsecuredAMRAP/607pr3/main/1_R_transform_raw_files_for_SQL/raw_job_skills2.csv")

df_job_skills_raw <- df_job_skills_raw %>% 
  rename(posting_id = id_simple, URL = job_link)

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

df_skills_work$posting_id <- as.character(df_skills_work$posting_id)

str(df_skills_work)

#-------- Melt skills and remove white spaces


head(df_skills_work)

df_skills_melt <- df_skills_work %>% 
  pivot_longer(-c(posting_id, URL),
               names_to = "skill_order", 
               values_to = "skill_desc",
               values_drop_na = TRUE,)

head(df_skills_melt)

df_skills_melt$skill_desc <- str_trim(df_skills_melt$skill_desc)

df_skills_melt <- df_skills_melt[,c(1,4)]
  
head(df_skills_melt)


#-------- Skills data prepared; create two tables for SQL

# Create skills lookup table
df_skills_master <- df_skills_melt %>% 
  distinct(skill_desc)

df_skills_master <- df_skills_master %>% 
  mutate(skill_id = 1:nrow(df_skills_master))

df_skills_master <- df_skills_master[,c(2,1)]

head(df_skills_master)


# Create job posting skills  table

head(df_skills_melt)

df_job_posting_skills <- mutate(left_join(df_skills_melt,
                                        df_skills_master,
                                        by = "skill_desc"))

df_job_posting_skills <- df_job_posting_skills[,c(1,3)]

head(df_job_posting_skills)


#----------- Write all to .csv for SQL
write.csv(df_city,"c:/users/amand/Git_Projects/DATA607/Project_3/tbl_city.csv", row.names=FALSE)
write.csv(df_company,"c:/users/amand/Git_Projects/DATA607/Project_3/tbl_company.csv", row.names=FALSE)
write.csv(df_country,"c:/users/amand/Git_Projects/DATA607/Project_3/tbl_country.csv", row.names=FALSE)
write.csv(df_job_level,"c:/users/amand/Git_Projects/DATA607/Project_3/tbl_job_level.csv", row.names=FALSE)
write.csv(df_job_posting,"c:/users/amand/Git_Projects/DATA607/Project_3/tbl_job_posting.csv", row.names=FALSE)
write.csv(df_onsite_flag,"c:/users/amand/Git_Projects/DATA607/Project_3/tbl_onsite_flag.csv", row.names=FALSE)
write.csv(df_search_pos,"c:/users/amand/Git_Projects/DATA607/Project_3/tbl_search_pos.csv", row.names=FALSE)
write.csv(df_title,"c:/users/amand/Git_Projects/DATA607/Project_3/tbl_title.csv", row.names=FALSE)
write.csv(df_job_posting_skills,"c:/users/amand/Git_Projects/DATA607/Project_3/tbl_job_posting_skills.csv", row.names=FALSE)
write.csv(df_skills_master,"c:/users/amand/Git_Projects/DATA607/Project_3/tbl_skills_master.csv", row.names=FALSE)

#write.csv(df_skills_melt,"c:/users/amand/Git_Projects/DATA607/Project_3/tbl_skills_melt.csv", row.names=FALSE)
