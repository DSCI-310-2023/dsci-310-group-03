library(testthat)
source("../R/sub_values.R")
source("helper-sub_values.R")

test_that("Throw an error message when any of the column or data parameter does 
          not exist",
          {# column does not exist
           expect_error(sub_values(iris, Length, 'SETOSA', 'setosa'))
           # data frame does not exist 
           expect_error(sub_values(iris1, Species, 'SETOSA', 'setosa'))
           # both column and data frame don't exist
           expect_error(sub_values(iris0, Species0, 'SETOSA', 'setosa'))})

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

