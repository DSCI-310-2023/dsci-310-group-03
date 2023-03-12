library(testthat)
source("../R/average_numeric.R")
source("helper-average_numeric.R")

test_that("Return the summary table of mean grouped by income status",
          {expect_equal(expected, avg_numeric(incomedata,status))})

