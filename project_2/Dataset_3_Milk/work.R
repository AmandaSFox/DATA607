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
  select(yr,pop,tot_whole,tot_low_skim_all,tot_bev_sales, tot_bev_avail) %>% 
  mutate(tot_other = tot_bev_avail - tot_whole - tot_low_skim_all,
         tot_consumed_on_site = tot_bev_avail - tot_bev_sales) %>% 
  select(yr,pop,tot_whole,tot_low_skim_all,tot_other,tot_bev_avail,tot_bev_sales,tot_consumed_on_site)

# check totals
test <- df_tidy_wide %>% 
  summarize(sum(tot_whole), sum(tot_low_skim_all), sum(tot_other), sum(tot_consumed_on_site),
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

df_avail_type <- filter(df_tidy, category %in% c("tot_whole", "tot_low_skim_all","tot_other"))


df_type_sum <- filter(df_avail_type, yr %in% c(1920,1940,1960,1980,2000,2020)) %>% 
  pivot_wider(names_from = category,values_from = gallons) %>% 
  mutate(percent_whole = tot_whole/(tot_whole + tot_low_skim_all + tot_other),
       percent_low_skim = tot_low_skim_all/(tot_whole + tot_low_skim_all + tot_other),
       percent_other = tot_other/(tot_whole + tot_low_skim_all + tot_other))
df_type_sum


ggplot(df_avail_type, aes(x = yr, y = gallons, fill = category)) +
  geom_bar(stat="identity") +
  scale_fill_brewer(palette = "Paired", name = "Category", 
                    labels = c("Low Fat or Skim/Buttermilk","Other","Whole Milk")
                    ) +
  scale_x_continuous(breaks = breaks_width(10))+
  scale_y_continuous(n.breaks=20, labels = scales::label_comma()) +
  xlab("Year") +
  ylab("Total Gallons Per Capita") +
  ggtitle("Total Gallons Per Capita: Liquid Milk Availability by Type")


 
# -------- line trend #2 consumed on site vs total

df_avail_con <- filter(df_tidy, category %in% c("tot_consumed_on_site","tot_bev_sales"))

df_avail_sum <- filter(df_avail_con, yr %in% c(1920,1940,1960,1980,2000,2020)) %>% 
  pivot_wider(names_from = category,values_from = gallons) %>% 
  mutate(percent_consumed_on_site = tot_consumed_on_site/(tot_consumed_on_site + tot_bev_sales))

df_avail_sum


ggplot(df_avail_con, aes(x = yr, y = gallons, fill = category)) +
  geom_bar(stat="identity") +
  scale_fill_brewer(palette = "Paired", name = "Category", labels = c("Total Available for Sale","Consumed Where Produced")) +
  scale_x_continuous(breaks = breaks_width(10))+
  scale_y_continuous(n.breaks=20, labels = scales::label_comma()) +
  xlab("Year") +
  ylab("Total Gallons Per Capita") +
  ggtitle("Total Gallons Per Capita: Liquid Milk Availability by Location Consumed")


# -------- loss adjustment
df_loss_pct <- read_csv("https://raw.githubusercontent.com/AmandaSFox/DATA607/main/project_2/Dataset_3_Milk/loss_pct.csv")

df_avail_adj <- filter(df_avail_con, yr %in% c(1970,1980,1990,2000,2010,2020)) %>% 
  pivot_wider(names_from = category,values_from = gallons) %>%  
  mutate(tot_avail = tot_consumed_on_site + tot_bev_sales) %>% 
  left_join(df_loss_pct) %>% 
  mutate(pct_loss = pct_loss/100, loss_adjusted_avail = (1-pct_loss) * tot_avail) 
  
df_avail_adj 

# Create plot: 

ggplot(df_avail_adj, aes(x = yr, y = loss_adjusted_avail)) +
  geom_bar(stat="identity", fill = "lightblue") +
  scale_x_continuous(breaks = breaks_width(10))+
  scale_y_continuous(n.breaks=10, labels = scales::label_comma()) +
  xlab("Year") +
  ylab("Total Gallons Per Capita") +
  ggtitle("Total Gallons Per Capita: Liquid Milk Estimated Consumption (Loss-Adjusted Availability)")




select(df_avail_sum, c(yr, tot_avail,loss_adjusted_avail))

