source("../../R/load_data.R")

data_from_function <- load_data(
  path,
  column_names,
  separator = ",",
  na_values = "?"
)

# Tests -----------------------------------------------------------------------
testthat::test_that("load_data returns a dataframe with same column names", {
  testthat::expect_equal(column_names, colnames(data_from_function))
})

testthat::test_that("load_data returns the same dataframe with read_delim", {
  testthat::expect_equal(data_from_function, data_from_read_delim)
})

testthat::test_that("load_data returns a dataframe", {
  testthat::expect_true(is.data.frame(data_from_function))
})

