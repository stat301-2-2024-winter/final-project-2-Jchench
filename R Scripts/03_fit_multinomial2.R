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
multinom_spec <- 
  multinom_reg(penalty = 0) |> 
  set_engine("nnet") |> 
  set_mode("classification")

# define workflow
multinom_workflow2 <- 
  workflow() |> 
  add_model(multinom_spec) |> 
  add_recipe(main_recipe)

# fit
fit_multinomial2 <- 
  fit_resamples(multinom_workflow2, 
                resamples = drop_out_folds,
                control = control_resamples())

# save out
save(fit_multinomial2, file = here("results/fit_multinomial2.rda"))

