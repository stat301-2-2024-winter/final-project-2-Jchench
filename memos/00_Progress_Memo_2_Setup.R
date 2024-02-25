### Progress Memo 1 Data

library(tidyverse)
library(tidymodels)
library(here)

# read in data
drop_out_dat <- read_rds(here("data/dropout_data_cleaned"))
load(here("results/drop_out_split.rda"))

# EDA ----

# numeric variables
drop_out_train |> 
  select(where(is.numeric))|> 
  cor(use = "pairwise.complete.obs") |> 
  ggcorrplot::ggcorrplot()

# negative correlation: gdp and unemployment rate, age at enrollment and displaced, debtor and tuition fees up to date
# positive correlation: admission grade and previous qualification grade

# mother's qualifications and father's qualifications
drop_out_train |> 
  ggplot(aes(x = mothers_qualification)) +
  geom_bar() +
  theme(axis.text.x = element_text(angle = 90))

drop_out_train |> 
  ggplot(aes(x = fathers_qualification)) +
  geom_bar() +
  theme(axis.text.x = element_text(angle = 90))

# mother's occupation and father's occupation
drop_out_train |> 
  ggplot(aes(x = mothers_occupation)) +
  geom_bar() +
  theme(axis.text.x = element_text(angle = 90))

drop_out_train |> 
  ggplot(aes(x = fathers_occupation)) +
  geom_bar() +
  theme(axis.text.x = element_text(angle = 90))

# gender distribution within target
drop_out_train |> 
  ggplot(aes(x = target, fill = gender)) +
  geom_bar()

# socio-economic class
drop_out_train |> 
  ggplot(aes(x = target, fill = debtor)) +
  geom_bar()

drop_out_train |> 
  ggplot(aes(x = target, fill = tuition_fees_up_to_date)) +
  geom_bar()

drop_out_train |> 
  ggplot(aes(x = target, fill = scholarship_holder)) +
  geom_bar()
