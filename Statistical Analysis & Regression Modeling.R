#######################################################
# PROJECT 1: Global Development Analysis
# Exploring the Relationship Between GDP and Life Expectancy
#
# Objective:
# To explore global development trends using the Gapminder dataset,
# focusing on life expectancy, GDP per capita, and continental differences.
#
# This project demonstrates:
# - Exploratory Data Analysis (EDA)
# - Data visualization
# - Descriptive statistics
#######################################################

#######################################################
#   Exploring Data
#######################################################

library(ggplot2)   # for advanced data visualization
library(dplyr)     # for data manipulation

gapminder <- read.csv("http://bit.ly/2GxjYOB")  # load dataset from URL
head(gapminder)  # view first few rows of dataset

plot(x = gapminder$lifeExp)  # basic scatter plot of life expectancy (index vs value)
plot(x = gapminder$gdpPercap, y = gapminder$lifeExp)  # scatterplot of GDP per capita vs life expectancy
hist(x = gapminder$lifeExp, breaks = 50)  # histogram of life expectancy with 50 bins
barplot(table(gapminder$continent),  # frequency count of continents
        xlab = "Continents",
        ylab = "Count")

ggplot(data = gapminder, aes(x = continent, y = lifeExp)) + 
  geom_boxplot()+ # creates box plots to compare life expectancy distributions by continent
  xlab("Life Expectancy") + 
  ggtitle("Box plots of life expectancy in different continents")

temperature <- c(77, 71, 71, 78, 67, 76, 68, 82, 64, 71, 81, 69, 63, 70, 77, 75, 76, 68)  # numeric vector
hist(temperature, col = "red")  # histogram of temperature values

# jpeg(file = "plot1.jpeg")  # open JPEG graphics device
# hist(temperature, col = "darkgreen")  # save histogram as image
# dev.off()  # close graphics device

# Descriptive Statistics

glimpse(gapminder)  # compact structure of dataset
summary(gapminder)  # summary statistics for all variables

gapminder %>%
  group_by(continent) %>%  # group data by continent
  summarise(count = n(),   # number of observations
            mu = mean(lifeExp),  # mean life expectancy
            pop_med = median(lifeExp),  # median
            sigma = sd(lifeExp),  # standard deviation
            pop_iqr = IQR(lifeExp),  # interquartile range
            pop_min = min(lifeExp),  # minimum
            pop_max = max(lifeExp),  # maximum
            pop_q1 = quantile(lifeExp, 0.25),  # first quartile
            pop_q3 = quantile(lifeExp, 0.75))  # third quartile

gapminder %>%
  group_by(continent) %>%
  summarise(count = n(),
            mu = mean(gdpPercap),  # mean GDP per capita
            pop_med = median(gdpPercap),
            sigma = sd(gdpPercap),
            pop_iqr = IQR(gdpPercap),
            pop_min = min(gdpPercap),
            pop_max = max(gdpPercap),
            pop_q1 = quantile(gdpPercap, 0.25),
            pop_q3 = quantile(gdpPercap, 0.75))

barplot(table(gapminder$continent),
        xlab = "Continents",
        ylab = "Count")

# Plot kernel density estimate of life expectancy
plot(x = density(x = gapminder$lifeExp, bw = 0.5, na.rm = TRUE))  # bw controls smoothness

# Scatterplot with reference lines
plot(x = gapminder$gdpPercap, y = gapminder$lifeExp, type = "p",
     xlab = "GDP per capita", 
     ylab = "Life Expectancy", 
     main = "Scatterplot - 1 vertical and 1 horizontal reference lines")

abline(v = 40000, h = 75, lty = 2, col="red")  # add vertical & horizontal reference lines


#######################################################
# Project 1 Conclusion
#
# The exploratory analysis shows clear variation in life expectancy
# across continents. Higher GDP per capita is generally associated
# with higher life expectancy, indicating a positive relationship
# between economic development and health outcomes.
#
# Boxplots and density plots highlight distribution differences,
# while summary statistics provide continent-level comparisons.
#######################################################



