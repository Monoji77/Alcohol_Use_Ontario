#### Preamble ####
# Purpose: Tests the structure and validity of the simulated CCHS dataset
# Author: Chris Yong Hong Sen 
# Date: 02 December 2024
# Contact: luke.yong@mail.utoronto.ca
# License: MIT
# Pre-requisites: 
  # - The `tidyverse` package must be installed and loaded
  # - 00-simulate_data.R must have been run
# Any other information needed? Make sure you are in the `physical_activity_ontario` rproj


#### Workspace setup ####
library(tidyverse)

analysis_data <- read_csv("data/00-simulated_data/simulated_data.csv")

# Test if the data was successfully loaded
if (exists("analysis_data")) {
  message("Test Passed: The dataset was successfully loaded.")
} else {
  stop("Test Failed: The dataset could not be loaded.")
}


#### Test data ####

# Check if the dataset has 200 rows
if (nrow(analysis_data) == 200) {
  message("Test Passed: The dataset has 200 rows.")
} else {
  stop("Test Failed: The dataset does not have 200 rows.")
}

# Check if the dataset has 9 columns
if (ncol(analysis_data) == 9) {
  message("Test Passed: The dataset has 9 columns.")
} else {
  stop("Test Failed: The dataset does not have 9 columns.")
}

# Check if all values in the 'time_spent_physical_activity_7d' response column
# are within valid time range of 7 weeks in minutes
if (all(between(analysis_data$time_spent_physical_activity_7d, 0, 10080))) {
  message("Test Passed: All values in response column are valid.")
} else {
  stop("Test Failed: The response column contains invalid values.")
}

# Check if all values in the 'freq_alc_drank' column have valid bins
# from 1 to 7 inclusive
if (all(between(analysis_data$freq_alc_drank, 1, 7))) {
  message("Test Passed: All values in freq_alc_drank column are valid.")
} else {
  stop("Test Failed: The 'freq_alc_drank' column contains invalid values.")
}

# Check if all values in the 'sex' column are strictly 0 (females) and 1 (males)
if (all(analysis_data$sex %in% c(0,1))) {
  message("Test Passed: 'sex' column has valid observations 0 or 1.")
} else {
  stop("Test Failed: The 'sex' column contains invalid values.")
}

# Check if all values in the 'age' column have correct bins from  0 (females) 
# and 1 (males)
if (all(between(analysis_data$age, 3,14))) {
  message("Test Passed: The 'age' column contains only valid age bins.")
} else {
  stop("Test Failed: The 'age' column contains invalid age bins.")
}

# Check if all values in the 'personal_income' column have correct bins from  
# 1 to 6 
if (all(between(analysis_data$personal_income, 1,6))) {
  message("Test Passed: The 'personal_income' column contains only valid income bins.")
} else {
  stop("Test Failed: The 'personal_income' column contains invalid income bins.")
}

# Check if all values in the 'highest_educational_attainment' column have correct bins from  
# 1 to 3 
if (all(between(analysis_data$highest_educational_attainment, 1,3))) {
  message("Test Passed: The 'highest_educational_attainment' column contains only valid education bins.")
} else {
  stop("Test Failed: The 'highest_educational_attainment' column contains invalid education bins.")
}

# Check if all values in the 'health_region' column have correct health region 
# values from 1 to 34
if (all(between(analysis_data$health_region, 1,34))) {
  message("Test Passed: The 'health_region' column contains only valid regions")
} else {
  stop("Test Failed: The 'health_region' column contains invalid regions.")
}

# Check if all values in the 'smoking_status' column only contains binary value
if (all(between(analysis_data$smoking_status, 0, 1))) {
  message("Test Passed: The 'smoking_status' column contains only valid values")
} else {
  stop("Test Failed: The 'smoking_status' column contains invalid values")
}

# Check if all values in the 'illicit_drug_use' column only contains binary value
if (all(between(analysis_data$illicit_drug_use, 0, 1))) {
  message("Test Passed: The 'illicit_drug_use' column contains only valid values")
} else {
  stop("Test Failed: The 'illicit_drug_use' column contains invalid values")
}

# Check if there are any missing values in the dataset
if (all(!is.na(analysis_data))) {
  message("Test Passed: The dataset contains no missing values.")
} else {
  stop("Test Failed: The dataset contains missing values.")
}