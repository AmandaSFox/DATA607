# bring in two tables from mysql and test a join to a lookup table 
# to add title_description back to job postings based on title_id field


library (tidyverse)
library (dplyr)
library (DBI)
library (RMySQL)

#-------- Create database connection to project_team_3 schema

db_con <- dbConnect(MySQL(),user='mazzaa',password='V7K-hU9z',dbname='project_3_team',host='data607-afox03.mysql.database.azure.com')


#-------- Create dataframes: # SELECT * FROM <tbl> 

db_job_posting <- dbSendQuery(db_con,paste0("SELECT * FROM `project_3_team`.tbl_job_posting;"))
df_job_posting<-fetch(db_job_posting,n=-1)

str(df_job_posting)  
summary(df_job_posting)


db_title <- dbSendQuery(db_con,paste0("SELECT * FROM `project_3_team`.tbl_title;"))
df_title<-fetch(db_title,n=-1)

str(df_title)  
summary(df_title)


# --------- Test join on title id

df_test <- mutate(left_join(df_job_posting, df_title, by = "title_id"))

                  

