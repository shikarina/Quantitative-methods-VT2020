'
Lab1
Course: FU
Lab instructor: Karina Shyrokykh
Date: April, 2020
Stockholm University
'

#### Part1. Arithmetics with R


# In its most basic form, R can be used as a simple calculator. Consider the following arithmetic operators:
#   
#   - Addition: `+`
# - Subtraction: `-`
# - Multiplication: `*`
# - Division: `/`
# - Exponentiation: `^`
# - Modulo: `%%`

##The (logical) comparison operators known to R are:

#  `<` for less than
#  `>` for greater than
#  `<=` for less than or equal to
#  `>=` for greater than or equal to
#  `==` for equal to each other
#  `!=` not equal to each other

#option 1
2 + 2

#option 2
a = 2 + 2
print(a)

# what do you see?
c(4, 5, 6) > 5

## Variable assignment
my_var <- 4
my_var_2 <- 4

my_var + my_var_2

# OR:
my_vars <- my_var + my_var_2
print(my_vars)

# Types of variables: string, numeric
class(my_vars)

# String/character/text
var_st <- "Hello world"
class(var_st)


#### Part2. Vectors

# Vectors are one-dimension arrays that can hold numeric data, 
# character data, or logical data. In other words, a vector is a simple 
# tool to store data. For example, you can store your daily gains and losses 
# in the casinos. 
# In R, you create a vector with the combine function [`c()`]

# Define the variable "greetings"
greetings <- "Hej-hej!"

numeric_vector <- c(1, 2, 3)
character_vector <- c("a", "b", "c")

# Complete the code such that `boolean_vector` contains the three elements: 
# `TRUE`, `FALSE` and `TRUE` (in that order).

boolean_vector <- c(TRUE, FALSE, TRUE)


#### Part 3. Data inspection

# It is important to have a clear view on the data that you are using. 
# Understanding what each element refers to is therefore essential. 
# In the previous exercise, we created a vector with your winnings over the week. 
# Each vector element refers to a day of the week but it is hard to tell 
# which element belongs to which day. It would be nice if you could show 
# that in the vector itself. 
# 
# You can give a name to the elements of a vector with the `names()` function. 
# Have a look at this example:

# Assign values to the vector  
some_vector <- c("John Doe", "poker player")

# Assign names of the vectors
names(some_vector) <- c("Name", "Profession")
print(some_vector)

# Opertations with vectors
A_vector <- c(1, 2, 3)
B_vector <- c(4, 5, 6)
# Take the sum of A_vector and B_vector
total_vector <- A_vector + B_vector
# Print out total_vector
total_vector


## Example -- gambling
poker_vector <- c(140, -50, 20, -120, 240)
roulette_vector <- c(-24, -50, 100, -350, 10)
days_vector <- c("Monday", "Tuesday", "Wednesday", "Thursday", "Friday")
names(poker_vector) <- days_vector
names(roulette_vector) <- days_vector

# Assign to total_daily how much you won/lost on each day
total_daily <-poker_vector + roulette_vector
print (total_daily)
# and in total:
sum (total_daily)
#OR
total_poker <- sum(poker_vector)
# you lost more than you won

# Which days did you make money on poker?
selection_vector <- poker_vector > 0

# Print out selection_vector
selection_vector


#### Part 4. Data managemnt: Matrices

'In this chapter, you will learn how to work with matrices in R. 
In R, a matrix is a collection of elements of the same data type 
(numeric, character, or logical) arranged into a fixed number of 
rows and columns. Since you are only working with rows and columns, 
a matrix is called two-dimensional. 
You can construct a matrix in R with the [`matrix()`]'

matrix(1:9, byrow = TRUE, nrow = 3)

'In the [`matrix()`](http://www.rdocumentation.org/packages/base/functions/matrix) function:
The first argument is the collection of elements that R will arrange into the rows and columns of the matrix. Here, we use `1:9` which is a shortcut for `c(1, 2, 3, 4, 5, 6, 7, 8, 9)`.
The argument `byrow` indicates that the matrix is filled by the rows. If we want the matrix to be filled by the columns, we just place `byrow = FALSE`. 
The third argument `nrow` indicates that the matrix should have three rows.
'

## create a matrix 
# Box office Star Wars (in millions!)
new_hope <- c(460.998, 314.4)
empire_strikes <- c(290.475, 247.900)
return_jedi <- c(309.306, 165.8)

# Create box_office
box_office <- c(new_hope, empire_strikes, return_jedi)

# Construct star_wars_matrix
star_wars_matrix <- matrix(box_office, nrow = 3, byrow = TRUE) 

#OR
star_wars_matrix <- matrix(c(new_hope, empire_strikes, return_jedi), nrow = 3, byrow = TRUE)

# Vectors region and titles, used for naming
region <- c("US", "non-US")
titles <- c("A New Hope", "The Empire Strikes Back", "Return of the Jedi")
rownames(star_wars_matrix) <- titles
colnames(star_wars_matrix) <- region

star_wars_matrix





