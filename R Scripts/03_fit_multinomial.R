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
load(here("results/drop_out_folds.rda"))

# load recipes
load(here("results/baseline_recipes.rda"))

# parallel processing
library(doMC)

num_cores <- parallel::detectCores(logical = TRUE)

registerDoMC(cores = num_cores)

# model spec
multinom_spec <- 
  multinom_reg(penalty = 0) |> 
  set_engine("nnet") |> 
  set_mode("classification")

# define workflow
multinom_workflow <- 
  workflow() |> 
  add_model(multinom_spec) |> 
  add_recipe(baseline_recipe)

# fit
fit_multinomial <- 
  fit_resamples(multinom_workflow, 
                resamples = drop_out_folds,
                control = control_resamples())

# save out
save(fit_multinomial, file = here("results/fit_multinomial.rda"))
