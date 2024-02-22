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

# load recipes
load(here("results/baseline_recipes.rda"))

# parallel processing
library(doMC)

num_cores <- parallel::detectCores(logical = TRUE)

registerDoMC(cores = num_cores)

# model spec
logistic_spec <- 
  logistic_reg() |> 
  set_engine("glm") |> 
  set_mode("classification")

# define workflow
logistic_workflow <- 
  workflow() |> 
  add_model(logistic_spec) |> 
  add_recipe(baseline_recipe)

# fit
logistic_fit <- 
  fit_resamples(logistic_workflow, 
                resamples = drop_out_folds,
                control = control_resamples())

# save out


