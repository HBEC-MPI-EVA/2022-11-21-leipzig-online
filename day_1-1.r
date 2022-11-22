
###                             ###
### Software Carpentry Nov 2022 ###
### DAY 1                       ###
### Intro to R, Simulation      ###
###                             ###



##########################################################x
# 1 basics in R (Studio)                              #####
##########################################################x

# In addition to doing stats, R can be used as a calculator
# you can type this in the CONSOLE Pane
1 + 1
log(5)
exp(6) ^ (4*7)
sum(1, 4, 67, 9)

### Logical operators in R ###
1 == 1.  # returns TRUE
1 == 2.  # returns FALSE
1 != 2.  # returns TRUE (1 and 2 are NOT equal)
4 < 9.  # returns TRUE

# Some complex sequences of calculations
# often easier to write the EDITOR window of Rstudio  
1 + 5 * (12 - log(5))

# assigning values to a variable and doing subsequent calculations
x <- 3 
y <- 1 + 5 * ( 12 - log(x))


### vectorisation ### 
x <- 1:10 # x is a vector:  1  2  3  4  5  6  7  8  9 10
y <- x^2 # returns a vector: 1   4   9  16  25  36  49  64  81 100

plot(x, y)


x <- 1:5
y <- c(1, 2, 3, 4, 5)
x == y # TRUE TRUE TRUE TRUE TRUE


# built-in functions sequences, repetitions:
x <- seq(1, 5, by=0.1) # returns 1, 1.1, 1.2, 1.3, ... , 4.9, 5
x <- rep(1, 5) # returns 1 1 1 1 1

x <- c(3,5,6,8,10)
y <- mean(x) # "mean" is an in-buit function, calculating the mean of a vector of numbers


### getting help ###
?mean
help(mean)


# informative names: giving variables a more meaningful name, e.g.:
mean_boys_height <- mean(c(160, 176, 170)) 

# Valid variable names
MaxLength <- 1 # CamelCase
celsius2kelvin <- 1
min_height <- 1 # snake_case
max.height <- 1 # dot notation

# does not work
# _age <- 1
# min-length <- 1
# 2widths <- 1


### Managing Environment ###
# in the R Studio ENVIRONMENT Pane you can check which variables are assigned, and their values

# list of 
ls()
# can also use ".xyz <- 666 to assign a variable that's hidden from the environment
.hidden_variable <- 1

# remove single items (variables or dataframes etc) from environment
rm(x)
# wipe your environment (will delete all stored variables) or specify a list
rm(list=ls())




### packages ###
# the R community provides a number of useful packages and functions
# check which packages are installed and loaded in the R studio's "Packages" pane

# install and access packages
install.packages("NAME_OF_PACKAGE")
load("NAME_OF_PACKAGE")

# for this workshop, we need:
install.packages(c("ggplot2", "dplyr", "tidyr", "gapminder")) 
# "ggplot2", "dplyr", "tidyr" are part of the large package "tidyverse"




### File management / working directories ###
setwd("../") # move one folder up
getwd()

getwd() # get your current working directory
setwd("C:/Users/my_user_name/folder") # set working directory

# create a new folder "data" in your wd, then store a downloaded (data)file in that folder
download.file(url = "https://raw.githubusercontent.com/swcarpentry/r-novice-gapminder/gh-pages/_episodes_rmd/data/gapminder_data.csv", 
              destfile = "data/gapminder_data.csv")



### creating data frames ###

cats <- data.frame( coat = c("calico", "black", "tabby"),
                    weight = c(2.1, 5, 3.2),
                    likes_string = c(1, 0, 1))

# saving to file
write.csv(cats, file = "data/feline-data.csv", row.names = FALSE)

# remove
rm(cats)

# load cats data from file
cats <- read.csv(file = "data/feline-data.csv")



### manipulating/analysing cats data ###
cats$weight <- cats$weight * 1000 # use weight in g, not kg


### Data Types ###
str(cats)
typeof(cats) # returns "list"

class(cats) # returns "data.frame"
typeof(cats$coat) # returns "character"
typeof(cats$weight) # returns "double"

# 'double' stores floating-point numbers (vs integers)

typeof(1) # returns "double"
typeof(1L) # returns "integer"

# note, we stored cats$likes_string as Y/N, 1/0, but we can coerce it to be TRUE/FALSE:
is.logical(cats$likes_string) # FALSE
sum(cats$likes_string) # returns 2
cats$likes_string <- as.logical(cats$likes_string)
sum(cats$likes_string) # still, returns 2

