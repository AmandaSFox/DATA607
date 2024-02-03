library(tidyverse)
library(plyr)

# Import newly created .csv with tb rates by country and year
# Add column names manually, as MySQL cannot export them

tb_rates<-read_csv('C:/ProgramData/MySQL/MySQL Server 8.0/Uploads/tb_rates.csv',col_names = FALSE)
colnames(tb_rates)<-c('Country','Year','TB Cases','Population','Rate')

tb_rates
#this all worked out fine except I cannot force mysql to calculate past the fourth decimal place!