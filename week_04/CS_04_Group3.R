#install.packages("nycflights13") #Installing the package
library(nycflights13) #Loading the package
library(tidyverse)
#Creating temp variables for the datasets
table_airports <- airports
table_flights <- flights
table_weather <- weather
table_plane <- planes
table_airlines <- airlines

#Getting the top 5 records
head(table_airlines)
head(table_flights)
head(table_airports)
head(table_plane)
head(table_weather)

?slice
?arrange

filtered_data <- arrange(table_flights,desc(distance)) %>% filter(table_flights$origin =="JFK")
names(filtered_data)[names(filtered_data)=='dest'] <- 'faa'
joined_data <-left_join(table_airports,filtered_data,"faa")
arranged_data <- arrange(joined_data,desc(distance))
farthest_airport <- arranged_data[1,"name"]
farthest_airport <- as.character(farthest_airport)
farthest_airport

