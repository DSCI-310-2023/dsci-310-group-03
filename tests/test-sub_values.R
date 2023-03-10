library(testthat)
source("../R/sub_values.R")

# Tests for error messages when the column do not exist
expect_error(sub_values(iris, Length, 'SETOSA', 'setosa'))

# Tests for error messages when the data frame do not exist
expect_error(sub_values(iris1, Species, 'SETOSA', 'setosa'))

# Return the same data frame when original value does not exist
expect_identical(iris, sub_values(iris, Species, 'SETOSA', 'SS'))


# Test functionality of sub_values

## Set up
expected_df <- data.frame(lunch = c("Pizza","Sushi"),
                          snack = c("Cheetos","Donut"),
                          stringsAsFactors = TRUE)

original_df <- data.frame(lunch = c("Pizza","Sushi"),
                          snack = c("Sushi","Donut"),
                          stringsAsFactors = TRUE)

## Function only replace the values in specified column
expect_equal(expected_df, 
             sub_values(original_df, snack, 
                        original = 'Sushi', replacement = 'Cheetos'))

