'
Lab 4
Course: FU
Lab instructor: Karina Shyrokykh
Date: April, 2020
Stockholm University
'

## Part 1: Relationship between variables 
# Correlation coefficient can be computed using the functions cor() or cor.test():
'
The Pearson product-moment correlation coefficient is a measure of the strength of the linear relationship 
between two variables. It is referred to as Pearsons correlation or simply as the correlation coefficient. 
A perfect positive linear relationship, r = 1.

Kendalls Tau coefficient and Spearmans rank correlation coefficient 
assess statistical associations based on the ranks of the data. Kendall 
rank correlation (non-parametric) is an alternative to Pearsons correlation (parametric) 
when the data you are working with has failed one or more assumptions of the test.

Spearmans coefficient is appropriate for both continuous and discrete ordinal variables.
Both Spearmans rho  and Kendall tau  can be formulated as special cases of a more general 
correlation coefficient.
'

my_data <- read.csv("V-Dem-CY-Core-v8.csv", header=T)
head(my_data)

#pick column names upon which sub-dataset will be selected
selected <- c("country_name", "historical_date",  "year", "v2x_delibdem", "v2x_egaldem", "v2xel_frefair", "v2x_gender")
head(selected)

# Subset your data
my_data.subset <- my_data[selected]
head(my_data.subset)

# Correlation
cor1 <- cor(my_data.subset$v2x_gender, my_data.subset$year, method = c("pearson", "kendall", "spearman"))
print(cor1)
cor2 <- cor.test(my_data.subset$v2x_gender, my_data.subset$year, method=c("pearson", "kendall", "spearman"))
print(cor2)

#If your data contain missing values, use the following R code to handle missing values by case-wise deletion
cor(my_data.subset$v2x_gender, my_data.subset$year,  method = "pearson", use = "complete.obs")

## Part 3: Prepare the data: aggregate/collapse data
aggdata <-aggregate(my_data, by=list(my_data$country_name), 
                    FUN=mean, na.rm=TRUE)

## Part 4. OLS regression
# Tests for the assumptions
# You can read more here: https://statisticsbyjim.com/regression/ols-linear-regression-assumptions/


# OLS
install.packages("ggplot2")
library(ggplot2)

model1 <- lm(v2xel_frefair ~ v2x_delibdem + v2x_egaldem + v2x_gender, data = aggdata)
summary(model1)

#visualize linear relationships between the dependent variable and the independent variable
install.packages("graphics")
library(graphics)

with(aggdata, scatter.smooth(v2x_delibdem, v2xel_frefair, lpars =
                            list(col = "red", lwd = 3, lty = 3)))

#plotting correlation
plot(v2xel_frefair ~ v2x_delibdem, data = aggdata, col = "blue")
with(aggdata, lines(loess.smooth(v2xel_frefair, v2x_delibdem), col = "green"))

# gvlma: An r package to test regression assumptions
install.packages("gvlma")
library(gvlma)

# goves all of the results at one glance
gvlma_model <- gvlma(model1)
summary(gvlma_model)

## Butt if you want to investigate the situation better, proceed with the code:

##### OLS Assumption 1: The regression model is linear in the coefficients and the error term#######


######### OLS Assumption 2: The error term has a population mean of zero ######################

####### OLS Assumption 3: All independent variables are uncorrelated with the error term ######

####### OLS Assumption 4: Observations of the error term are uncorrelated with each other #####

####### OLS Assumption 5: No independent variable is a perfect linear function of other explanatory variables


################# Assumption 6: Homoscedastic erros ###########################################

# Detecting heteroscedasticity via visualization
# https://rpubs.com/cyobero/187387
par(mfrow=c(2,2)) # init 4 charts in 1 panel
plot(model1)


'The plots we are interested in are at the top-left and bottom-left. 
The top-left is the chart of residuals vs fitted values, while in the bottom-left one, 
it is standardised residuals on Y axis. If there is absolutely no heteroscedastity, 
you should see a completely random, equal distribution of points throughout the range of
X axis and a flat red line.

