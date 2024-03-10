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

# test<-as.data.frame(list_xml)
# 
# test<-do.call(rbind.data.frame, list_xml) 

df_xml<-xmlToDataFrame(list_xml) 

df_xml

#------------

path_html <- "https://raw.githubusercontent.com/AmandaSFox/DATA607/main/Week_7/Books.html"

#-------- Similar to XML
data_html <- getURL(path_html) %>% 
  htmlParse()

#-------- From rvest package
df_html<-read_html(path_html)%>%
  html_node("table") %>%
  html_table()

str(df_html)
df_html
