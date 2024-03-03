# Orig dataset https://datatools.samhsa.gov/nsduh/2019/nsduh-2018-2019-rd02yr/crosstab?row=PNRNMYR&column=STUSAB&weight=DASWT_1
# Downloaded data was tidy: used Excel pivot table to recreate the untidy format displayed on the site.  

# compare and rank prevalence by state 
# correlation between state pain reliever misuse and whether states have expanded medicaid.
# check for regional patterns (e.g., compare prevalence rates between Northeast, Midwest, South, West regions)


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

# -------- Flag states w/o MA expansion and compare rates of misuse
# -------- https://www.kff.org/affordable-care-act/issue-brief/status-of-state-medicaid-expansion-decisions-interactive-map/
# -------- accessed 3/3/2024

df_no_MA <- read_csv("https://raw.githubusercontent.com/AmandaSFox/DATA607/main/project_2/Dataset_2_Pain/MA_No_Exp.csv")

df_tidy_wide <- left_join(df_tidy_wide,df_no_MA)

df_MA_vs_Non <- df_tidy_wide %>% 
  group_by(`flag`) %>% 
  summarize(mean(`1 - Misused within the past year`/`Overall`)) %>% 
  rename("mean % misuse" = "mean(`1 - Misused within the past year`/Overall)")

df_MA_vs_Non <- df_MA_vs_Non %>% 
  replace_na(list(flag = "MA_Expansion"))

df_MA_vs_Non

ggplot(df_MA_vs_Non, aes(x = flag,y = `mean % misuse`, fill = flag)) +
  geom_bar(stat = "identity") +
  scale_y_continuous(n.breaks=20, labels = scales::label_percent()) +
  xlab("Medicaid Expansion Status") +
  ylab("Mean % Misuse") +
  ggtitle("Mean % Misuse by Medicaid Expansion Status")

# -------- Flag states by region and compare rates of misuse
# -------- forked from cphalpert/census-regions 3/3/2024 
# -------- Orig source: http://www.census.gov/geo/maps-data/maps/pdfs/reference/us_regdiv.pdf


# -------- Flag states by region and compare rates of misuse

df_region <- read_csv("https://raw.githubusercontent.com/AmandaSFox/census-regions/master/us%20census%20bureau%20regions%20and%20divisions.csv")

df_tidy_wide <- left_join(df_tidy_wide, df_region, join_by(x$`state` == y$`State Code`))

# -------- region

df_by_region <- df_tidy_wide %>%   
  group_by(`Region`) %>% 
  summarize(mean(`1 - Misused within the past year`/`Overall`)) %>% 
  rename("mean % misuse" = "mean(`1 - Misused within the past year`/Overall)") %>% 
  arrange(-`mean % misuse`)

df_by_region

ggplot(df_by_region, aes(x = Region,y = `mean % misuse`, fill = Region)) +
  geom_bar(stat = "identity") + 
  scale_y_continuous(n.breaks=12, labels = scales::label_percent()) + 
  coord_flip() + 
  theme(legend.position = "") + 
  ylab("Mean % Misuse") + 
  ggtitle("Mean % Misuse by US Census Bureau Region")

# -------- division

df_by_division <- df_tidy_wide %>%   
  group_by(`Region`,`Division`) %>% 
  summarize(mean(`1 - Misused within the past year`/`Overall`)) %>% 
  rename("mean % misuse" = "mean(`1 - Misused within the past year`/Overall)")
  arrange(-`mean % misuse`)

df_by_division

ggplot(df_by_division, aes(x = `Division`,y = `mean % misuse`, fill = Division)) +
  geom_bar(stat = "identity") + 
  scale_y_continuous(n.breaks=12, labels = scales::label_percent()) + 
  coord_flip() + 
  theme(legend.position = "") + 
  ylab("Mean % Misuse") + 
  ggtitle("Mean % Misuse by US Census Bureau Division")




# 
# df_region <- read_csv("https://raw.githubusercontent.com/AmandaSFox/census-regions/master/us%20census%20bureau%20regions%20and%20divisions.csv")
# 
# df_tidy_wide <- left_join(df_tidy_wide,df_region, join_by(x$`state` == y$`State Code`))
# 
# df_by_division <- df_tidy_wide %>% 
#   group_by(`Division`) %>% 
#   summarize(mean(`1 - Misused within the past year`/`Overall`)) %>% 
#   rename("mean % misuse" = "mean(`1 - Misused within the past year`/Overall)")
# 
# ggplot(df_by_division, aes(x = Division,y = `mean % misuse`, fill = Division)) +
#   geom_bar(stat = "identity") +
#   scale_y_continuous(n.breaks=12, labels = scales::label_percent()) +
#   coord_flip() +
#   theme(legend.position = "") +
#   ylab("Mean % Misuse") +
#   ggtitle("Mean % Misuse by US Census Bureau Division (Region)")
# 
