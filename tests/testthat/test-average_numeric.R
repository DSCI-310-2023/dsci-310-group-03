source("../../R/average_numeric.R")

testthat::test_that("Return the summary table of mean grouped by income status",
          {testthat::expect_equal(expected, 
                                  avg_numeric(incomedata,status))})


