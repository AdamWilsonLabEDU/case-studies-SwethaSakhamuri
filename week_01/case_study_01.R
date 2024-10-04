
data(iris) #Loading the Iris data
?mean # accessing the help for mean function
petal_length_mean <- mean(iris$Petal.Length) # calculating the mean and assigning to the object 
petal_length_mean # printing the
hist(iris$Petal.Length , main="Histogram of Petal Length")


#install.packages("ggplot2") 
library(ggplot2) #Loading the library ggplot2
?geom_histogram #Accessing the help for geom histogram
ggplot(data=iris,aes(Petal.Length ,fill="red"))+geom_histogram() #Geom histogram for Iris dataset for petal.length variable.
summary(iris)

ggplot(data=iris,aes(Petal.Width,Petal.Length,color=Species))+geom_point()
?plot
