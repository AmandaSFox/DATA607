library(tidyverse)
library(ggplot2)
library(openintro)
library(RColorBrewer)


# Summarize the  2020, 2021, 2022 average ridership for Subway, Buses, LIRR and Metro-North. 
# Compare the Subway and Buses and determine did more people take the Subway or Bus in 2020.
# Which transportation has the highest and lowest ridership in 2020.

# -------- Load datafile

df_mta <- read_csv("https://raw.githubusercontent.com/AmandaSFox/DATA607/main/project_2/Dataset_1_MTA/MTA_Daily_Ridership_Data__Beginning_2020_20240228.csv")
head (df_mta)

# -------- Select out columns of interest, change names, and check data types

df_mta_slim <- df_mta %>% 
  select(`Date`,`Subways: Total Estimated Ridership`,`Buses: Total Estimated Ridership`,
         `LIRR: Total Estimated Ridership`,`Metro-North: Total Estimated Ridership`) %>% 
  dplyr::rename(`date`=`Date`, `Subway` = `Subways: Total Estimated Ridership`, `Bus` = `Buses: Total Estimated Ridership`,
                `LIRR` = `LIRR: Total Estimated Ridership`, `Metro-North` = `Metro-North: Total Estimated Ridership`)

str(df_mta_slim)

# -------- Extract four digit year as string from char field "date"

df_mta_slim <- df_mta_slim %>% 
  mutate(`year` = str_sub(df_mta$Date, start = -4)) 

# -------- Melt modes of transportation

df_mta_melt <- df_mta_slim %>% 
  pivot_longer(cols = c("Subway","Bus","LIRR","Metro-North"),
             names_to = "mode",
             values_to = "riders") 

# -------- Calculate and plot mean ridership by year 2020-22 and mode of transport

df_years <- c("2020","2021","2022")

df_final <- df_mta_melt %>% 
  filter(`year` %in% df_years) %>% 
  group_by(`year`, mode) %>% 
  summarize (mean_ridership = round(mean(riders, na.rm = TRUE))) 

# df_final %>% 
#  pivot_wider(names_from = mode, values_from = mean_ridership)

ggplot(df_final,aes(x=reorder(`mode`,-mean_ridership),y = mean_ridership/1000, 
                    fill = mode)) +
  geom_bar(stat = "identity") +
  scale_fill_brewer(palette = "Set3") +
  coord_flip() +
  facet_wrap(~`year`,nrow = 4) +
  xlab("Mode of Transportation") +
  ylab("Mean Daily Ridership (Thousands)") +
  theme(legend.position = "") +
  ggtitle("MTA Daily Ridership by Type: 2020-2022")

