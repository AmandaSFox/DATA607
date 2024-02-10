library(tidyverse)
library(plyr)
library(dplyr)



#--------READ IN FILE, UNWRAP ROWS: SPLIT INTO 23 FIELDS AND MAKE IT A DF

d<-"c:/users/amand/git_projects/DATA607/Project_1/data.txt"
d_list <- scan(file=d, sep="|",what='',skip=4,strip.white = TRUE)
unwrapped<-do.call(rbind, split(d_list, rep(1:(length(d_list) %/% 23), each=23)))
unwrapped<-as.data.frame(unwrapped)

#--------DROP COLUMNS 11 & 22 (BLANK) AND 23 (DASHES), ADD COLUMN NAMES
unwrapped<-unwrapped[,1:21]
unwrapped<-unwrapped[,-11]

colnames(unwrapped)<-c("Pair","Player_Name","Points","Round_1","Round_2","Round_3","Round_4",
                       "Round_5","Round_6","Round_7","State","Player_ID_Rating","Not_Used1","Not_Used2",
                       "Not_Used3","Not_Used4","Not_Used5","Not_Used6","Not_Used7","Not_Used8")

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

unwrapped_sep<- unwrapped_sep %>% separate_wider_regex(Player_ID_Rating, c(Player_ID = "^\\d.*","\\/\\s*R\\s*\\:",misc = ".*"))
unwrapped_sep<- unwrapped_sep %>% separate_wider_regex(misc, c(Rating_Pre = "^\\s*\\d*\\d*\\d*\\d*.*.*.*","\\-\\s*\\>",Rating_Post = ".*"))

#--------SEPARATE PROVISIONAL DESIGNATIONS 

unwrapped_sep<- unwrapped_sep %>% separate_wider_delim(Rating_Pre, delim="P",names=c("Rating_Pre","P_Pre"),too_few = "align_start")
unwrapped_sep<- unwrapped_sep %>% separate_wider_delim(Rating_Post, delim="P",names=c("Rating_Post","P_Post"),too_few = "align_start")

#--------MAKE POINTS AND RANKS NUMERIC

unwrapped_sep_fin <- transform(unwrapped_sep,Points = as.numeric(Points))
unwrapped_sep_fin <- transform(unwrapped_sep_fin,Rating_Pre = as.numeric(Rating_Pre))
unwrapped_sep_fin <- transform(unwrapped_sep_fin,Rating_Post = as.numeric(Rating_Post))
unwrapped_sep_fin <- transform(unwrapped_sep_fin,P_Pre = as.numeric(P_Pre))
unwrapped_sep_fin <- transform(unwrapped_sep_fin,P_Post = as.numeric(P_Post))


#--------SLIM DOWN AND RENAME FINAL DF

df <- unwrapped_sep_fin[,c("Pair","Player_ID","Player_Name","State","Points","Rating_Pre","Round_1_Opponent","Round_2_Opponent","Round_3_Opponent"
                       ,"Round_4_Opponent","Round_5_Opponent","Round_6_Opponent","Round_7_Opponent")]

str(df)

# ---------MAKE RATINGS TABLE

df_ratings <- df[,c("Pair","Rating_Pre")]

# ---------POPULATE OPP RATINGS IN OPP TABLE


str(df)
str(df_ratings)


#THIS ADDS RATING_PRE FOR OPPONENT 1!!!!!!!  

df <- df %>% left_join(df_ratings, join_by(x$Round_1_Opponent == y$Pair))
df <- df %>% left_join(df_ratings, join_by(x$Round_2_Opponent == y$Pair))
df <- df %>% left_join(df_ratings, join_by(x$Round_3_Opponent == y$Pair))
df <- df %>% left_join(df_ratings, join_by(x$Round_4_Opponent == y$Pair))
df <- df %>% left_join(df_ratings, join_by(x$Round_5_Opponent == y$Pair))
df <- df %>% left_join(df_ratings, join_by(x$Round_6_Opponent == y$Pair))
df <- df %>% left_join(df_ratings, join_by(x$Round_7_Opponent == y$Pair))


#---------RENAME UGLY COLUMNS

colnames(df)<-c("Pair","Player_ID","Player_Name","State","Points","Rating_Pre","Round_1_Opponent",
                "Round_2_Opponent","Round_3_Opponent","Round_4_Opponent","Round_5_Opponent","Round_6_Opponent",
                "Round_7_Opponent","Round_1_Opp_Rate","Round_2_Opp_Rate","Round_3_Opp_Rate",
                "Round_4_Opp_Rate","Round_5_Opp_Rate","Round_6_Opp_Rate","Round_7_Opp_Rate")

str(df)

#---------ADD COL WITH AVERAGE OPP SCORES

df <- transform(df, Opp_Avg_Rate = round(rowMeans(df[,14:20], na.rm = TRUE)))

str(df)

#---------MAKE FINAL SUMMARY TABLE AND GENERATE .CSV

chess_data <- df [,c("Player_Name","State","Points","Rating_Pre","Opp_Avg_Rate")]
chess_data

