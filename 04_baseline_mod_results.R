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
load(here("results/fit_naive.rda"))
load(here("results/fit_multinomial.rda"))

# load recipes
load(here("results/baseline_recipes.rda"))

# parallel processing
library(doMC)

num_cores <- parallel::detectCores(logical = TRUE)

registerDoMC(cores = num_cores)

# naive bayes
predict_naive <- 
  fit_naive |> 
  collect_metrics()

# multinomial
predict_multinomial <- 
  fit_multinomial |> 
  collect_metrics()

