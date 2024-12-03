#### Preamble ####
# Purpose: Simple Linear Regression Model
# Author: Chris Yong Hong Sen 
# Date: 24 November 2024
# Contact:luke.yong@mail.utoronto.ca 
# License: MIT
# Pre-requisites: 
# - The `tidyverse` package must be installed and loaded
# - 03-clean_data.R must have been run
# - Knowledge about linear regression models, assumptions about sampling distribution


#### Workspace setup ####
library(tidyverse)
library(fastDummies)
library(arrow) # reading parquet file


#### Read data ####
analysis_data_not_transformed <- read_parquet("data/02-analysis_data/analysis_data.parquet") |>
  filter(time_spent_vigorous_exercise_7d != 0) 

analysis_data <-  analysis_data_not_transformed |>
  mutate(#health_region = factor(health_region),
         time_spent_vigorous_exercise_7d = log(time_spent_vigorous_exercise_7d)) 

# run this if generated column names are in scientific notation
# options(scipen=0)
analysis_data_w_dummies <- dummy_cols(analysis_data, select_columns='health_region', remove_first_dummy = TRUE) |>
  select(-health_region)

analysis_data_not_transformed <- dummy_cols(analysis_data_not_transformed, select_columns='health_region', remove_first_dummy = TRUE) |>
  select(-health_region)

colnames(analysis_data_w_dummies)
### Initial linear regression model ####
#
# predictors: all + interaction terms
# interaction term: 
#    1. age:highest_educational_attainment
#    2. age:sex
#    3. sex:personal_income
colnames(analysis_data_w_dummies)

analysis_data_w_dummies |>
  count(personal_income)

original_lmmodel <- lm(time_spent_vigorous_exercise_7d ~ ., #+
              # age:highest_educational_attainment +
              # age:sex +
              # sex:personal_income,
                          # age+ 
                          # highest_educational_attainment+
                          # personal_income+
                          # smoked_hundred_cigarettes+
                          # # perceived_work_stress+
                          # # illicit_drug_use+
                          # health_region +
                          # num_alc_drank_12m,
              data = analysis_data_w_dummies)

original_lmmodel_not_transformed <- lm(time_spent_vigorous_exercise_7d ~ ., #+
                       # age:highest_educational_attainment +
                       # age:sex +
                       # sex:personal_income,
                       # age+ 
                       # highest_educational_attainment+
                       # personal_income+
                       # smoked_hundred_cigarettes+
                       # # perceived_work_stress+
                       # # illicit_drug_use+
                       # health_region +
                       # num_alc_drank_12m,
                       data = analysis_data_not_transformed)
# obtain summary plots to check linear regression assumptions
# 1. normality of sampling distribution
# 2. homoscedasticity (random variance)
# 3. independance of residuals 
plot(original_lmmodel)

# obtain summary plots 
summary(original_lmmodel)


# obtain histogram of response variable (log)
hist(analysis_data_w_dummies$time_spent_vigorous_exercise_7d)



##############################
# Model scoring metric: F test hypothesis testing
#
# rationale: from comparing reduced model by any 1 predictor with 
#            the full model, we can deduce if the removal of the 
#            predictor results in difference in regression power
#            of in the reduced model
#
# goal: remove predictors that fail the anova F test, which means 
#       removing the predictor does not change the power of the 
#       reduced model. This decreases complexity of linear regression 
# 
##############################
predictors <- colnames(analysis_data_w_dummies |>
  select(-time_spent_vigorous_exercise_7d))

p_value_vec <- c()
for (pred in predictors) {
  
  reduced_data <- analysis_data_w_dummies |> select(-all_of(pred)) 
  reduced_model <- lm(time_spent_vigorous_exercise_7d ~ ., data = reduced_data)
  partial_f_test_p_value <- anova(reduced_model, original_lmmodel)$`Pr(>F)`[2]
  p_value_vec <- c(p_value_vec, partial_f_test_p_value)
}

p_value_tibble <- tibble(
  predictors,
  p_value = p_value_vec
)

# based on this, we eliminate 25 health regions
p_value_tibble

predictors_to_remove <- p_value_tibble |>
  
  # if p-value is less than or equal to alpha=0.05, this means
  # there is a 95% chance that the power of reduced model
  # decreasing is not by chance, and implies that the removed 
  # predictor is important in explaining our response.
  filter(p_value > 0.05) |>
  
  # obtain predictors that did not meet F testing significance
  pull(predictors)

# remove unwanted predictors
analysis_data_final <- analysis_data_w_dummies |> 
  select(-all_of(predictors_to_remove))

# obtain final model from partial f test
final_model_f_test <- lm(time_spent_vigorous_exercise_7d ~., data = analysis_data_final)

# report final model from BIC algorithm
summary(final_model_f_test)

# report confidence intervall
confint(final_model_f_test, level = 0.95)


#################################
# Model scoring: Bayesian Information Criterion (BIC)
#
# rationale: we use this to further penalise complex models while 
#            still minimising errors. 
#
# goal: obtain a minimal linear regression model that has the least 
#       predictors and the most information for our response.
# 
##################################

final_model <- step(original_lmmodel, direction = 'backward', k = log(nrow(analysis_data_w_dummies)))

# report final model from BIC algorithm
summary(final_model)
final_model
# reporting BIC value of original and final model
# difference greater than 10 suggest significant improvement
BIC(original_lmmodel)
BIC(final_model) 

# report confidence intervall
confint(final_model, level = 0.95)

# note for model goodness of fit:
# R2 and adjusted R2 might not be reliable 
summary(final_model)

# ensure no multicollinearity, values should be lower than 10 for each predictor
library(car)
vif(final_model)

#### Save model ####
#final_model
saveRDS(
  final_model,
  file = "models/final_model.rds"
)

#original model with not transformed y variable
saveRDS(
  original_lmmodel_not_transformed,
  file = "models/original_model_not_transformed.rds"
)

saveRDS(
  original_lmmodel,
  file = "models/original_model.rds"
)

