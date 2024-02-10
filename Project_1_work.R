library(tidyverse)
library(plyr)
library(dplyr)



# read chess data into df and unwrap rows

#--------READ IN SMALL VERSION OF FILE FOR TESTING

d_small<-"c:/users/amand/git_projects/DATA607/Project_1/data_small.txt"
d_list_small <- scan(file=d_small, sep="|",what='',skip=1,strip.white = TRUE)
final_small<-do.call(rbind, split(d_list_small, rep(1:(length(d_list_small) %/% 23), each=23)))

#--------READ IN FULL VERSION OF FILE FOR TESTING

d<-"c:/users/amand/git_projects/DATA607/Project_1/data.txt"
d_list <- scan(file=d, sep="|",what='',skip=4,strip.white = TRUE)
unwrapped<-do.call(rbind, split(d_list, rep(1:(length(d_list) %/% 23), each=23)))

#--------DROP COLUMNS 11 & 22 (BLANK) AND 23 (DASHES), ADD COLUMN NAMES
unwrapped<-unwrapped[,1:21]
unwrapped<-unwrapped[,-11]

colnames(unwrapped)<-c("Pair","Player_Name","Points","Round_1","Round_2","Round_3","Round_4",
                       "Round_5","Round_6","Round_7","State","Player_ID_Ranks","Not_Used1","Not_Used2",
                       "Not_Used3","Not_Used4","Not_Used5","Not_Used6","Not_Used7","Not_Used8")
unwrapped




