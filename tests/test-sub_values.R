library(testthat)
source("../R/sub_values.R")

test_that("Function return a vector with the same length",
          {expect_equal(length(Species_vec), 
                        length(sub_values(iris, Species, 'SETOSA', 'setosa')))})

test_that("Return the same vector if the original value that is being replaced
          does not exist",
          {expect_identical(Species_vec, 
                            sub_values(iris, Species, 'SETOSA', 'SS'))})

test_that("Return a vector of the specified column with the replaced value",
          {expect_equal(expected_vec, sub_values(original_df, snack, 
                                                original = 'Sushi', 
                                                replacement = 'Cheetos'))})

