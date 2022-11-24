
###                                ###
### Software Carpentry Nov 2022    ###
### DAY 3                          ###
### dplyr and ggplot2              ###
###                                ###


#####################################################################x
# Objective: data manipulation with ddplyr                           #
#####################################################################x

######### Exploring Data Frames #############



x <- c(5.4, 6.2, 7.1, 4.8, 7.5)
names(x) <- c('a', 'b', 'c', 'd', 'e')
print(x)
# Come up with at least 2 different commands that will produce the following output:



# b   c   d 
# 6.2 7.1 4.8

x[c("b", "c", "d")]
x[c(2:4)]
x[c(2, 3, 4)]
x[2:4]
x[-c(1,5)]
x[c(FALSE, TRUE, TRUE, TRUE, FALSE)]




cats <- data.frame(coat = c("calico", "black", "tabby"),
                   weight = c(2.1, 5.0, 3.2),
                   likes_string = c(1, 0, 1))
write.csv(x = cats, file = "data/feline-data.csv", row.names = FALSE)

cats <- read.csv("data/feline-data.csv")


age <- c(1, 4, 2)

cats <- cbind(cats, age)

ncol(cats)
nrow(cats)

mean(cats$age)
mean(age)

birth <- c(2000, 2019, NA)

birth

cats <- cbind(cats, birth)

str(cats)

cats$likes_string <- as.logical(cats$likes_string)
cats$age <- as.character(cats$age)

str(cats)

new_obs <- list("tortoiseshell", 3.3, FALSE, "4", "2021")

cats <- rbind(cats, new_obs)

cats$coat <- as.character(cats$coat)

cats[4, 1] <- "tortoiseshell"


is.na(cats$birth)
any(is.na(cats$birth))


cats$birth[3] <- 2010
cats[3, 5] <- 2010


cats$birth <- NULL


cats[3, ]

cats[1, ]

cats <- cats[-c(3, 4), ]





######## Data Frame Manipulation with dplyr
install.packages("dplyr")
install.packages("ggplot2")

library(dplyr)

df <- read.csv("data/gapminder_data.csv")

str(df)

any(is.na(df$year))

mean(df[df$continent == "Africa", "gdpPercap"])

any(is.na(df$gdpPercap))

df %>% filter(continent == "Africa") %>% summarise(mean_gdpPercap = mean(gdpPercap))

mean(df$gdpPercap)


year_country_gdp <- df %>% select(year, country, gdpPercap)

everything_but_gdpPercap <- df %>% select(-gdpPercap)
str(everything_but_gdpPercap)

year_country_gdp_EU <- df %>% filter(continent == "Europe") %>% select(year, country, gdpPercap)


gdp_by_continents <- df %>% group_by(continent) %>% summarize(mean_gdp_continent = mean(gdpPercap))
gdp_by_continents

gdp_by_country <- df %>% group_by(country) %>% summarize(mean_gdp_country = mean(gdpPercap))
gdp_by_country 

#####  How to get standard deviation by continents of gdp 
sd(df$gdpPercap)

sd_gdp_by_continents <- df %>% group_by(continent) %>% summarize(mean_gdp_country = mean(gdpPercap), 
                                                                 sd_gdp_country = sd(gdpPercap))

sd_gdp_by_continents <- df %>% group_by(continent) %>% summarize(sd_gdp_country = sd(gdpPercap))







#####################################################################x
# Objective: creating publication-quality graphics with ggplot2      #
#####################################################################x

# R has built-in functions to plot data, some of which we used on day 1:
x <- 1:15
y <- x^2
plot(x, y)

draws <- sample(letters, size=50, replace=TRUE)
barplot(table(draws)) 


# today, we're using the ggplot2 package
# ggplot has may opportunities to produce customised, pretty plots
# e.g., check out this library:
# https://r-charts.com/ggplot2/


# we will learn:
# - to apply geometry, aesthetic, and statistics layers to a ggplot plot
# - to manipulate the aesthetics of a plot using different colors, shapes, and lines
# - to improve data visualization through transforming scales and paneling by group
# - to save a plot created with ggplot to disk

# gg = "grammar of graphics = the idea that any plot can be represented by a set of components:
# a data set, a coordinate system, and a set of geoms for data
# load ggplot2, it should already be installed
library("ggplot2")

# you can test whether a package is available in your library, before installing
if(!require(ggplot2)) {install.packages("ggplot2"); library(ggplot2)}



### loading the gapminder data ####

