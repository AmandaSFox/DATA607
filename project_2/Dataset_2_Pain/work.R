# Orig dataset https://datatools.samhsa.gov/nsduh/2019/nsduh-2018-2019-rd02yr/crosstab?row=PNRNMYR&column=STUSAB&weight=DASWT_1
# Downloaded data was tidy: used Excel pivot table to recreate the untidy format displayed on the site.  
# 

# compare and rank prevalence by state, 
# check for regional patterns (e.g., compare prevalence rates between Northeast, Midwest, South, West regions)
# correlation between state pain reliever misuse and whether states have expanded medicaid.



# -------- Load libraries 

library(tidyverse)
library(ggplot2)
library(scales)
library(RColorBrewer)

# -------- Load untidy .csv and rename/fill first column

df <- read_csv("https://raw.githubusercontent.com/AmandaSFox/DATA607/main/project_2/Dataset_2_Pain/Untidied.csv") %>% 
  rename("response" = "RC-PAIN RELIEVERS - PAST YEAR MISUSE") %>% 
  fill ("response")

# -------- Filter only necessary rows and tidy by melting states

df_tidy <- filter(df, Values == "Weighted Count") %>% 
  pivot_longer(cols = c(3:55),
               names_to = "state",
               values_to = "count")

# -------- Remove old totals

df_tidy <- filter(df_tidy, !(state %in% c("Grand Total","Overall")))

# -------- Complete tidying by pivoting out responses: one observation (state) per row

df_tidy <- pivot_wider(df_tidy, names_from = response, values_from = count)

# -------- Using tidy data, conduct requested analysis



