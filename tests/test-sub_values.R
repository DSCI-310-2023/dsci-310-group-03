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

test_that("Return an error message when column does not exist within the data
           frame",
          {expect_error(sub_values(iris, Length, 'SETOSA', 'setosa'))})

test_that("Return an error message when dataframe does not exist",
          {expect_error(sub_values(iris1, Species, 'SETOSA', 'setosa'))})

test_that("Return the same data frame if the original value does not exist",
          {expect_identical(iris, sub_values(iris, Species, 'SETOSA', 'SS'))})


test_that("Function only replaces the values in specified column",
          {expect_equal(expected_df, 
             sub_values(original_df, snack, 
                        original = 'Sushi', replacement = 'Cheetos'))})

