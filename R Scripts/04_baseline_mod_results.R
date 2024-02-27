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

# naive bayes
predict_naive <- 
  fit_naive |> 
  collect_metrics() |> 
  mutate(model = "naive bayes")

# multinomial
predict_multinomial <- 
  fit_multinomial |> 
  collect_metrics() |> 
  mutate(model = "multinomial")

# make a table
baseline_results_table <- 
  predict_naive |> 
  bind_rows(predict_multinomial) |> 
  select(-.config, -.estimator, -n)

# save out
save(baseline_results_table, file = here("results/baseline_results_table.rda"))

