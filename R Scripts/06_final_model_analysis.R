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
load(here("results/final_fit.rda"))

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

# assessment ----

pred_final_fit <- 
  drop_out_test |> 
  select(target) |> 
  bind_cols(predict(final_fit, drop_out_test))

# accuracy

pred_accuracy <- 
  accuracy(pred_final_fit, target, .pred_class)

# roc_auc

pred_prod <- 
  predict(final_fit, drop_out_test, type = "prob")

pred_prob <- 
  pred_prod |> 
  bind_cols(pred_final_fit)

pred_curve <- 
  roc_curve(pred_prob, target, c(.pred_Dropout, .pred_Enrolled, .pred_Graduate)) |> 
  autoplot()

# confusion matrix

predict_conf <- 
  conf_mat(pred_final_fit, target, .pred_class)

save(pred_accuracy, pred_curve, predict_conf, file = here("results/fina_metrics.rda"))
