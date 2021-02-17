library(tidyverse)
all_data <- read.csv("data/population.csv", skip = 14)

data <- all_data %>%
  filter(Year == 2020) %>%
  select(contains("Country"), Asylum.seekers)
dim(data)

country_of_interest <- "ESP"

country_data <- data %>%
  filter(Country.of.asylum..ISO. == country_of_interest)

num_countries <- nrow(country_data)

num_people <- country_data %>%
  summarize(total_people = sum(Asylum.seekers)) %>%
  pull()

top_10_countries <- country_data %>%
  top_n(10, wt = Asylum.seekers) %>%
  arrange(-Asylum.seekers) %>% #descending order
  select(Country.of.origin, Asylum.seekers)

install.packages("maps")
library(maps)
shapefile <- map_data("world")
