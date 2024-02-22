# Defining recipes

# load packages ----
library(tidyverse)
library(tidymodels)
library(here)
library(naniar)
library(discrim)
library(klaR)

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

# model spec
naive_spec <- 
  naive_Bayes() |> 
  set_mode("classification") |> 
  set_engine("klaR")

# define workflow
naive_workflow <- 
  workflow() |> 
  add_model(naive_spec) |> 
  add_recipe(baseline_recipe_nb)

# fit
fit_naive <- 
  fit_resamples(naive_workflow, 
                resamples = drop_out_folds,
                control = control_resamples())

# save out
save(fit_naive, file = here("results/fit_naive.rda"))

