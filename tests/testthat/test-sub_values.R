source("../../src/functions/sub_values.R")

testthat::test_that("`sub_values` return a vector with the same length", {
  testthat::expect_equal(
    length(species_vec),
    length(sub_values(iris, Species, "SETOSA", "setosa"))
  )
})

testthat::test_that("`sub_values` return the same vector if the original value does not exist", {
  testthat::expect_identical(
    species_vec,
    sub_values(iris, Species, "SETOSA", "SS")
  )
})

testthat::test_that("`sub_values` returns a vector of the specified column with the replaced value", {
  testthat::expect_equal(
    expected_vec,
    sub_values(food_df,
      snack,
      original = "Sushi",
      replacement = "Cheetos"
    )
  )
})

testthat::test_that("`sub_values` should throw an error when incorrect
                    types of input are passed to `data`", {
  testthat::expect_error(sub_values(iris, Color))
  testthat::expect_error(
    sub_values(food_df_as_list, gender),
    "`dataset` should be a data frame or data frame extension"
  )
  testthat::expect_error(sub_values(food_df, Gender))
  testthat::expect_error(
    sub_values(food_df_as_list, weight),
    "`dataset` should be a data frame or data frame extension"
  )
})

testthat::test_that("`sub_values` should throw an error when the column 
                    does not exist in the data frame", {
  testthat::expect_error(
    sub_values(iris, Color),
    "'Color' does not exist in this data frame"
  )
  testthat::expect_error(
    sub_values(food_df, lunch1),
    "'lunch1' does not exist in this data frame"
  )
})

