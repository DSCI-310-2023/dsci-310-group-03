source("../../R/average_numeric.R")

iris_avg <- iris |>
  dplyr::group_by(Species) |>
  dplyr::summarize_all(mean, na = TRUE)

testthat::test_that("Return the summary table of mean grouped by Species",
          {testthat::expect_equal(iris_avg, 
                                  avg_numeric(iris, Species))})
