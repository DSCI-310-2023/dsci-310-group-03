source("../../src/functions/sub_values.R")

testthat::test_that("Function return a vector with the same length", {
  testthat::expect_equal(
    length(Species_vec),
    length(sub_values(iris, Species, "SETOSA", "setosa"))
  )
})

testthat::test_that("Return the same vector if the original value does not exist", {
  testthat::expect_identical(
    Species_vec,
    sub_values(iris, Species, "SETOSA", "SS")
  )
})

testthat::test_that("Return a vector of the specified column with the replaced value", {
  testthat::expect_equal(
    expected_vec,
    sub_values(original_df,
      snack,
      original = "Sushi",
      replacement = "Cheetos"
    )
  )
})

