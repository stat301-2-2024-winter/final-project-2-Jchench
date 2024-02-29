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
load(here("results/recipes.rda"))

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
knn_workflow2 <- 
  workflow() |> 
  add_model(knn_spec) |> 
  add_recipe(main_recipe)

# hyperparameter tuning values
knn_params2 <- 
  extract_parameter_set_dials(knn_spec)

knn_grid2 <- 
  grid_regular(knn_params2, levels = 5)

# fit workflows/models
tuned_knn2 <- 
  tune_grid(knn_workflow2,
            drop_out_folds,
            grid = knn_grid2,
            control = control_grid(save_workflow = TRUE))

# save out
save(tuned_knn2, file = here("results/tuned_knn2.rda"))
