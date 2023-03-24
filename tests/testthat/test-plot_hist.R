source("../../R/plot_hist.R")

# Plot all histograms into 1 plot --------------------------------
histograms_ggplot <- cowplot::plot_grid(
  histogram_1, histogram_2, histogram_3, histogram_4,
  ncol = 2,
  labels = "auto",
  label_size = 10
)

# Tests -----------------------------------------------------------
testthat::test_that("ggplot2 histogram works", {
  vdiffr::expect_doppelganger("histograms from ggplot", 
                      histograms_ggplot)
  
  histograms_function <- plot_hist(iris, Species)
  vdiffr::expect_doppelganger("histograms from plot_hist",  
                      histograms_function)  
})
