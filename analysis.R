library(tidyverse)
library(maps)
library(countrycode)
all_data <- read.csv("data/population.csv", skip = 14)

data <- all_data %>%
  filter(Year == 2020) %>%
  select(contains("Country"), Asylum.seekers)
dim(data)

country_of_interest <- "ESP"
country_name <- countrycode(country_of_interest, origin = 'iso3c', destination = 'country.name')
  

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

shapefile <- map_data("world") #state for US

shapefile <- shapefile %>%
  mutate(Country.of.origin..ISO. = countrycode(region, origin = 'country.name', destination = 'iso3c')) %>%
  left_join(country_data, by = "Country.of.orgin..ISO.")
  
ggplot(data = shapefile) +
  geom_polygon(
    mapping = aes(x = long, y = lat, group = group, fill = Asylum.seekers)
    ) +
  labs(title = paste("Number of People Seeking Asylum in", country_name), 
       x = "", y = "", fill = "Num. People") +
  theme_minimal()