#### Preamble ####
# Purpose: clean data obotained from https://sda-artsci-utoronto-ca.myaccess.library.utoronto.ca/sdaweb/analysis/?dataset=cchs2017
# Author: Chris Yong Hong Sen
# Date: 20 November 2024
# Contact: luke.yong@mail.utoronto.ca
# License: MIT
# Pre-requisites: knowledge about parsing csv files using tidyverse functinos


#### Workspace setup ####
library(tidyverse)

#### Download data ####
raw_data <- read_csv("data/01-raw_data/raw_data.csv", na='.')

#### Clean data ####

# perform simple col name change and ontario filtering
data_intermediate_1 <- raw_data |>
  janitor::clean_names() |>
  
  # rename variables for easier interprebility and variable handling
  rename(
    # response
    time_spent_vigorous_exercise_7d = paadvmva,
    
    # potential predictors
    num_alc_drank_12m  = alc_015,
    bmi_class = hwtdgbcc,
    has_mood_disorders = ccc_195,
    age = dhhgage,
    sex = dhh_sex,
    illicit_drug_use = drgdvya,
    highest_educational_attainment = ehg2dvr3,
    perceived_life_stress = gen_020,
    perceived_work_stress = gen_025,
    health_region = geodghr4,
    personal_income = incdgper,
    smoked_hundred_cigarettes = smk_020,
    
    # variable to filter province to ontario
    province = geo_prv
  ) |>
  
  
  filter(
    
    # filter for ontario
    province == 35, 
    
    # filter for individuals who are above the age of 18
    age > 2) 




##############################
# cleaning description: perform missing value handling for each variable
# 
# NA-inclusive columns:
#   num_alc_drank_12m; has_mood_disorders; illicit_drug_use; highest_educational_attainment; 
#   perceived_life_stress; perceived_work_stress; bmi_class; personal_income; 
#   time_spent_vigorous_exercise_7d; smoked_hundred_cigarettes;
#
# NOTE: refer to chrome-extension://efaidnbmnnnibpcajpcglclefindmkaj/https://sda-artsci-utoronto-ca.myaccess.library.utoronto.ca/legacy_sda/dli2/cchs/cchs2017/more_doc/CCHS%202017-2018%20PUMF%20Data%20Dictionary.pdf
#       for documentation of codes for each variable.
#
#
###################################

# function returns percentage of observations containing NA for a specific columns
get_weightage <- function(col) {
  no_of_missing <- sum(is.na(data_intermediate_1[col]))
  total_observation <- nrow(data_intermediate_1)
  percent <- round(no_of_missing / total_observation * 100, 2)
  return(paste0('% of observations with NA in ', col, ' col: ', percent, '%'))
}

no_of_missing_val <- colSums(is.na(data_intermediate_1)) 

attr_missing_val <- tibble(col = colnames(data_intermediate_1), no_of_missing_val) |>
  filter(no_of_missing_val != 0) |>
  pull(col)

# return proportion of observations with NA for each column
# findings: overall for most columns, the number of missing values account for less than 4%
#           of the overall observations. However, we have to consider num_alc_drank_12m column
#           with 22% of observations with missing values and perceived_work_stress with 43%
#           of observations with missing values. 
#           
#           I have to drop missing values from num_alc_drank_12m. I am guessing that the number of alcohol drank by an individual from 
#           the past 12 months is highly subjective to each individuals. Hence, it does not make sense
#           to interpolate values to determine how many drinks an individual drank the past 
#           12 months. 
#
#           Also, we have to drop values from perceived_work_stress. Likewise, we are not able
#           to interpolate values for an attribute that is highly subjective, where we are 
#           measuring how an individual perceives their work stress. I have also considered
#           converting missing values to 0 to represent no stress but missing values 
#           includes not only individuals that do not work, but unfortunately also individuals
#           who refuse to answer the question or their response was deemed voided. 
#           Therefore, it would be inaccurate to simply convert missing values to 0.
for (attr in attr_missing_val) {
  print(get_weightage(attr))
}

# result of dropping NA values:
#     I recognise that 46% of original observations were dropped, which is a 
#     fairly high threshold. Vital information could have been lost and this 
#     is the trade off which will be discussed in the paper. However, the total
#     number of observations (14121 observations) is still large enough to perform 
#     modelling.

original_no_observations <- nrow(data_intermediate_1)

data_intermediate2 <- data_intermediate_1 |>
  drop_na()

final_no_observations <- nrow(data_intermediate2)

paste0(round(final_no_observations/original_no_observations*100,0), '%')

##########################
#  cleaning description: checking for duplicated values.
#
#  note: it is possible for any 2 individuals to have the same values for 
#        the given attributes and response, therefore, we have to keep 
#        duplicated values.
#
##########################
sum(duplicated(data_intermediate2))


##########################
#  cleaning description: 
#
#  note: 
##########################
data_intermediate3 <- data_intermediate2 |>
  mutate(
    # convert 'no' entries in mood_disorders to 0
    has_mood_disorders = ifelse(has_mood_disorders == 2, 0, has_mood_disorders),
    
    # convert 'female' coded 2 to 0
    sex = ifelse(sex == 2, 0, sex),
    
    # convert 'never used drugs' from 2 to 0
    illicit_drug_use = ifelse(illicit_drug_use == 2, 0, illicit_drug_use),
    
    # convert 'never smoked 100 cigarettes' from 2 to 0
    smoked_hundred_cigarettes = ifelse(smoked_hundred_cigarettes == 2, 0, smoked_hundred_cigarettes)
         )

#### Save data ####
# [...UPDATE THIS...]
# change the_raw_data to whatever name you assigned when you downloaded it.
write_csv(data_intermediate3, "data/02-analysis_data/analysis_data.csv")