# today, we're analysing the gapminder dataset: data on wealth and life expectancy of countries
gapminder <- read.csv("data/gapminder_data.csv")

# alternatively, load data from gapminder package
if(!require(gapminder)) {install.packages("gapminder"); library(gapminder)}


# first, when working with a new data set, get an overview of the structure and variables
str(gapminder)
# when using the gapminder package, data are stored as a tibble, a generalization of a data.frame
gapminder <- as.data.frame(gapminder)

head(gapminder)

# how many countries?
unique(gapminder$country) 
length(unique(gapminder$country))

# for each country, there's a value for life expectancy, and population size, and GDP per capita
# data is provided every five years, from 1952 to 2007, i.e. 12 years for each country
# We might want to look at trends over time by continent

summary(gapminder) # there's quite some variation in GDP, pop, lifeExp

# are the data complete? table() might be useful 
table(gapminder$continent, gapminder$year)



### the ggplot layer system - data, coordinates, geoms ####

# the base layer: data and coordinates
# this draws up a grid of coordinates, but does not plot data
ggplot(data = gapminder, mapping = aes(x = gdpPercap, y = lifeExp))

# add geoms for data plotting
ggplot(data = gapminder, mapping = aes(x = gdpPercap, y = lifeExp)) +
  geom_point()

# note: only use column names because you already specified data=gapminder
# using aes(x = gapminder$gdpPercap, y = gapminder$lifeExp) returns
# Warning messages:
#   1: Use of `gapminder$gdpPercap` is discouraged.
# ℹ Use `gdpPercap` instead. 
# 2: Use of `gapminder$lifeExp` is discouraged.
# ℹ Use `lifeExp` instead. 


### Challenge 1
# modify the example to show changes in life expectancy over time
# hint: there is a column called year

ggplot(data = gapminder, mapping = aes(x = year, y = lifeExp)) + 
  geom_point()


### Challenge 2
# mapping uses the aes() function = 'aesthetics'
# we used aes() for coordinates, but can set the aesthetic 'color'

# modify the code to color by continent - do you see additional trends?

ggplot(data = gapminder, mapping = aes(x = year, y = lifeExp, color = continent)) + 
  geom_point()

# trends: continents with stronger economy, the life exp is higher



### adding another geom layer ####

ggplot(data = gapminder, mapping = aes(x = year, y = lifeExp, 
                                       by = country,
                                       color = continent)) + 
  geom_point() +
  geom_line()

# note that you need the 'by' aesthetic to tell what points should be connected by lines

# note that layers are drawn on top of each other
# maybe best to swap the order of geom_point() and geom_line()

# note that you don't have to write out mapping and data everytime, this is fine, too:
ggplot(gapminder, aes(x = year, y = lifeExp, by = country, color = continent)) + 
  geom_line() +
  geom_point()
# now we can see that the points are drawn on top of the lines


## TIP
# the last line can't end with a "+", otherwise ggplot will try to add whatever you run next to its plot
# this can be really annoying of youre wanting to change the order of things
# to always have a fixed endpoint, so you can shuffle your lines around carefree, you can use:
ggplot(gapminder, aes(x = year, y = lifeExp, by = country, color = continent)) + 
  geom_line() +
  geom_point() + 
  NULL



### adding color and inheriting aes() ####
# aesthetic mappings can be set in ggplot() globally, or/and in individual layers
# proivde aes color to lines, and to lines only
ggplot(data = gapminder, mapping = aes(x = year, y = lifeExp, 
                                       by = country)) + 
  geom_line(aes(color = continent)) + 
  geom_point()

# global settings of data and aes in ggplot() get inherited by other layers -- unless overwritten!
# when I moved the color aes to the geom_line, geom_point doesn't inherit it and turns points black

# we can provide a colour to geom_point
ggplot(gapminder, aes(x = year, y = lifeExp, by = country)) + 
  geom_line(aes(color = continent))+
  geom_point(color = "pink")



# aes values instead of mapping:
# so, what goes inside aes()? - let's use a silly example and play with linewidth
ggplot(gapminder, aes(x = year, y = lifeExp, by = country)) + 
  geom_line(aes(color = continent, linewidth = 0.1))+
  geom_point()
# doesn't work; aes expects some kind of groups to map line width to

ggplot(gapminder, aes(x = year, y = lifeExp, by = country)) + 
  geom_line(aes(color = continent, linewidth = continent))+
  geom_point()
