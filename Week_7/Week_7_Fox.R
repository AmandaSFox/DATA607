library(tidyverse)
library(jsonlite)
library(RCurl)
library(XML)

path_json <- "https://raw.githubusercontent.com/AmandaSFox/DATA607/main/Week_7/Books.json"
# path_xml <- "https://raw.githubusercontent.com/AmandaSFox/DATA607/main/Week_7/Books.xml"
# path_html <- "https://raw.githubusercontent.com/AmandaSFox/DATA607/main/Week_7/Books.html"


df_json <- jsonlite::fromJSON(path_json)

df_json

#--------

path_xml <- "https://raw.githubusercontent.com/AmandaSFox/DATA607/main/Week_7/Books.xml"

data_xml <- getURL(path_xml) %>% 
  xmlParse()

list_xml<-xmlToList(data_xml) 
df_xml<-xmlToDataFrame(list_xml) 

df_xml