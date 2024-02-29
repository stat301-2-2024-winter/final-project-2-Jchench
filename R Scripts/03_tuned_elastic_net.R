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
elastic_spec <- 
  multinom_reg(penalty = tune(), 
             mixture = tune()) |>
  set_engine("glmnet")

# define workflow
elastic_workflow <- 
  workflow() |> 
  add_model(elastic_spec) |> 
  add_recipe(baseline_recipe)

# hyperparameter tuning values
elastic_params <- 
  extract_parameter_set_dials(elastic_spec) |> 
  update(mixture = mixture(range = c(0, 1))) |> 
  update(penalty = penalty(range = c(-2, 0)))

elastic_grid <- 
  grid_regular(elastic_params, levels = 5)

# fit workflows/models
tuned_elastic <- 
  tune_grid(elastic_workflow,
            drop_out_folds,
            grid = elastic_grid,
            control = control_grid(save_workflow = TRUE))

# save out
save(tuned_elastic, file = here("results/tuned_elastic.rda"))

