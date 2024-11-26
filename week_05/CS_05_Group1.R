#install.packages("sf")
#install.packages("spData")
library(sf) #Handing spatial data
library(spData) 
library(tidyverse)
library(units)

data(world)
temp_world <- world #temporary datasets of world and us_states
data(us_states)
temp_usstates <- us_states

albers="+proj=aea +lat_1=29.5 +lat_2=45.5 +lat_0=37.5 +lon_0=-96 +x_0=0 +y_0=0 +ellps=GRS80 +datum=NAD83 +units=m +no_defs"
#Albers Equal Area projection
?st_transform
?st_buffer
#Transforming the world data to albers projection
transformed_world_data <- st_transform(temp_world,albers)

temp_filtered_data <- transformed_world_data %>% 
                      filter(name_long=="Canada") #Filtering only data with Canada
canada <- st_buffer(temp_filtered_data,dist=10000) 


transformed_usstaes_data <- st_transform(temp_usstates,albers) # Creates a buffer around Canada's 
  #borders by 10,000 meters (10 km)

new_york <- transformed_usstaes_data %>%
                            filter(NAME=="New York") #Filtering with New York State

border <-st_intersection(canada,new_york) #Calculates the intersection between
# the buffered  Canada polygon and New York State. 

ggplot() +
  geom_sf(data = new_york, color = "black",linewidth=0.75) +
  geom_sf(data = border, fill = "red1",color="black",linewidth=1) +
  theme_grey() +
  labs(title = "Intersected Area Between New York and Buffered Canada")

border_area_m2 <-st_area(border) #Calculates the area of the border
border_area_km2 <-set_units(border_area_m2, km^2) #Converts the area from square meters to square kilometers

border_area_km2
border_area_m2


