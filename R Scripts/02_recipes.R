# Defining recipes

# load packages ----
library(tidyverse)
library(tidymodels)
library(here)
library(naniar)

# handle common conflicts
tidymodels_prefer()

# load results
load(here("results/drop_out_split.rda"))

# Kitchen Sink recipe ----

# For Naive Bayes
baseline_recipe_nb <- 
  recipe(target ~ ., data = drop_out_train) |> 
  step_rm(application_order, application_mode) |> 
  step_zv(all_predictors()) |> 
  step_normalize(all_numeric_predictors())

# prep and bake
prep(baseline_recipe_nb) |> 
  bake(new_data = NULL)

# For Logistic, multinomial, and Elastic Net
baseline_recipe <- 
  recipe(target ~ ., data = drop_out_train) |> 
  step_rm(application_order, application_mode) |> 
  step_dummy(all_nominal_predictors()) |> 
  step_zv(all_predictors()) |> 
  step_normalize(all_numeric_predictors())

# prep and bake
baseline_check <- 
  prep(baseline_recipe) |> 
  bake(new_data = NULL)

# For tree-based models
baseline_recipe_trees <- 
  recipe(target ~ ., data = drop_out_train) |> 
  step_rm(application_order, application_mode) |> 
  step_dummy(all_nominal_predictors(), one_hot = TRUE) |> 
  step_zv(all_predictors()) |> 
  step_normalize(all_numeric_predictors())

# prep and bake
baseline_check_trees <- 
  prep(baseline_recipe_trees) |> 
  bake(new_data = NULL)

# Feature Engineered recipe ----

# for parametric models
main_recipe <- 
  recipe(target ~ fathers_qualification + mothers_qualification + admission_grade +
           previous_qualification_grade + gender + debtor + scholarship_holder +
           curricular_units_1st_sem_grade + curricular_units_2nd_sem_grade,
         data = drop_out_train) |> 
  step_dummy(all_nominal_predictors()) |>
  step_interact(~ admission_grade:previous_qualification_grade) |> 
  step_interact(~ starts_with("fathers_qualification"):starts_with("mothers_qualification")) |> 
  step_interact(~ curricular_units_1st_sem_grade:curricular_units_2nd_sem_grade) |> 
  step_zv(all_predictors()) |> 
  step_normalize(all_numeric_predictors())

# prep and bake

main_recipe_prep_bake <- 
  prep(main_recipe) |> 
  bake(new_data = NULL)

# for tree-based models
main_recipe_trees <- 
  recipe(target ~ fathers_qualification + mothers_qualification + admission_grade +
           previous_qualification_grade + gender + debtor + scholarship_holder +
           curricular_units_1st_sem_grade + curricular_units_2nd_sem_grade,
         data = drop_out_train) |> 
  step_dummy(all_nominal_predictors()) |>
  step_zv(all_predictors()) |> 
  step_normalize(all_numeric_predictors()) |> 
  step_corr(all_predictors())

# step_corr(all_predictors())

trees_recipe_prep_bake <- 
  prep(main_recipe_trees) |> 
  bake(new_data = NULL)

# save out recipes ----
save(baseline_recipe_nb, baseline_recipe, baseline_recipe_trees, 
     file = here("results/baseline_recipes.rda"))

save(main_recipe, main_recipe_trees, file = here("results/recipes.rda"))
