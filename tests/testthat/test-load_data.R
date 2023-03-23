source("../../R/load_data.R")

data_from_function <- load_data(
  path,
  column_names,
  separator = ",",
  na_values = "?"
)

# tests
testthat::test_that("columns have expected column names and same number of columns", {
  testthat::expect_equal(column_names, colnames(data_from_function))
})

testthat::test_that("returned data frame has the same number of rows", {
  testthat::expect_equal(data_from_function, data_from_read_delim)
})

testthat::test_that("function return a data frame", {
  testthat::expect_true(is.data.frame(data_from_function))
})

