source("../../src/functions/average_numeric.R")

testthat::test_that("`avg_numeric` should return a data frame or
                    data frame extension", {
  testthat::expect_s3_class(avg_numeric(iris, Species), "data.frame")
})

testthat::test_that("`avg_numeric` should return a data frame or
                    data frame extension with the number of rows
                    that corresponds to
                    the number of unique classes
                    in the column passed to `class_col`", {
  testthat::expect_s3_class(avg_numeric(grade_df, final_grade), "data.frame")
  testthat::expect_output(
    str(avg_numeric(grade_df, final_grade)),
    "5 obs",
    ignore.case = TRUE
  )
  testthat::expect_output(
    str(avg_numeric(grade_df, gender)),
    "2 obs",
    ignore.case = TRUE
  )
  testthat::expect_output(
    str(avg_numeric(empty_df, gender)),
    "0 obs",
    ignore.case = TRUE
  )
})

testthat::test_that("`avg_numeric` should throw an error when incorrect
                    types of input are passed to `data`", {
  testthat::expect_error(avg_numeric(iris, Color))
  testthat::expect_error(
    avg_numeric(grade_df_as_list, gender),
    "`dataset` should be a data frame or data frame extension"
  )
  testthat::expect_error(avg_numeric(grade_df, Gender))
  testthat::expect_error(
    avg_numeric(grade_df_as_list, weight),
    "`dataset` should be a data frame or data frame extension"
  )
})

testthat::test_that("`avg_numeric` should throw an error when the column 
                    does not exist in the data frame", {
  testthat::expect_error(
    avg_numeric(iris, Color),
    "'Color' does not exist in this data frame"
  )
  testthat::expect_error(
    avg_numeric(grade_df, Gender),
    "'Gender' does not exist in this data frame"
  )
})


testthat::test_that("`class_col` can be either a factorial class
                    or a character class", {
  testthat::expect_no_error(avg_numeric(grade_df, gender))
  testthat::expect_no_error(avg_numeric(grade_df, final_grade))
})

testthat::test_that("`avg_numeric` should return a data frame or
                    data frame extension that computes the averages of variables
                    grouped by `class_col`", {
  testthat::expect_equal(
    avg_numeric(grade_df, gender),
    grouped_by_gender_output
  )
  testthat::expect_equal(
    avg_numeric(grade_df, final_grade),
    grouped_by_grades_output
  )
})
