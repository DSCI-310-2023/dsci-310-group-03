# Build KNN model using iris data set ------------------------------------
split_data <- rsample::initial_split(iris, prop = 0.75, strata = Species)
training_set <- rsample::training(split_data)

vfold <- rsample::vfold_cv(training_set, v = 5, strata = Species)
gridvals <- tibble::tibble(neighbors = seq(1, 10, 1))

image_recipe <- recipes::recipe(Species ~ ., data = training_set) |>
  recipes::step_scale(all_predictors()) |>
  recipes::step_center(all_predictors())
