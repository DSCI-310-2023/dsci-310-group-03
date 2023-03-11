library(testthat)
setwd("~/Documents/W2022/dsci-310/dsci-310-group-03/tests") 
source("../R/sub_values.R")

## Set up
Species_vec <- iris$Species

expected_vec <- data.frame(lunch = c("Pizza", "Pizza"),
                          snack = c("Cheetos","Donut"),
                          stringsAsFactors = TRUE) |>
                          pull(snack)

original_df <- data.frame(lunch = c("Pizza","Sushi"),
                          snack = c("Sushi","Donut"),
                          stringsAsFactors = TRUE)

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

