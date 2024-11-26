library(tidyverse)
library(spData)
library(sf)
library(mapview) # new package that makes easy leaflet maps
library(foreach)
library(doParallel)
registerDoParallel(4)
#install.packages("tidycensus")
library(tidycensus)
census_api_key("a097fa58a6b68a54c5d80f082378c6feaec23c7d")

race_vars <- c(
  "Total Population" = "P1_001N",
  "White alone" = "P1_003N",
  "Black or African American alone" = "P1_004N",
  "American Indian and Alaska Native alone" = "P1_005N",
  "Asian alone" = "P1_006N",
  "Native Hawaiian and Other Pacific Islander alone" = "P1_007N",
  "Some Other Race alone" = "P1_008N",
  "Two or More Races" = "P1_009N"
)


options(tigris_use_cache = TRUE)
erie <- get_decennial(geography = "block", variables = race_vars, year=2020,
                      state = "NY", county = "Erie County", geometry = TRUE,
                      sumfile = "pl", cache_table=T) 

erie <- st_crop(erie,xmin=-78.9,xmax=-78.85,ymin=42.888,ymax=42.92)
?st_as_sf
?st_sample
erie$variable <- factor(erie$variable)
race_points<-foreach(race=levels(erie$variable),.combine=rbind,.packages=c("sf", "dplyr")) %dopar% {
  race_data<-erie %>% filter(variable==race)
  sample_points<-st_sample(race_data,size=race_data$value,exact=TRUE)
  sample_points_sf<-st_as_sf(sample_points) %>%
    mutate(variable=race)
  sample_points_sf
}
mapview(race_points, zcol="variable",legend=TRUE,cex=1,alpha=0.7,stroke=FALSE)

