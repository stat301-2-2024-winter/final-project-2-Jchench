### Progress Memo 1 Data

library(tidyverse)
library(tidymodels)
library(here)

hist_tornado_dat <- 
  read_csv(here("data/historical-tornado-tracks.csv"))

tornados_data <- 
  read_csv(here("data/tornados.csv"))

