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


  # step_corr(all_predictors())

# prep and bake
prep(baseline_recipe_trees) |> 
  bake(new_data = NULL)

# save out recipes ----
save(baseline_recipe_nb, baseline_recipe, baseline_recipe_trees, file = here("results/baseline_recipes.rda"))