# Warning message: Using linewidth for a discrete variable is not advised.
# it gives each country a different line width - but we already have different colours!

# if you are setting just one value, you move this outside the aes function:
ggplot(gapminder, aes(x = year, y = lifeExp, by = country)) + 
  geom_line(aes(color = continent), linewidth = 0.1)+
  geom_point()


# similarly, this doesnt work:
ggplot(gapminder, aes(x = year, y = lifeExp, by = country)) + 
  geom_line(aes(color = "blue"))+ 
  geom_point()

# but this sets all lines to blue:
ggplot(gapminder, aes(x = year, y = lifeExp, by = country)) + 
  geom_line(color = "blue")+
  geom_point()





### transformations and stats ####

# ggplot can also add visualizations for statistics, or let you
# directly transform data to be plotted a certain way

# let's consider our first example again:
ggplot(data = gapminder, mapping = aes(x = gdpPercap, y = lifeExp)) +
  geom_point()
# there is a bulk of data concentrated in one area and some outliers in GDP
# let's use a different scale and unit of x axis to make it easier to see trends

ggplot(data = gapminder, mapping = aes(x = gdpPercap, y = lifeExp)) +
  geom_point() + 
  scale_x_log10()

# we can also use transparency to for overplotting points
ggplot(data = gapminder, mapping = aes(x = gdpPercap, y = lifeExp)) +
  geom_point(alpha = 0.5) + 
  scale_x_log10()

# remember, by setting alpha outside aes() we hard-code a single value
# we can also map alpha to a variable
ggplot(data = gapminder, mapping = aes(x = gdpPercap, y = lifeExp)) +
  geom_point(aes(alpha = continent)) + 
  scale_x_log10()



### fit a linear model and plot it ####

ggplot(data = gapminder, mapping = aes(x = gdpPercap, y = lifeExp)) +
  geom_point() + 
  scale_x_log10() + 
  geom_smooth(method = "lm") # method 'linear model'


# we can also change the visual of the linear model
ggplot(data = gapminder, mapping = aes(x = gdpPercap, y = lifeExp)) +
  geom_point() + 
  scale_x_log10() + 
  geom_smooth(method = "lm", colour = "red")
# note, I just used "col" instead of "color" or "colour" - any is fine



### Challenge 4

# modify the geom_point color and size to a specific value

ggplot(data = gapminder, mapping = aes(x = gdpPercap, y = lifeExp)) +
  geom_point(size = 3, color = "orange") + 
  scale_x_log10() + 
  geom_smooth(method = "lm")


# now use the color of points to represent different continents
# and use a different shape
# tip: use ?pch for shapes
ggplot(data = gapminder, mapping = aes(x = gdpPercap, y = lifeExp, 
                                       color = continent)) +
  geom_point(size = 3, shape = 9) + # use pch numbers for shapes
  scale_x_log10() + 
  geom_smooth(method = "lm")

# note that introducing mapping groups will automatically
# make geom_smooth inherit these groups and make multiple trendlines

# what would you to to avoid this???
# put color into point aes(), not in the global (aes) of the ggplot call

ggplot(data = gapminder, mapping = aes(x = gdpPercap, y = lifeExp)) +
  geom_point(size = 3, shape = 17, aes(color = continent)) + 
  scale_x_log10() + 
  geom_smooth(method = "lm")



### adding a smooth curve ####
# add to our scatter plot
ggplot(data = gapminder, mapping = aes(x = year, y = lifeExp)) + 
  geom_point(aes(color=continent)) +
  geom_smooth(method="loess")




### multiple panels ####

# there's a lot going on in our plot
# with facet_wrap(), we can make panels for different countries

# lets make a subset of countries in the americas
americas <- gapminder[gapminder$continent == "Americas",]

ggplot(data = americas, mapping = aes(x = year, y = lifeExp)) +
  geom_line() +
  facet_wrap( ~ country) # make facets, i.e. panels
# to tell facet() what group to use for the panels, we use the tilde sign

# our text in x now massively overlaps
# we can set the overall look and change plot and layout options using theme()

# there are a number of pre-set themes for ggplot2, e.g. theme_classic()
ggplot(data = americas, mapping = aes(x = year, y = lifeExp)) +
  geom_line() +
  facet_wrap( ~ country) +
  theme_classic()
# or theme_bw()
ggplot(data = americas, mapping = aes(x = year, y = lifeExp)) +
  geom_line() +
  facet_wrap( ~ country) +
  theme_bw()


