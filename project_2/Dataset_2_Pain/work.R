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

df <- read_csv("https://raw.githubusercontent.com/AmandaSFox/DATA607/main/project_2/Dataset_2_Pain/Untidied2.csv") %>% 
  rename("response" = "RC-PAIN RELIEVERS - PAST YEAR MISUSE") %>% 
  fill ("response")

str(df)

# -------- Filter only necessary rows and tidy by melting states: 
# -------- One observation = one state/response type pair. Used for stacked bar chart below.

df_tidy <- filter(df, Values == "Weighted Count") %>% 
  pivot_longer(cols = c(3:55),
               names_to = "state",
               values_to = "count"
               ) %>% 
  filter(!(state %in% c("Grand Total","Overall")))

# -------- Wide tidy option: Pivot out response types into columns.  
# -------- One observation (state) per row. Display top ten states by % Misuse:

df_tidy_wide <- pivot_wider(df_tidy, names_from = response, values_from = count) %>% 
  mutate(`% Misused` = `1 - Misused within the past year`/Overall) 

topten <- head(arrange(df_tidy_wide,desc(`% Misused`)),n = 10)
topten
  
# -------- Stacked bar chart: 

topten_tidy <- semi_join(df_tidy, topten) %>% 
  filter(!response == "Overall")
                        
ggplot(topten_tidy,aes(x = reorder(`state`,-`count`), y = `count`/1000, fill = response)) +
  geom_bar(stat = "identity") +
  scale_fill_brewer(palette = "Paired") +
  scale_y_continuous(n.breaks=20, labels = scales::label_comma()) +
  xlab("State") +
  ylab("Total Respondents (Thousands)") +
  ggtitle("Top Ten States (% Misuse)")








