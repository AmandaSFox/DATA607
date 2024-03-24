# Intent: Preprocess weekly snapshots of top 20 most viewed articles for aggregation in a database 
# to support analysis and machine learning 


# Background:
#   The NYT API provides easy access to the top 20 most viewed, shared, or emailed articles for a range of timeframes
#   (1, 7, or 30 days). The data can be accessed on a schedule and aggregated as snapshots in a SQL database table 
#   or similar for later analysis and use in data mining or machine learning.

#   This code extracts the most viewed articles of the last seven days with 25 data elements such as dates,
#   title, author, section, and keywords. It then performs several cleaning and transformation steps required 
#   for analysis and then exports the dataframe as a .csv file with today's date appended for later ingestion into a database.

#   The process below is designed to be repeatable and can be customized by changing the API key and (optionally)
#   the number of days.


# libraries
library(tidyverse)
library(jsonlite)
library(dplyr)

# call api and create dataframe "df_mostviewed" with articles most viewed in past seven days 

nyturl <- "https://api.nytimes.com/svc/mostpopular/v2/viewed/7.json?api-key=jnf9jCrYLAyPORPG8zeeDNBhc0rbvNbu" 
df_mostviewed_raw <- fromJSON(nyturl,flatten = TRUE) %>% 
  data.frame()

# clean to remove unneeded columns and rename

df_mostviewed_working <- df_mostviewed_raw %>% 
  select(URI = results.uri,
         URL = results.url,
         pub_date = results.published_date,
         update_date = results.updated,
         section = results.section,
         subsection = results.subsection,
         byline = results.byline,
         type = results.type,
     #   people = results.per_facet,
     #   orgs = results.org_facet,
     #   desc = results.des_facet,
         keywords = results.adx_keywords)

# parse keywords
df_mostviewed_export <- df_mostviewed_working %>% 
  separate_longer_delim(keywords, delim = ';') 

# export to working directory as csv with today's date
filename = paste0('nyt_mostviewed_', Sys.Date(), '.csv')
write.csv(df_mostviewed_export,filename, row.names=FALSE)

