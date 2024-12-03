#### Preamble ####
# Purpose: Simulates a dataset of CCHS Health Data in Ontario
# Author: Chris Yong Hong Sen 
# Date: 02 December 2024
# Contact: luke.yong@mail.utoronto.ca
# License: MIT
# Pre-requisites: 
#   - The `tidyverse` package must be installed and loaded

#### Workspace setup ####
library(tidyverse)
set.seed(853)

#### Simulate data ####

# Create a dataset by randomly assigning values from response variable and explanatory variables
simulated_data <- tibble(
  
  ### response ###
  # time spent on physical activity
  time_spent_physical_activity_7d = sample(x=seq(0, 10080, 1), 
                                           size=200, 
                                           replace=T),
  ### predictors ###
  
  # frequency of alcohol drank 
  freq_alc_drank = sample(seq(1,7,1), 200,replace=T),
  
  # sex 
  sex = sample(seq(0,1), 200, replace=T),
  
  # age
  age = sample(seq(3,14), 200, replace=T),
  
  # personal income bin
  personal_income = sample(1:6, 200, replace = T, prob = c(0.01, 0.3, 0.4,0.2,0.2, 0.05)),
  
  # highest educational attainment in bins
  highest_educational_attainment = factor(sample(seq(1,3,1), 200, replace = T, prob=c(0.01, 0.4,0.5))),
  
  # health regions in ontario (34 of them)
  health_region = sample(seq(1,34,1), 200, replace=T),
  
  # smoked 100 cigarettes in lifetime
  smoking_status = sample(0:1, 200, replace=T, prob=c(0.7, 0.3)),
  
  # illicit drug use in one's lifetime
  illicit_drug_use = sample(seq(0,1), 200, replace=T, prob = c(0.8, 0.2)),
)



#### Save data ####
write_csv(simulated_data, "data/00-simulated_data/simulated_data.csv")
