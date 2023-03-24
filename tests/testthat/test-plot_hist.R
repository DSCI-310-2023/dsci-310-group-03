library(testthat)
library(vdiffr)
source("../../R/plot_hist.R")

test_that("ggplot2 histogram works", {
  expect_doppelganger("histograms from ggplot", 
                      histograms_ggplot)
  
  histograms_function <- plot_hist(iris, Species)
  expect_doppelganger("histograms from plot_hist",  
                      histograms_function)  
})
