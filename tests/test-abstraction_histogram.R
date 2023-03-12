library(testthat)
library(vdiffr)
source("../R/abstraction_histogram.R")
source("helper-abstraction_histogram.R")

test_that("ggplot2 histogram works", {
  expect_doppelganger("cholesterol ggplot histogram", 
                              cholesterol_histogram_ggplot)
  cholesterol_histogram <- abs_hist(cleveland_select$cholesterol, 
                                    "Serum Cholesterol (mg/dl)", 
                                    cleveland_select, cleveland_select$diagnosis, 
                                    "Percentage of Observations", "Diagnosis")
  expect_doppelganger("cholesterol abs hist histogram", cholesterol_histogram)  
})


test_that("ggplot2 histogram works", {
  expect_doppelganger("age ggplot histogram", age_histogram_ggplot)
  age_histogram <- abs_hist(cleveland_select$age, "
                            Age", 
                            cleveland_select, cleveland_select$diagnosis, 
                            "Percentage of Observations", "Diagnosis")
  expect_doppelganger("age abs hist histogram", age_histogram)  
})
