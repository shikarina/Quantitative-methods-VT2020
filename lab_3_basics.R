'
Lab3
Course: FU
Lab instructor: Karina Shyrokykh
Date: April, 2020
Stockholm University
'

## Part 3.1: Data mamangemnt: Basics 

# Check current working directory
getwd()

# Mac/Unix
setwd("/Users/kash7423/Desktop")

# Windows
setwd("C:/kash7423/Desktop")

##Loading Packages
install.packages("MASS")
install.packages("foreign")

library(MASS)
library(foreign)

## Getting Help
help(packagename)
# or
?packagename

# Basics
a <- sqrt(96)
a

b <- log(2)
b

A <- 1+2
B <- log(100, base=10)
C <- 15
D <- (A + B)/C
D
B


### Loading Data
# Save locally from: https://www.v-dem.net/en/data/data-version-8/
my_data <- read.csv("V-Dem-CY-Core-v8.csv", header=T)

summary(my_data)
names(my_data)

##Dropping and keeping variables
#pick column names upon which sub-dataset will be selected
selected <- c("country_name", "historical_date",  "year")
selected2 <- c("country_name", "codingend", "v2x_clphy_codehigh", "year")
head(selected2)

# Subset your data
my_data.subset <- my_data[selected]
my_data.subset2 <- my_data[selected2]

# Select variables to drop
dropped <- names(my_data) %in% c("country_id", "historical_date")

my_data.subset.2 <- my_data[!dropped]

### Part 3.2 Merging and combining data
new_data <- merge(my_data.subset, my_data.subset2, by=c("country_name", "year"))

### Saving the data, write to csv
write.csv(new_data, "new_data.csv")

# Stata file
write.dta(new_data, "c:/newdata.dta")

## Reshape
#R will allow us to switch between data of these differing formats.

wide.format <- reshape(new_data,
                       # time variable
                       timevar="year",
                       # variables not to change
                       idvar="country_name", 
                       # direction of reshape
                       direction = "wide"
                       )

### Saving the data, write to csv
write.csv(new_data, "new_data_long.csv")



