# -------- Load libraries 

library(tidyverse)
library(dplyr)
library(ggplot2)
library(scales)
library(RColorBrewer)

df <- read_csv("https://raw.githubusercontent.com/AmandaSFox/DATA607/main/project_2/Dataset_3_Milk/fluid_milk_gallons.csv",
               skip = 6) 

colnames(df) <- c("yr","pop","whole_plain_cons","whole_plain_sales","whole_plain_tot",
                 "whole_flav","tot_whole","low_2_pct","low_1_pct","low_tot_plain","low_flav",
                 "low_subtot_plain_flav","buttermilk","skim","skim_buttermilk_cons",
                 "tot_low_skim_all","other_eggnog","other_misc","tot_other",
                 "tot_bev_sales","tot_bev_avail")

df <- filter(df, yr %in% (1909:2021))
str(df)
df$yr<-as.numeric(df$yr)


# -------- Total Trend: isolate and redefine main categories for trending

df_tidy_wide <- df %>% 
  select(yr,pop,tot_whole,low_subtot_plain_flav,skim,tot_bev_sales, tot_bev_avail) %>% 
  mutate(tot_low_skim = low_subtot_plain_flav+skim, 
         tot_other = tot_bev_avail - tot_whole - tot_low_skim,
         tot_consumed_on_site = tot_bev_avail - tot_bev_sales) %>% 
  select(yr,pop,tot_whole,tot_low_skim,tot_other,tot_bev_avail,tot_bev_sales,tot_consumed_on_site)

# check totals
test <- df_tidy_wide %>% 
  summarize(sum(tot_whole), sum(tot_low_skim), sum(tot_other), sum(tot_consumed_on_site),
            sum(tot_bev_avail), sum(tot_bev_sales))

# check str
str(df_tidy_wide)

# -------- tidy long

df_tidy <- df_tidy_wide %>% 
  pivot_longer(cols = c(2:8),
               names_to = "category",
               values_to = "gallons"
               )


# -------- line trend #1 whole vs total

df_avail_type <- filter(df_tidy, category %in% c("tot_whole", "tot_low_skim","tot_other"))

ggplot(df_avail_type, aes(x = yr, y = gallons, fill = category)) +
  geom_bar(stat="identity") +
  scale_fill_brewer(palette = "Paired", name = "Category", 
                    labels = c("Low Fat or Skim","Other incl. Buttermilk","Whole Milk")
                    ) +
  scale_x_continuous(breaks = breaks_width(10))+
  scale_y_continuous(n.breaks=20, labels = scales::label_comma()) +
  xlab("Year") +
  ylab("Total Gallons Per Capita") +
  ggtitle("Total Gallons Per Capita: Liquid Milk Availability by Type")


 
# -------- line trend #2 consumed on site vs total

df_avail_con <- filter(df_tidy, category %in% c("tot_consumed_on_site","tot_bev_sales"))

ggplot(df_avail_con, aes(x = yr, y = gallons, fill = category)) +
  geom_bar(stat="identity") +
  scale_fill_brewer(palette = "Paired", name = "Category", labels = c("Total Available for Sale","Consumed Where Produced")) +
  scale_x_continuous(breaks = breaks_width(10))+
  scale_y_continuous(n.breaks=20, labels = scales::label_comma()) +
  xlab("Year") +
  ylab("Total Gallons Per Capita") +
  ggtitle("Total Gallons Per Capita: Liquid Milk Availability by Location Consumed")



