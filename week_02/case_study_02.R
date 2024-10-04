#Loading the tidyverse package
#install.pakcgaes("tidyverse")
library(tidyverse)

#Storing the url in dataurl object
dataurl="https://data.giss.nasa.gov/tmp/gistemp/STATIONS_v4/tmp_USW00014733_14_0_1/station.csv"

#Basically sends a GET request to the URL 
httr::GET("https://data.giss.nasa.gov/cgi-bin/gistemp/stdata_show_v4.cgi?id=USW00014733&ds=14&dt=1")

#Reading the csv data into temp object and renaming the column names 
temp=read_csv(dataurl, 
              na="999.90", # tell R that 999.90 means missing in this dataset
              skip=1, # we will use our own column names as below so we'll skip the first row
              col_names = c("YEAR","JAN","FEB","MAR", # define column names 
                            "APR","MAY","JUN","JUL",  
                            "AUG","SEP","OCT","NOV",  
                            "DEC","DJF","MAM","JJA",  
                            "SON","metANN"))

#To load a .csv present in your pc

#First get the working directory
getwd()

#Make sure that station.csv is your working directory.
#Else give the whole path to read the csv

csvdata = read_csv("C:/Users/sweth/Downloads/station.csv",
                   na="999.90", # tell R that 999.90 means missing in this
                   #dataset
                   skip=1,# we will use our own column names as below so 
                   #we'll skip the first row
                   col_names = c("YEAR","JAN","FEB","MAR", # define column names 
                                 "APR","MAY","JUN","JUL",  
                                 "AUG","SEP","OCT","NOV",  
                                 "DEC","DJF","MAM","JJA",  
                                 "SON","metANN"))


#Getting the summary of each columns in the temp dataset
summary(temp)

#Getting the first and last 5 rows of the data 
head(temp)
tail(temp)

#Plotting the graph
y <- ggplot(temp,aes(YEAR,JJA)) + geom_line(linetype=1, size=1) 
#A plot is mapped between Year vs JJA . 
#Geom_line indicates it to be line plot with a size 1

final_graph <- y + 
  geom_smooth(method='loess',colour="red1")+ #Adding a smooth red line 
  #Labs can be used to add text to the X and Y axis, titles, subtitles
  labs(x="YEAR",
       y="Mean Summer Temperature (C)") +
  ggtitle("Mean Summer Temperatures in Buffalo,NY")+ # ggtitle is an 
  #alternate way to add title
  labs(subtitle="Summer Included June July August \nData from the Historical Climate Network \nRed line is a LOESS Smooth ")+
  theme(plot.background = element_rect(colour="black",fill="grey89"),
        plot.title = element_text(size=20,hjust=0.5),
        plot.subtitle = element_text(size=15,hjust=0.5),
        axis.title.x = element_text(face='bold',size=15),
        axis.title.y = element_text(face='bold', size=17))
#theme is used to customize the plot even further. 
?theme # accessing theme help
final_graph

?ggsave #Just checking the syntax 
ggsave(final_graph,filename="JJA Mean Summer Temperatures in Buffalo.png")
#Saving the final graph with ggsave. 

