source("../../R/average_numeric.R")

iris_avg <- iris |>
  group_by(Species) |>
  summarize_all(mean, na = TRUE)

testthat::test_that("Return the summary table of mean grouped by Species",
          {testthat::expect_equal(iris_avg, 
                                  avg_numeric(iris, Species))})


