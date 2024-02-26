# Defining recipes

# load packages ----
library(tidyverse)
library(tidymodels)
library(here)
library(naniar)
library(xgboost)

# handle common conflicts
tidymodels_prefer()

# load results
load(here("results/drop_out_split.rda"))
load(here("results/drop_out_folds.rda"))

# load recipes
load(here("results/baseline_recipes.rda"))

# parallel processing
library(doMC)

num_cores <- parallel::detectCores(logical = TRUE)

registerDoMC(cores = num_cores)

set.seed(301)
# model spec
boost_spec <- 
  boost_tree(mode = "classification", 
             min_n = tune(), 
             mtry = tune(), 
             learn_rate = tune()) |> 
  set_engine("xgboost")

# define workflow
boost_workflow <- 
  workflow() |> 
  add_model(boost_spec) |> 
  add_recipe(baseline_recipe_trees)

# hyperparameter tuning values
boost_params <- 
  extract_parameter_set_dials(boost_spec) |> 
  update(mtry = mtry(range = c(1, 14))) |> 
  update(learn_rate = learn_rate(range = c(-5, -0.2)))

boost_grid <- 
  grid_regular(boost_params, levels = 5)

# fit workflows/models
tuned_boost <- 
  tune_grid(boost_workflow,
            drop_out_folds,
            grid = boost_grid,
            control = control_grid(save_workflow = TRUE))

# save out

