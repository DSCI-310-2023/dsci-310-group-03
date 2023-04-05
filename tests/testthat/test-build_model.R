source("../../src/functions/build_model.R")

testthat::test_that("No error when `k` is not specified", {
  testthat::expect_no_error(
    build_model(
      training_set,
      image_recipe,
      optimal = "None",
      vfold = vfold,
      gridvals = gridvals
    )
  )
})

testthat::test_that("The output of `build_model` is of the expected class type", {
  testthat::expect_s3_class(
    build_model(
      training_set,
      image_recipe,
      optimal = "None",
      vfold = vfold,
      gridvals = gridvals
    ),
    "tbl_df"
  )
})

testthat::test_that("No error with given optimal k neighbors", {
  testthat::expect_no_error(
    build_model(
      training_set,
      image_recipe,
      "Yes",
      k = 10
    )
  )
})
