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

# define workflow

# hyperparameter tuning values

# fit workflows/models

# save out

