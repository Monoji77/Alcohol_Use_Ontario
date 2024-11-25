#### Preamble ####
# Purpose: Simple Linear Regression Model
# Author: Chris Yong Hong Sen 
# Date: 24 November 2024
# Contact:luke.yong@mail.utoronto.ca 
# License: MIT
# Pre-requisites: Knowledge about linear regression models, assumptions about sampling distributino


#### Workspace setup ####
library(tidyverse)
library(fastDummies)

#### Read data ####
analysis_data <- read_csv("data/02-analysis_data/analysis_data.csv") |>
  filter(time_spent_vigorous_exercise_7d != 0)  |>
  mutate(#health_region = factor(health_region),
         time_spent_vigorous_exercise_7d = log(time_spent_vigorous_exercise_7d)) |>
  select(-province)

# run this if generated column names are in scientific notation
# options(scipen=0)
analysis_data_w_dummies <- dummy_cols(analysis_data, select_columns='health_region', remove_first_dummy = TRUE) |>
  select(-health_region)

colnames(analysis_data)
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

# obtain summary plots to check linear regression assumptions
# 1. normality of sampling distribution
# 2. homoscedasticity (random variance)
# 3. independance of residuals 
plot(original_lmmodel)

# obtain summary plots 
summary(original_lmmodel)

# obtain histogram of response variable (log)
hist(analysis_data_w_dummies$time_spent_vigorous_exercise_7d)

predictors <- colnames(analysis_data_w_dummies |>
  select(-time_spent_vigorous_exercise_7d))

p_value_vec <- c()
for (pred in predictors) {
  reduced_data <- analysis_data_w_dummies |> select(-all_of(pred)) 
  
  # age:highest_educational_attainment +
  #   age:sex +
  # sex:personal_income
  # if (pred == 'age') {
  #   reduced_model <- lm(time_spent_vigorous_exercise_7d ~ .+sex:personal_income, data = reduced_data)
  # } else if (pred == 'highest_educational_attainment') {
  #   reduced_model <- lm(time_spent_vigorous_exercise_7d ~ . + age:sex + sex:personal_income, data = reduced_data)
  # } else if (pred == 'sex') {
  #   reduced_model <- lm(time_spent_vigorous_exercise_7d ~ . + age:highest_educational_attainment, data = reduced_data)
  # } else if (pred == 'personal_income') {
  #   reduced_model <- lm(time_spent_vigorous_exercise_7d ~ . + age:highest_educational_attainment + age:sex, data = reduced_data) 
  # } else {
  #   reduced_model <- lm(time_spent_vigorous_exercise_7d ~ ., data = reduced_data)
  # }
  reduced_model <- lm(time_spent_vigorous_exercise_7d ~ ., data = reduced_data)
  
  partial_f_test_p_value <- anova(reduced_model, original_lmmodel)$`Pr(>F)`[2]
  p_value_vec <- c(p_value_vec, partial_f_test_p_value)
}

p_value_tibble <- tibble(
  predictors,
  p_value = p_value_vec
)

# based on this, we shouldn't eliminate any features but our complexity is now 14 predictors
view(p_value_tibble)

# use BIC instead as it penalises complex models while minimising errors
final_model <- step(original_lmmodel, direction = 'both', k = log(nrow(analysis_data_w_dummies)))

# reporting BIC value of original and final model
# difference greater than 10 suggest signicant improvement
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
saveRDS(
  final_model,
  file = "models/final_model.rds"
)


