source("../../R/build_model.R")

model_no_k <- build_model(
  training_set,
  image_recipe,
  optimal = "None",
  vfold = vfold,
  gridvals = gridvals
)

model_with_k <- build_model(
  training_set,
  image_recipe,
  "Yes",
  k = 10
)

# Tests -----------------------------------------------------------------------
testthat::test_that("No error when k is not specified", {
  testthat::expect_no_error(model_no_k)
})

testthat::test_that("The output of build_model is of the expected class type", {
  testthat::expect_s3_class(model_no_k,
                  "tbl_df")
})

testthat::test_that("No error with given optimal k neighbors", {
  testthat::expect_no_error(model_with_k)
})
