'
Lab2
Course: FU
Lab instructor: Karina Shyrokykh
Date: April, 2020
Stockholm University
'

#### Part 2.1. Data managment
# [`cbind()`](http://www.rdocumentation.org/packages/base/functions/cbind)  
# and [`rbind()`](http://www.rdocumentation.org/packages/base/functions/rbind)

# Construct matrix #1
box_office_all <- c(461, 314.4, 290.5, 247.9, 309.3, 165.8)
movie_names <- c("A New Hope","The Empire Strikes Back","Return of the Jedi")
col_titles <- c("US","non-US")
star_wars_matrix <- matrix(box_office_all, nrow = 3, byrow = TRUE, dimnames = list(movie_names, col_titles))

# Construct matrix #2
box_office_all2 <- c(474.5, 552.5, 310.7, 338.7, 380.3, 468.5)
movie_names2 <- c("The Phantom Menace", "Attack of the Clones", "Revenge of the Sith")
star_wars_matrix2 <- matrix(box_office_all2, nrow=3, byrow = TRUE, dimnames = list(movie_names2, col_titles))

# remove all except all_wars_matrix
rm(box_office_all)
rm(movie_names)
rm(col_titles)
rm(box_office_all2)
rm(movie_names2)

# Combine both Star Wars trilogies in one matrix
all_wars_matrix <- rbind(star_wars_matrix, star_wars_matrix2)

non_us_all <- all_wars_matrix[,2]

# Average non-US revenue
mean(non_us_all)

# Select the non-US revenue for first two movies
non_us_some <- all_wars_matrix[1:2,2]

# Average non-US revenue for first two movies
mean(non_us_some)


### Part 2.2: More matrices
matrix.1 <- matrix(vector, nrow=3, ncol=2, byrow=F)
matrix.1

# Argument order matters: first is what fills the matrix, second is number of rows,  third is number of columns
matrix.2<-matrix(1,3,2)
matrix.2

matrix.3<-diag(5)
matrix.3

# Creating a matrix from vectors
r.1 <- c(1, 2, 3)
r.2 <- c(4, 5, 6)

new.matrix <- rbind(r.1, r.2)
new.matrix

c.1 <- c(1, 2)
c.2 <- c(3, 4)

newer.matrix <- cbind(c.1, c.2)
newer.matrix

# This generalizes to arrays
new.array <- array(c(1,2,3), dim=c(3,1))
new.array

###Part 2.3. Loops
#Loops help us to apply an operation or operations to a series of values or variables.
new.vector <- NULL
for(i in 1:5){
  new.vector[i] <- i
}
new.vector
