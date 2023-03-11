library(testthat)
source("../rscript/average_numeric.R")

#set up
age <- c(25, 34, 28, 52)
status <- c("Poor", "Improved", "Excellent", "Poor")
incomedata <- data.frame(age, status)
expected<- tribble(
  ~status, ~age,
  "Excellent", 28,
  "Improved", 34,
  "Poor",38.5)

test_that("Return the summary table of mean grouped by income status",
          {expect_equal(expected, avg_numeric(incomedata,status))})

