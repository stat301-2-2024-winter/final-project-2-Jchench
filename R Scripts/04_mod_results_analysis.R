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
load(here("results/fit_multinomial2.rda"))
load(here("results/tuned_rf.rda"))
load(here("results/tuned_rf2.rda"))
load(here("results/tuned_boost.rda"))
load(here("results/tuned_boost2.rda"))
load(here("results/tuned_knn.rda"))
load(here("results/tuned_knn2.rda"))
load(here("results/tuned_elastic.rda"))
load(here("results/tuned_elastic2.rda"))

# parallel processing
library(doMC)

num_cores <- parallel::detectCores(logical = TRUE)

registerDoMC(cores = num_cores)

# naive bayes
predict_naive <- 
  fit_naive |> 
  collect_metrics() |> 
  filter(.metric == "roc_auc") |> 
  mutate(model = "naive bayes")

# multinomial
predict_multinomial <- 
  fit_multinomial |> 
  collect_metrics() |> 
  filter(.metric == "roc_auc") |> 
  mutate(model = "multinomial")

predict_multinomial2 <- 
  fit_multinomial2 |> 
  collect_metrics() |> 
  filter(.metric == "roc_auc") |> 
  mutate(model = "multinomial2")

# knn
predict_knn <- 
  tuned_knn |> 
  show_best("roc_auc") |> 
  slice_max(mean) |> 
  mutate(model = "k nearest neighbor")

predict_knn2 <- 
  tuned_knn2 |> 
  show_best("roc_auc") |> 
  slice_max(mean) |> 
  mutate(model = "k nearest neighbor2")

# elastic net
predict_elastic <- 
  tuned_elastic |> 
  show_best("roc_auc") |> 
  slice_max(mean) |> 
  mutate(model = "elastic net")

predict_elastic2 <- 
  tuned_elastic2 |> 
  show_best("roc_auc") |> 
  slice_max(mean) |> 
  mutate(model = "elastic net2")

# rf
predict_rf <- 
  tuned_rf |> 
  show_best("roc_auc") |> 
  slice_max(mean) |> 
  mutate(model = "random forest")

predict_rf2 <- 
  tuned_rf2 |> 
  show_best("roc_auc") |> 
  slice_max(mean) |> 
  mutate(model = "random forest2")

# bt
predict_boost <- 
  tuned_boost |> 
  show_best("roc_auc") |> 
  slice_max(mean) |> 
  mutate(model = "boosted tree")

predict_boost2 <- 
  tuned_boost2 |> 
  show_best("roc_auc") |> 
  slice_max(mean) |> 
  mutate(model = "boosted tree2")

# make a table
results_table <- 
  predict_naive |> 
  bind_rows(predict_multinomial, predict_multinomial2, predict_knn, predict_knn2,
            predict_elastic, predict_elastic2, predict_rf, predict_rf2, 
            predict_boost, predict_boost2) |> 
  select(model, .metric, mean, std_err) |> 
  arrange(desc(mean))