# we can customise a theme by providing arguments
# e.g., element_text, element_line, or element_blank() for removing an element
# the help page (?themes) will list all the options that can be modified

ggplot(data = americas, mapping = aes(x = year, y = lifeExp)) +
  geom_line() +
  facet_wrap( ~ country) +
  theme_classic()+
  theme(axis.text.x = element_text(angle = 45))

# setting a theme for all plots --> use theme_set to set and theme_get to query
mytheme <- theme_bw()+
  theme(axis.text.x = element_text(angle = 45))

theme_set(mytheme)

# now we can plot without setting the theme (unless we overwrite it with +theme() )
ggplot(data = americas, mapping = aes(x = year, y = lifeExp)) +
  geom_line() +
  facet_wrap( ~ country)




### changing text ####

# let's clean up the axis titles etc
# we can do that in the theme options, and/or in labs()

ggplot(data = americas, mapping = aes(x = year, y = lifeExp)) +
  geom_line() + 
  facet_wrap( ~ country) +
  labs(
    x = "Year",              # x axis title
    y = "Life expectancy",   # y axis title
    title = "Figure 1"       # main title of figure
  ) +
  theme_bw()+
  theme(axis.text.x = element_text(angle = 90, hjust = 1)) # hjust controls the text alignment, horizontal justification


# changing axis limits
ggplot(data = americas, mapping = aes(x = year, y = lifeExp)) +
  geom_line() + 
  facet_wrap( ~ country) +
  labs(
    x = "Year",              # x axis title
    y = "Life expectancy",   # y axis title
    title = "Figure 1"       # main title of figure
  ) +
  xlim(1950,1980)+
  theme_bw()+
  theme(axis.text.x = element_text(angle = 90, hjust = 1))




### exporting a plot ####

# you can manually export a plot using the RStudio feature
# but this is annoying if you are re-saving etc

# --> use ggsave function

# you can see that ggsave takes a 'plot' argument
# the default is last_plot(), the plot that is currently open
# but to avoid errors we should write our plot into an object
# and save that

lifeExp_plot <- ggplot(data = americas, mapping = aes(x = year, y = lifeExp)) +
  geom_line() + 
  facet_wrap( ~ country) +
  labs(
    x = "Year",              # x axis title
    y = "Life expectancy",   # y axis title
    title = "Figure 1"       # main title of figure
  ) +
  xlim(1950,1980)+
  theme_bw()+
  theme(axis.text.x = element_text(angle = 90, hjust = 1))

ggsave(filename = "lifeExp.png", plot = lifeExp_plot, width = 12, 
       height = 10, dpi = 300, units = "cm")

# ggsave will use the file extension to determine the file type
# but you can use the device argument to hard-code the type (pdf, png, etc)


# alternatively, when not using ggplot2
pdf(file="plotname.pdf", width=5, height=8)
# PLOTCODE
dev.off()



### box plot and violin plot ####

### Challenge 4

# make a boxplot of life expectancy between continents during available years

ggplot(data = gapminder, mapping = aes(x = continent, y = lifeExp, 
                                       fill = continent)) +
  geom_boxplot() + 
  facet_wrap(~ year) +
  ylab("Life Expectancy") +
  theme_bw()+
  theme(axis.title.x=element_blank(),
        axis.text.x = element_blank(),
        axis.ticks.x = element_blank())


# violin plot: nice alternative to boxplot
ggplot(data = gapminder, mapping = aes(x = continent, y = lifeExp, 
                                       fill = continent)) +
  geom_violin(color = NA, alpha = 0.5) + 
  geom_point(shape = 21, position = position_jitter(width = 0.2), alpha = 0.5)+
  #facet_wrap(~ year) +
  ylab("Life Expectancy") +
  theme_bw()+
  theme(axis.title.x=element_blank(),
        axis.text.x = element_blank(),
        axis.ticks.x = element_blank())


# we now used an additional mapping option: the fill
# color in boxplots actually controls the line color
# we can use ylab or xlab to seperately set axis titles
# we removed here the x axis labels, as they are the same as the colors
# in the legend


### other useful packages ####

library("patchwork") 
# really simple package for putting multiple plots in one figure

lifeExp_plot/lifeExp_plot # on top of each other

lifeExp_plot + lifeExp_plot # next to each other


library("cowplot")
# another package for arranging multiple plots in one figure
plot_grid(lifeExp_plot, lifeExp_plot, align = "v")

