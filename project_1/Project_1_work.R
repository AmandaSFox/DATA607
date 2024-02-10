library(tidyverse)
library(plyr)
library(dplyr)



# read chess data into df and unwrap rows

#--------READ IN SMALL VERSION OF FILE FOR TESTING

# d_small<-"c:/users/amand/git_projects/DATA607/Project_1/data_small.txt"
# d_list_small <- scan(file=d_small, sep="|",what='',skip=1,strip.white = TRUE)
# final_small<-do.call(rbind, split(d_list_small, rep(1:(length(d_list_small) %/% 23), each=23)))

#--------READ IN FULL VERSION OF FILE FOR TESTING, SPLIT INTO 23 FIELDS AND MAKE IT A DF

d<-"c:/users/amand/git_projects/DATA607/Project_1/data.txt"
d_list <- scan(file=d, sep="|",what='',skip=4,strip.white = TRUE)
unwrapped<-do.call(rbind, split(d_list, rep(1:(length(d_list) %/% 23), each=23)))
unwrapped<-as.data.frame(unwrapped)

#--------DROP COLUMNS 11 & 22 (BLANK) AND 23 (DASHES), ADD COLUMN NAMES
unwrapped<-unwrapped[,1:21]
unwrapped<-unwrapped[,-11]

colnames(unwrapped)<-c("Pair","Player_Name","Points","Round_1","Round_2","Round_3","Round_4",
                       "Round_5","Round_6","Round_7","State","Player_ID_Ranks","Not_Used1","Not_Used2",
                       "Not_Used3","Not_Used4","Not_Used5","Not_Used6","Not_Used7","Not_Used8")
unwrapped

#--------SEPARATE ROUNDS DATA

unwrapped_sep<- 
  unwrapped %>% separate(Round_1, c("Round_1_WLD","Round_1_Opponent"),extra="merge",fill="right")
unwrapped_sep<- 
  unwrapped_sep %>% separate(Round_2, c("Round_2_WLD","Round_2_Opponent"),extra="merge",fill="right")
unwrapped_sep<- 
  unwrapped_sep %>% separate(Round_3, c("Round_3_WLD","Round_3_Opponent"),extra="merge",fill="right")
unwrapped_sep<- 
  unwrapped_sep %>% separate(Round_4, c("Round_4_WLD","Round_4_Opponent"),extra="merge",fill="right")
unwrapped_sep<- 
  unwrapped_sep %>% separate(Round_5, c("Round_5_WLD","Round_5_Opponent"),extra="merge",fill="right")
unwrapped_sep<- 
  unwrapped_sep %>% separate(Round_6, c("Round_6_WLD","Round_6_Opponent"),extra="merge",fill="right")
unwrapped_sep<- 
  unwrapped_sep %>% separate(Round_7, c("Round_7_WLD","Round_7_Opponent"),extra="merge",fill="right")

#--------SEPARATE PLAYER ID AND RANK PRE- POST-


#--------MAKE POINTS NUMERIC

unwrapped_sep <- transform(unwrapped_sep,Points = as.numeric(Points))


























# 
# 
# 
# unwrapped_sep <- unwrapped %>% separate_wider_regex(
#                                   cols = matches("^Round.."), 
#                                   (("WLD_", col($.))= ".*", " ", ("OPP_", col($.) = ".*"),
#                                   patterns=
#                                   names_sep = NULL,
#                                   names_repair = "check_unique",
#                                   too_few = "align_start"
#                                   )
# 
# unwrapped_sep <- unwrapped %>% 
#   separate_wider_delim(
#   cols = matches("^Round.."), 
#   delim=" ",
#   names_sep = "_",
#   names_repair = "check_unique",
#   too_few = "align_start"
# )
# 
# 
# unwrapped_sep <- unwrapped %>% 
#   separate_wider_regex(
#     cols = matches("^Round.."), #var
#     patterns = c(paste0("WLD_", seq_along(x))= ".*?", " ", paste0("OPP_", seq_along(x) = ".*"),
#  #  patterns = c(var1 = ".*?", "_", var2 = ".*")
#     names_sep = "_",
#     names_repair = "check_unique",
#     too_few = "align_start"
#   )
# 
#  unwrapped %>% separate_wider_delim(c(Round_1,Round_2)
#                                     delim = " ",
#                                     names=c("WLD_1","Opp_1","WLD_2","OPP_2"),
#                                     too_few = "align_start",
#                                     too_many = "merge")
#  
#  
#  
#  
#  
#  
#  #cols = matches("^Round.."),
#  
# unwrapped %>% separate_wider_delim("Round_1","Round_2","Round_3","Round_4","Round_5","Round_6","Round_7",
#                     delim = " ",
#                      names=c("WLD_1","Opp_1","WLD_2","OPP_2","WKD_3","OPP_3","WLD_4","OPP_4",
#                             "WLD_5","OPP_5","WLD_6","OPP_6","WLD_7","OPP_7"),
#                      too_few = "align_start",
#                      too_many = "merge")
#   rename_with(~paste0("C_", seq_along(.x)), .cols =  matches("^Round.."))
