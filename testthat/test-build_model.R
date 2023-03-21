library(testthat)
library(tidyverse)
library(tidymodels)
source("../R/build_model.R")

split_data <- initial_split(iris, prop = 0.75, strata = Species)
training_set <- training(split_data)

vfold <- vfold_cv(training_set, v = 5, strata = Species)
gridvals <- tibble(neighbors = seq(1, 10, 1))

image_recipe <- recipe(Species ~ ., data = training_set) %>%
  step_scale(all_predictors()) %>%
  step_center(all_predictors())

test_that("Model is fitted and built without error with parameter tuning", {
  expect_no_error(build_model(training_set, image_recipe, optimal = "None", vfold = vfold, gridvals = gridvals))
})

test_that("The output model is of the expected class type", {
  expect_s3_class(build_model(training_set, image_recipe, optimal = "None", vfold = vfold, gridvals = gridvals), "tbl_df")
})

knn_fit <- build_model(training_set, image_recipe, optimal = "None", vfold = vfold, gridvals = gridvals)
best_fit <- knn_fit %>%
  filter(.metric == "accuracy") %>%
  arrange(desc(mean)) %>%
  slice(1)

optimal_k <- best_fit %>% pull(neighbors)

test_that("Model is fitted and built without error given optimal k neighbors", {
  expect_no_error(build_model(training_set, image_recipe, "Yes", k = optimal_k))
})
