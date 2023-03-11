library(testthat)
setwd("~/Documents/W2022/dsci-310/dsci-310-group-03/tests") 
source("../R/sub_values.R")


## Set up
expected_df <- data.frame(lunch = c("Pizza","Sushi"),
                          snack = c("Cheetos","Donut"),
                          stringsAsFactors = TRUE)

original_df <- data.frame(lunch = c("Pizza","Sushi"),
                          snack = c("Sushi","Donut"),
                          stringsAsFactors = TRUE)

## Tests
test_that("Throw an error message when any of the column or data parameter does 
          not exist",
          {# column does not exist
           expect_error(sub_values(iris, Length, 'SETOSA', 'setosa'))
           # data frame does not exist 
           expect_error(sub_values(iris1, Species, 'SETOSA', 'setosa'))
           # both column and data frame don't exist
           expect_error(sub_values(iris0, Species0, 'SETOSA', 'setosa'))})

test_that("Return the same data frame if the original value to be replaced
          does not exist",
          {expect_identical(iris, sub_values(iris, Species, 'SETOSA', 'SS'))})


test_that("Function only replaces the values in specified column",
          {expect_equal(expected_df, sub_values(original_df, snack, 
                                                original = 'Sushi', 
                                                replacement = 'Cheetos'))})

