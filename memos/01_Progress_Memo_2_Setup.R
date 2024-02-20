### Progress Memo 1 Data

library(tidyverse)
library(tidymodels)
library(here)

# read in data
drop_out_dat <- read_rds(here("data/dropout_data_cleaned"))
