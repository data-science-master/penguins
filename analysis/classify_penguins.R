##############
## Synopsis: Try out a basic classifier on the penguins using tidymodels
## Author: David Gerard
##############

library(tidymodels)
library(readr)
library(palmerpenguins)
data("penguins")
set.seed(1)

pen_split <- initial_split(penguins)
pen_training <- training(pen_split)
pen_testing <- testing(pen_split)

rand_forest(trees = 100, mode = "classification") %>%
  set_engine("randomForest") %>%
  fit(species ~ bill_length_mm + bill_depth_mm,
      data = pen_training) ->
  pen_mod

## Estimate accuracy
predict(pen_mod, pen_testing) %>%
  bind_cols(pen_testing) %>%
  metrics(truth = species, estimate = .pred_class) %>%
  write_csv(path = "./output/penguin_class.csv")
