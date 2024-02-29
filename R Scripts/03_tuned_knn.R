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

# load recipes
load(here("results/baseline_recipes.rda"))

# parallel processing
library(doMC)

num_cores <- parallel::detectCores(logical = TRUE)

registerDoMC(cores = num_cores)

# model spec
knn_spec <- 
  nearest_neighbor(mode = "classification", 
                   neighbors = tune()) |> 
  set_engine("kknn")

# define workflow
knn_workflow <- 
  workflow() |> 
  add_model(knn_spec) |> 
  add_recipe(baseline_recipe)

# hyperparameter tuning values
knn_params <- 
  extract_parameter_set_dials(knn_spec)

knn_grid <- 
  grid_regular(knn_params, levels = 5)

# fit workflows/models
tuned_knn <- 
  tune_grid(knn_workflow,
            drop_out_folds,
            grid = knn_grid,
            control = control_grid(save_workflow = TRUE))

# save out
save(tuned_knn, file = here("results/tuned_knn.rda"))
