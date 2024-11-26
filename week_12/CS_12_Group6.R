library(tidyverse)
library(htmlwidgets)
library(widgetframe)

library(xts)

install.packages("dygraphs")
install.packages("openmeteo")
library(dygraphs)
library(openmeteo)


d<- weather_history(c(43.00923265935055, -78.78494250958327),start = "2023-01-01",end=today(),
                    daily=list("temperature_2m_max","temperature_2m_min","precipitation_sum")) %>% 
  mutate(daily_temperature_2m_mean=(daily_temperature_2m_max+daily_temperature_2m_min)/2)

data_sel <- d %>% select(daily_temperature_2m_min,daily_temperature_2m_max,daily_temperature_2m_mean)
xts_dat <- xts(x=data_sel,order.by=d$date)
data_sel2 <- d %>% select(daily_precipitation_sum)
xts_dat1 <- xts(x=data_sel2,order.by=d$date)

dygraph(xts_dat,main="Daily Maximum Temperature in Buffalo, NY", group="Temp") %>%
  dySeries(c("daily_temperature_2m_min","daily_temperature_2m_mean", "daily_temperature_2m_max"), 
           label = "Daily Maximum Temperature in Buffalo, NY") %>%
  dyRangeSelector(dateWindow = c("2023-01-01", "2024-10-31"))

dygraph(xts_dat1,main="Daily Maximum Precipitation in Buffalo, NY",group="Temp") %>%
  dyAxis("y",valueRange=c(0,40)) %>%
  dyRangeSelector(dateWindow = c("2023-01-01", "2024-10-31"))
  


