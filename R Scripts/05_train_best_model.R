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
load(here("results/tuned_boost.rda"))

# parallel processing
library(doMC)

num_cores <- parallel::detectCores(logical = TRUE)

registerDoMC(cores = num_cores)

# show best
best_rf_param <- select_best(tuned_boost)

# parallel processing
num_cores <- parallel::detectCores(logical = TRUE)

library(doMC)

registerDoMC(cores = num_cores)

# finalize workflow ----
final_wflow <- 
  tuned_boost |> 
  extract_workflow(tuned_boost) |>  
  finalize_workflow(select_best(tuned_boost, metric = "roc_auc"))

# train final model ----
# set seed
set.seed(301)
final_fit <- fit(final_wflow, drop_out_train)

# save out
save(final_fit, file = here("results/final_fit"))
save(best_rf_param , file = here("results/best_bt_param.rda"))

