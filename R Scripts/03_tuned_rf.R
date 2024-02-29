# Defining recipes

# load packages ----
library(tidyverse)
library(tidymodels)
library(here)
library(naniar)

# handle common conflicts
tidymodels_prefer()

# load results
load(here("results/drop_out_folds.rda"))

# load recipe
load(here("results/baseline_recipes.rda"))

# parallel processing
library(doMC)

num_cores <- parallel::detectCores(logical = TRUE)

registerDoMC(cores = num_cores)

set.seed(301)
# model spec
rf_spec <- 
  rand_forest(mode = "classification", 
             min_n = tune(), 
             mtry = tune()) |> 
  set_engine("ranger")

# define workflow
rf_workflow <- 
  workflow() |> 
  add_model(rf_spec) |> 
  add_recipe(baseline_recipe_trees)

# hyperparameter tuning values
rf_params <- 
  extract_parameter_set_dials(rf_spec) |> 
  update(mtry = mtry(range = c(1, 220))) |> 
  update(min_n = min_n(range = c(2, 15)))

rf_grid <- 
  grid_regular(rf_params, levels = 5)

# fit workflows/models
tuned_rf <- 
  tune_grid(rf_workflow,
            drop_out_folds,
            grid = rf_grid,
            control = control_grid(save_workflow = TRUE))

# save out
save(tuned_rf, file = here("results/tuned_rf.rda"))
