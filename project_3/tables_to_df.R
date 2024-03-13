# connect to azure shared mysql instance, import two tables into R


library (tidyverse)
library(DBI)
library(RMySQL)

# Create database connection to project_team_3 schema

db_con <- dbConnect(MySQL(),user='mazzaa',password='V7K-hU9z',dbname='project_3_team',host='data607-afox03.mysql.database.azure.com')

# Create Job Postings dataframe: Create new dataframe by fetching result of 
# SELECT * query against the "job_posting" table in "project_team_3" schema

db_res <- dbSendQuery(db_con,paste0("SELECT * FROM `project_3_team`.job_posting;"))
df_posting<-fetch(db_res,n=-1)

str(df_posting)  
summary(df_posting)

# Create Job Skills dataframe: same as above, # SELECT * FROM job_skills table

db_res <- dbSendQuery(db_con,paste0("SELECT * FROM `project_3_team`.job_skills;"))
df_skills<-fetch(db_res,n=-1)

str(df_skills)  
summary(df_skills)