# can't do calculations on different types though
cats$weight + cats$coat
# returns:
#   Error in cats$weight + cats$coat : 
#   non-numeric argument to binary operator
typeof(cats$coat)
typeof(cats$weight)


# use variables stored as characters as factors: 
cats$coat <- as.factor(cats$coat)

# reverse to character
cats$coat <- as.character(cats$coat)





##########################################################x
# 2 functions in R                                   ######
##########################################################x

my_function <- function(x) {
  # performing actions on parameter x, e.g. x+100
  # return value # return()
}


# example, convert between temperature scales
fahr_to_kelvin <- function(temp, min_kel = 273.15){
  out <- ((temp - 32) * (5/9)) + min_kel
  return (out)
}

fahr_to_kelvin(100) # returns 310.9278
fahr_to_kelvin(0) # returns 255.3722
fahr_to_kelvin(temp = 32) # 273.15

fahr_to_kelvin(temp = c(0, 32, 100)) # returns 255.3722 273.1500 310.9278



kelvin_to_celsius <- function(temp){
  out <- temp - 273.15
  return(out)
}

kelvin_to_celsius(3497)  
  
fahr_to_celsius <- function(temp_farh){
  temp_kelvin <- fahr_to_kelvin(temp = temp_farh)
  out <- kelvin_to_celsius(temp = temp_kelvin)
  return(out)
}

fahr_to_celsius(100)  
  




##########################################################x
# 3 using R for generative simulations              ######
##########################################################x

letters
LETTERS

# sample()  takes a random sample of size n from the elements of x using either with or without replacement
n <- 100
draws <- sample(LETTERS, n, replace = TRUE)
barplot(table(draws)) # check which letter got sampled how often
abline(h = n/26, lty = 2)



set.seed(2)
# you guarantee that the same random values are produced
# used to create reproducible results


# use a function to sample letters
sample_letters <- function(n) {
  draws <- sample(LETTERS, n, replace = TRUE)
  return(table(draws))
}

# note, sample(15, 1) is not the same as sample(“15”, 1)
# avoid trouble using
sample_safe <- function(x, ...) {
  x[sample.int(length(x), ...)]
}



# sample numbers, with different relative weights
sample(1:10, 30, replace=TRUE, prob=1:10)



# sampling from a normal distribution:
rnorm(10)
hist(rnorm(10000000))

mean(rnorm(1000, 5))
hist(rnorm(1000, 5))


my_sample <- rnorm (10000, mean = 10, sd = 4)
hist(my_sample)

heights <- rnorm(10000, mean = 170, sd = 40)
hist(heights)



# two non-correlated samples: 
n <- 1000
y <- rnorm(n)
x <- rnorm(n)
plot(x, y)
cor(x,y) # -1 and 1, where 0 means 'no' correlation
# a null relationship has correlation near 0

m1 <- lm( y ~ x)
summary(m1)



# creating a fixed correlation between two variables
r <- 0.9 # correlation factor
x <- rnorm(1000)
y <- rnorm(1000, mean = x * r, sd = sqrt(1 - r^2))
plot(x,y)
cor(x,y)


# creating correlated samples using a custom function
correlator <- function(r, n = 1000){
  stopifnot(r >= (-1) & r <= 1)
  x <- rnorm (n)
  y <- rnorm (n, mean = r * x, sd = sqrt(1- r^2))
  out <- data.frame(x = x, y = y)
  return (out)
}


# using the correlator function to create a data set
df <- correlator(0, n = 40)
cor(df$x, df$y)
plot(df$x, df$y)

m2 <- lm(y ~ x, data = df)
summary(m2)
abline(m2)



### sample sizes and false positive ###

# create a regression dataset with different r values (e.g. negative) and play around with n

n_obs <- 200
r <- -0.5

x <- matrix( rnorm(n_obs * 100), nrow = n_obs, ncol = 100)
y <- rnorm(n_obs, mean = r * x[,50], sd = sqrt(1- r^2))

m3 <- lm(y ~ x)

summary(m3)

# identify effects above a threshold
big_effects <- which(abs(coef(m3)) >= 0.016) - 1
x2 <- x[, big_effects]

m3_2 <- lm(y ~ x2)

summary(m3_2)

x_new <- matrix( rnorm(n_obs * 100), nrow = n_obs, ncol = 100)
x2_new <-  x_new[, big_effects]
m3_preregistered <- lm(y ~ x2_new)
summary(m3_preregistered)
