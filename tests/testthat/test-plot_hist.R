source("../../R/plot_hist.R")

test_that("ggplot2 histogram works", {
  vdiffr::expect_doppelganger("histograms from ggplot",
                              histograms_ggplot)
  vdiffr::expect_doppelganger("histograms from function",
                              plot_hist(iris, Species))
})
