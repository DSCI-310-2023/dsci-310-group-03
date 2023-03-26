source("../../src/functions/plot_hist.R")

testthat::test_that("ggplot2 histogram works", {
  vdiffr::expect_doppelganger("histograms from ggplot",
                              histograms_ggplot_with_title)
  vdiffr::expect_doppelganger("histograms from function",
                              plot_hist(iris, Species, "Title"))
})

testthat::test_that("`plot_hist` should return an error when `title` is not
                    a string", {
  testthat::expect_error(plot_hist(iris, Species, title))
})