But in our case, as you can notice from the top- and bottom-left plots, the red line is slightly 
curved and the residuals seem to increase as the fitted Y values increase. 
So, the inference here is, heteroscedasticity exists.'

# Detecting heteroscedasticity via a stat test
#Breush Pagan Test
install.packages("lmtest")
library(lmtest)
lmtest::bptest(model1)  # Breusch-Pagan test 

#NCV Test
install.packages("car")
library(car)
car::ncvTest(model1)

'NCV Test test has a p-value less that a significance level of 0.05, 
therefore we can reject the null hypothesis that the variance of the residuals 
is constant and infer that heteroscedasticity is indeed present, thereby confirming our 
graphical inference.'

'Alternative 1: consider trying out is to add the residuals of the original
model as a predictor and rebuild the regression model. 
Alternative 2: Box-Cox transformation (is a mathematical transformation of the 
variable to make it approximate to a normal distribution. Often, doing a box-cox 
transformation of the Y variable solves the issue)'

install.packages("caret")
library(caret)

install.packages("e1071")
library(e1071)

distBCMod <- caret::BoxCoxTrans(aggdata$v2x_delibdem)
print(distBCMod)

is.na(aggdata$v2x_delibdem) # missings are detected

# create new dataset without missing data 
aggdata2 <- na.omit(aggdata)
# what do you see? 
# removing NAs is not an option


'Fixing for heteroscedasticity method No. 1: using regression with robust standard errors and 
weighted least squares regression'
model2 <- lm(v2x_gender ~ v2x_delibdem, data = aggdata)
resi <- model2$residuals

library(ggplot2)
ggplot(data = aggdata, aes(y = resi, x = v2x_delibdem)) + geom_point(col = 'blue') + geom_abline(slope = 0)

# fixing
install.packages("sandwich")
library(sandwich)

'Fixing for heteroscedasticity method No. 2: regression with robust standard errors'
install.packages("robustbase")
install.packages("tidyverse")
install.packages("sandwich")
install.packages("lmtest")
install.packages("modelr")
install.packages("broom")

library(robustbase)
library(tidyverse)
library(sandwich)
library(lmtest)
library(modelr)
library(broom)

# Breusch-Pagan test
bptest(model1)

# To get the correct standard errors, we can use the vcovHC() 
#function from the {sandwich} package (hence the choice for 
#the header picture of this post):

model1 %>% 
  vcovHC() %>% 
  diag() %>% 
  sqrt()

#By default vcovHC() estimates a 
#heteroskedasticity consistent (HC) variance covariance matrix for the parameters.
# we see that st.errors are different (some are larger)

#you can achieve the same in one single step:
coeftest(model1, vcov = vcovHC(model1))
# inclusing robust standard errors into the model somehow changed the size of st.errors 
# but it did not impacvt the results.
# it is in our example, in other cases it can have a dramatic effect. 
# Remember, in our case, heteroscedasticity was not too severe. 


# Another way of dealing with heteroskedasticity is to use the lmrob() function from the {robustbase} package
## this estimation method is different, and is also robust to outliers
lmrobfit <- lmrob(v2xel_frefair ~ v2x_delibdem + v2x_egaldem + v2x_gender, data = aggdata)
summary(lmrobfit)

# Finally, it is also possible to bootstrap the standard errors. For this I will use the bootstrap() 
# function from the {modelr} package:

resamples <- 100

boot_aggdata <- aggdata %>% 
  modelr::bootstrap(resamples)

boot_aggdata
# The column strap contains resamples of the original data. 
# I will run my linear regression from before on each of the resamples:
(
  boot_lin_reg <- boot_aggdata %>% 
    mutate(regressions = 
             map(strap, 
                 ~lm(v2xel_frefair ~ v2x_delibdem + v2x_egaldem + v2x_gender, 
                     data = .))) 
)

#I have added a new column called regressions which contains the 
# linear regressions on each bootstrapped sample. Now, I will create a list of tidied regression results:

