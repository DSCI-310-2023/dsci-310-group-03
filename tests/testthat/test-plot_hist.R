library(testthat)
library(vdiffr)
source("../../R/abstraction_histogram.R")

plot_hist(iris, Species, binwidth = 0.25)
ncol(iris)
