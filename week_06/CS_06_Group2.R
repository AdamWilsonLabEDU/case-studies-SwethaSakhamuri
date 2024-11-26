library(terra)
library(spData)
library(tidyverse)
library(sf)

#install.packages("ncdf4")
library(ncdf4)
download.file("https://crudata.uea.ac.uk/cru/data/temperature/absolute.nc","crudata.nc",method="curl")
?download.file
# read in the data using the rast() function from the terra package
?rast
tmean=rast("crudata.nc")

tmean[[1]]
plot(tmean)
?max
max_tm<-(max(tmean))
max_tm
plot(max_tm)
data(world)
world_vec <- vect(world)
m<-terra::extract(max_tm,world_vec,fun=max,na.rm=T,small=T)

world_clim <- bind_cols(world,m)

ggplot(world_clim) +
  geom_sf(data=world_clim,aes(fill=max)) +
  scale_fill_viridis_c(name="Maximum\nTemperature (C)") +
  labs(title = "Maximum Temperature (1961-1990) by Country", fill = "Max Temp (°C)")+
  theme(legend.position = 'bottom')

?terra::extract
?scale_fill_viridis_c
?arrange
head(world_clim)



hottest_continents <- world_clim %>% 
  group_by(continent,name_long) %>%
  summarize(temperature=max(max)) %>%
  slice_max(temperature, n = 1) %>%
  arrange(desc(temperature)) %>%
  st_set_geometry(NULL) 