#######################################################
# PROJECT 2: Sampling Distributions & Statistical Inference
# Understanding the Central Limit Theorem Using Housing Data
#
# Objective:
# To demonstrate sampling distributions, variability, and the
# effect of sample size using the Ames Housing dataset.
#
# This project demonstrates:
# - Simulation techniques
# - Sampling distributions
# - Central Limit Theorem
# - Effect of sample size on variability
#######################################################

######################################################
#  Statistical Inference
######################################################

ames <- read.csv("http://bit.ly/315N5R5")  # load Ames housing dataset
dplyr::glimpse(ames)  # inspect structure

# Sampling Distribution

area <- ames$Gr.Liv.Area  # extract living area variable
price <- ames$SalePrice   # extract sale price variable

head(area, n=10)  # first 10 observations
head(price, n=10)

length(area)  # total number of houses
## [1] 2930

any(is.na(area))  # check for missing values
## [1] FALSE

area.pop.sd <- sd(area)  # population standard deviation (treated as population here)
area.pop.sd

summary(area)  # descriptive statistics

hist(area,
     main = "Histogram of above ground living area",
     xlab = "Above ground living area (sq.ft.)",
)

area <- ames$Gr.Liv.Area

samp1 <- sample(area, 50)  # random sample of 50 houses

mean(samp1)  # sample mean (will differ from population mean)

area <- ames$Gr.Liv.Area 
sample_means50 <- rep(NA, 5000)  # create empty vector to store sample means

for(i in 1:5000){       # repeat sampling 5000 times
  samp <- sample(area, 50)
  sample_means50[i] <- mean(samp)
}

hist(sample_means50, breaks = 25, 
     main = "Sampling distribution of sample mean for Above ground living area",
     xlab = "Means (sq.ft.)")  # distribution approximates normal (CLT)

area <- ames$Gr.Liv.Area 
sample_means_small <- rep(0, 100)

for(i in 1:100){
  samp <- sample(area, 50)
  sample_means_small[i] <- mean(samp)
}

hist(sample_means_small, breaks = 25)  # smaller simulation size

# Sample Size and Sampling Distribution

area <- ames$Gr.Liv.Area 
sample_means50 <- rep(NA, 5000)

for(i in 1:5000){
  samp <- sample(area, 50)
  sample_means50[i] <- mean(samp)
}

hist(sample_means50)

area <- ames$Gr.Liv.Area 
sample_means10 <- rep(NA, 5000)
sample_means50 <- rep(NA, 5000)
sample_means100 <- rep(NA, 5000)

for(i in 1:5000){
  samp <- sample(area, 10)     # small sample
  sample_means10[i] <- mean(samp)
  samp <- sample(area, 50)     # medium sample
  sample_means50[i] <- mean(samp)
  samp <- sample(area, 100)    # large sample
  sample_means100[i] <- mean(samp)
}

par(mfrow = c(3, 1))  # display 3 histograms in one column

xlimits <- range(sample_means10)

hist(sample_means10,  breaks = 25, xlim = xlimits)   # more variability
hist(sample_means50,  breaks = 25, xlim = xlimits)   # less variability
hist(sample_means100, breaks = 25, xlim = xlimits)   # even tighter distribution


#######################################################
# Project 2 Conclusion
#
# The simulation demonstrates that as sample size increases,
# the sampling distribution of the mean becomes less variable
# and more normally distributed.
#
# This illustrates the Central Limit Theorem and highlights
# the importance of larger sample sizes in statistical inference.
#######################################################



#######################################################
# PROJECT 3: Hypothesis Testing
# Impact of Maternal Smoking on Infant Birth Weight
#
# Objective:
# To determine whether there is a statistically significant
# difference in baby birth weight between smoking and
# non-smoking mothers.
#
# This project demonstrates:
# - Two-sample t-tests
# - Confidence intervals
# - Statistical hypothesis testing
#######################################################

######################################################
#  Hypothesis Testing
######################################################

nc <- read.csv("http://bit.ly/31adfCe")  # North Carolina birth dataset
summary(nc)

data = na.omit(nc)  # remove missing values

boxplot(data$weight ~ data$habit ,
        main = "Mother's Habit vs baby's Weight",
        ylab = "Baby's Weight",
        xlab = "Smoking Habit",
        col = c("red", "green")
)
legend("topleft", c("nonsmoker", "smoker"), fill = c("red", "green"))

