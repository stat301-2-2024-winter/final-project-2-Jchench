# splitting dataset, folds

# load packages ----
library(tidyverse)
library(tidymodels)
library(here)
library(naniar)

# handle common conflicts
tidymodels_prefer()

# load data
drop_out_dat <- read_rds(here("data/dropout_data_cleaned"))

# split data ----
set.seed(301)

drop_out_split <- 
  drop_out_dat |> 
  initial_split(prop = 0.75, strata = target)

drop_out_train <- training(drop_out_split)
drop_out_test <- testing(drop_out_split)

# save out
save(drop_out_split, drop_out_test, drop_out_train, file = here("results/drop_out_split.rda"))

# resampling ----
drop_out_folds <- 
  vfold_cv(drop_out_train, v = 10, repeats = 5,
           strata = target)

#save out
save(drop_out_folds, file = here("results/drop_out_folds.rda"))

  