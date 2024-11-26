#install.packages("gapminder") #Installing the package Gapminder

library(ggplot2) #Loading ggplot2, gapminder, dplyr packages
library(gapminder)
library(dplyr)

#Using the filter to remove Kuwait from the gapminder dataset 
#Data for Plot1
temp <- gapminder #Creating a temp variable to store the gapminder datatset
temp <- gapminder %>%
        filter(country != 'Kuwait')


#Plot1
#Plotting Gdp Per Capita vs Life Exp by distinguishing wrt continent and size of population
plot1 <- ggplot(temp, aes(x = lifeExp, y = gdpPercap, color= continent, size = pop/100000)) +
  geom_point() + #Adding points to the plot
  facet_wrap(~year,nrow=1) + #Creating separate plots for each year in a single row
  scale_y_continuous(trans = "sqrt") + #transforming the y axis by applying a sq root
  theme_bw() + #Applying black and white theme to the plot
  scale_size_continuous(name = "Population (100k)") + #Setting the name for the size legend
  #Setting the name and values for the color legend
  scale_color_manual(name = 'Continent', values = c("Africa" = "red", 
                                                    "Americas" = "blue", 
                                                    "Asia" = "forestgreen", 
                                                    "Europe" = "orange", 
                                                    "Oceania" = "purple")) + 
  labs(title ="Wealth and life expectancy through time",
       x = "Life Expectancy",
       y = "GDP Per Capita") #Adding title and x and y axis
plot1 #Displaying plot1

#Getting help 
?scale_color_manual
?scale_size_continuous  
?scale_y_continuous  

# Data for Plot2
#Generating data for plot 2 by grouping the continent and year together and summarizing
gapminder_continent <- temp %>%
          group_by(continent,year) %>%
          summarize(gdpPercapweighted = weighted.mean(x = gdpPercap, w = pop),
                    pop = sum(as.numeric(pop)))
#Plot2
head(gapminder_continent) #Getting the top 5 data records of the new dataset

#Generating the plot2 gdppercap vs year and distinguingshin by continent
plot2 <- ggplot(gapminder , aes(x = year, y = gdpPercap, color = continent))+
  geom_line(aes(group=country)) + #getting separate lines by grouping them by country
  geom_point()+ #Adding points
  geom_line(data = gapminder_continent, aes(x = year, y = gdpPercapweighted,group=continent),
            color = "black") + #Adding the Weighted GDP line
  geom_point(data = gapminder_continent, aes(x = year, y = gdpPercapweighted, size =pop/100000),
             color = "black") + #Adding the weighted GDP points
  #setting the y limits 
  scale_y_continuous(limits = c(0, 50000), breaks = seq(0, 50000, by = 10000)) +
  #Creating each plot by continent
  facet_wrap(~continent,nrow=1) +
  theme_bw() +
  labs(x = "Year",
      y = "GDP Per Capita",
      size= "Population",
      color = "Continent")
plot2

library(gridExtra)

final_plot <- grid.arrange(plot1,plot2,nrow=2,ncol=1)
final_plot
ggsave("Plot1.png", width = 15, plot1)
ggsave("Plot2.png", width =15 , plot2)
ggsave("FinalPlot.png", width= 30, height = 20,final_plot)