(
  tidied <- boot_lin_reg %>% 
    mutate(tidy_lm = 
             map(regressions, broom::tidy))
)

# broom::tidy() creates a data frame of the regression results.
tidied$tidy_lm[[1]]

# to get the output
tidied$regressions[[1]]

# Now that I have all these regression results, I can compute any statistic I need. 
# But first, let’s transform the data even further:
list_mods <- tidied %>% 
  pull(tidy_lm)

# list_mods is a list of the tidy_lm data frames. 
# I now add an index and bind the rows together (by using map2_df() instead of map2()):
mods_df <- map2_df(list_mods, 
                   seq(1, resamples), 
                   ~mutate(.x, resample = .y))
head(mods_df, 25)

#group by the term column and compute any statistics I need, in the present case the standard deviation:
(
  r.std.error <- mods_df %>% 
    group_by(term) %>% 
    summarise(r.std.error = sd(estimate))
)

# We can append this column to the linear regression model result:
model1 %>% 
  broom::tidy() %>% 
  full_join(r.std.error) %>% 
  select(term, estimate, std.error, r.std.error) ### Joining, by = "term"

# Plotting effects
install.packages("jtools")
install.packages("ggstance")
library(jtools)
library(ggplot2)

effect_plot(model1, pred = v2x_delibdem, interval = TRUE, plot.points = TRUE)
effect_plot(model1, pred = v2x_gender, interval = TRUE, plot.points = TRUE)
plot_summs(model1)
plot_summs(model1, scale = TRUE)
plot_summs(model1, scale = TRUE, inner_ci_level = .9)

# Plot coefficient uncertainty as normal distributions
## Most of our commonly used regression models make an assumption that the coefficient 
# estimates are asymptotically normally distributed, which is how we derive our confidence
# intervals, p values, and so on. Using the plot.distributions = TRUE argument, you can
# plot a normal distribution along the width of your specified interval to convey the
# uncertainty.
plot_summs(model1, scale = TRUE, plot.distributions = TRUE, inner_ci_level = .9)

#Comparing model coefficients visually
model2 <- lm(v2xel_frefair ~ v2x_delibdem + v2x_gender,
           data = aggdata)
plot_summs(model1, model2, scale = TRUE)

## More can be found here (the sources bellow were used for creating this lab):
## https://www.brodrigues.co/blog/2018-07-08-rob_stderr/
## https://cran.r-project.org/web/packages/jtools/vignettes/summ.html
## http://r-statistics.co/Linear-Regression.html

################# Assumption 7: Normal Distribution ########################################
install.packages("dplyr")
if(!require(devtools)) install.packages("devtools")
devtools::install_github("kassambara/ggpubr")
install.packages("ggpubr")

library("dplyr")
library("ggpubr")

#Assess the normality of the data
#Visual methods
ggdensity(aggdata$v2xel_frefair, 
          main = "Density plot of frefair",
          xlab = "frefair")

# assumption of normality is violated

# Alternatively, Q-Q plot: 
# Q-Q plot (or quantile-quantile plot) draws the correlation between a given sample and the normal distribution. 
# A 45-degree reference line is also plotted.
ggqqplot(aggdata$v2xel_frefair)

# It’s also possible to use  shapiro.test() 
shapiro.test(aggdata$v2xel_frefair)

# the p-value > 0.05 would imply that the distribution of the data are not significantly different from normal distribution. 
# In other words, here, we cannot assume the normality.

# Let's see if v2x_delibdem is norm.distributed (in case we want to build another model)
shapiro.test(aggdata$v2x_delibdem) #no, neither this one is norm.distributed

# so, to deal with it, one needs to transform the data or use alternative models
# (zero-inflated) models: negative binomial or Poisson regression. Again, the choice must depend on the tests' results
# For some more info: https://stats.idre.ucla.edu/stata/dae/negative-binomial-regression/

# For more see: http://www.sthda.com/english/wiki/normality-test-in-r


################# Assumption 3: Normal Distribution ########################################


