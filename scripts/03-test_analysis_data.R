#### Preamble ####
# Purpose: Tests the structure and validity of the final cleaned CCHS dataset
# Author: Chris Yong Hong Sen 
# Date: 02 December 2024
# Contact: luke.yong@mail.utoronto.ca
# License: MIT
# Pre-requisites: 
# - The `tidyverse` package must be installed and loaded
# - 02-clean_data.R must have been run
# Any other information needed? Make sure you are in the `physical_activity_ontario` rproj


#### Workspace setup ####
library(tidyverse)
library(testthat)

analysis_data <- read_parquet("data/02-analysis_data/analysis_data.parquet")

nrow(analysis_data)
#### Test data ####
# Test that the dataset has 14,121 rows - there are 14,121 Ontario individuals in 
# the CCHS dataset 
test_that("dataset has 14,121 observations", {
  expect_equal(nrow(analysis_data), 14121)
})

# Test that the dataset has 9 columns
test_that("dataset has 9 columns", {
  expect_equal(ncol(analysis_data), 9)
})

# Test that the all columns is numeric type
test_that("all columns are numeric", {
  numeric_check <- sapply(analysis_data, is.numeric)
  expect_true(all(numeric_check), "not all columns are numeric")
})

# Test that there are no missing values in the dataset
test_that("no missing values in dataset", {
  expect_true(all(!is.na(analysis_data)))
})

# Test that there are no missing values in the dataset
test_that("no missing values in dataset", {
  expect_true(all(!is.na(analysis_data)))
})


# Test if all values in the 'time_spent_physical_activity_7d' response column
# are within valid time range of 7 weeks in minutes
test_that("All values in response column are valid.", {
  expect_true(all(between(analysis_data$time_spent_vigorous_exercise_7d, 0, 10080)))
})

# Check if all values in the 'freq_alc_drank' column have valid bins
# from 1 to 7 inclusive
test_that("All values in freq_alc_drank column are valid.", {
  expect_true(all(between(analysis_data$num_alc_drank_12m, 1, 7)))
})

# Check if all values in the 'sex' column are strictly 0 (females) and 1 (males)
test_that("'sex' column has valid observations 0 or 1.", {
  expect_true(all(analysis_data$sex %in% c(0,1)))
})

# Check if all values in the 'age' column have correct bins from  0 (females) 
# and 1 (males)
test_that("'age' column contains only valid age bins.", {
  expect_true(all(between(analysis_data$age, 3,14)))
})

# Check if all values in the 'personal_income' column have correct bins from  
# 1 to 6 
test_that("'personal_income' column contains only valid age bins.", {
  expect_true(all(between(analysis_data$personal_income, 1,6)))
})

# Check if all values in the 'highest_educational_attainment' column have correct bins from  
# 1 to 3 
test_that("'highest_educational_attainment' column contains only valid education bins.", {
  expect_true(all(between(analysis_data$highest_educational_attainment, 1,3)))
})


# Check if all values in the 'health_region' column have correct health region 
# values from 35926 to 35995 as defined by CCHS dataset
test_that("'health_region' column contains only valid regions", {
  expect_true(all(between(analysis_data$health_region, 35926,35995)))
})


# Check if all values in the 'smoked_hundred_cigarettes' column only contains binary value
test_that("'smoked_hundred_cigarettes' column contains only valid values", {
  expect_true(all(between(analysis_data$smoked_hundred_cigarettes, 0, 1)))
})

# Check if all values in the 'illicit_drug_use' column only contains binary value
test_that("'illicit_drug_use' column contains only valid values", {
  expect_true(all(between(analysis_data$illicit_drug_use, 0, 1)))
})