statsr::inference(y = weight, x = habit, data = nc, 
                  statistic = c("mean"), 
                  type = c("ci"), 
                  null = 0,
                  alternative = c("twosided"), 
                  method = c("theoretical"), 
                  conf_level = 0.95,
                  order = c("smoker","nonsmoker"))

data = na.omit(nc)

statsr::inference(y = weight, x = habit, data = data, 
                  statistic = c("mean"), 
                  type = c("ht"), 
                  null = 0,
                  alternative = c("twosided"), 
                  method = c("theoretical"), 
                  conf_level = 0.95,
                  order = c("smoker","nonsmoker"))

smoker      <- data$weight[data$habit=="smoker"]
nonsmoker   <- data$weight[data$habit=="nonsmoker"]

t.test(smoker, nonsmoker, alternative="two.sided", conf.level = 0.95)


#######################################################
# Project 3 Conclusion
#
# The hypothesis test evaluates whether smoking status
# is associated with differences in infant birth weight.
# The results provide statistical evidence regarding
# whether the observed difference is significant.
#######################################################



#######################################################
# PROJECT 4: Correlation & Regression Modeling
# Predicting Credit Card Balance
#
# Objective:
# To analyze factors affecting credit card balances using
# correlation analysis and multiple regression modeling.
#
# This project demonstrates:
# - Correlation matrices
# - Multiple linear regression
# - Interaction effects
# - Prediction intervals
# - Model diagnostics
#######################################################

######################################################
#  Correlation and Regression
######################################################

if("tidyverse" %in% rownames(installed.packages()) == FALSE) {install.packages("tidyverse")}
library(tidyverse)

credit <- read_csv("http://bit.ly/33a5A8P")
glimpse(credit)

credit_brief <- credit  %>%
  select(Balance, Limit, Income, Age, Gender)

summary(credit_brief)

table(credit_brief$Gender)

credit %>%
  select(Balance, Limit, Income, Age) %>%
  cor()

p1 <- ggplot(credit, aes(x = Age, y = Balance)) +
  geom_point() +
  labs(x = "Age", y = "Credit card balance (in $)", title = "Relationship between balance and age") +
  geom_smooth(method = "lm", se = FALSE)

p2 <- ggplot(credit, aes(x = Income, y = Balance)) +
  geom_point() +
  labs(x = "Income (in $1000)", y = "Credit card balance (in $)", title = "Relationship between balance and income") +
  geom_smooth(method = "lm", se = FALSE)

p3 <- ggplot(credit, aes(x = Limit, y = Balance)) +
  geom_point() +
  labs(x = "Limit", y = "Credit card balance (in $)", title = "Relationship between balance and limit") +
  geom_smooth(method = "lm", se = FALSE)

p1
p2
p3

Balance_model <- lm(Balance ~ Income + Age, data = credit)
summary(Balance_model)

newpers <- data.frame(Income = 30, Age = 35)
predict(Balance_model, newpers)
predict(Balance_model, newpers, interval = "prediction", level = 0.95)

Balance_model2 <- lm(Balance ~ Income + Age + Gender, data = credit)
summary(Balance_model2)

newpers2 <- data.frame(Income = 25, Age = 25, Gender = "Female")
predict(Balance_model2, newpers2, interval = "prediction", level = 0.95)

Balance_model3 <- lm(Balance ~ Income * Gender + Age, data = credit)
summary(Balance_model3)

predict(Balance_model3, newpers2, interval = "prediction", level = 0.95)

plot(Balance_model$residuals ~ credit$Age)
plot(Balance_model$residuals ~ credit$Income)

log_transform <- credit %>% mutate(logincome = log(Income))

Balance_model_log <- lm(Balance ~ logincome + Age, data = log_transform)

hist(Balance_model_log$residuals)
qqnorm(Balance_model_log$residuals)
qqline(Balance_model_log$residuals)

plot(Balance_model_log$residuals ~ Balance_model_log$fitted)


#######################################################
# Project 4 Conclusion
#
# Regression analysis reveals relationships between income,
# age, gender, credit limit, and credit card balance.
#
# Multiple model specifications, including interaction terms,
# provide insight into how demographic and financial variables
# influence debt levels.
#
# Diagnostic plots assess model assumptions, and prediction
# intervals provide realistic forecasting estimates.
#######################################################