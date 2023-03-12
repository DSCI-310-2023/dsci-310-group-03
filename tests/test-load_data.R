library(testthat)
library(readr)
source("../R/load_data.R")

# set up
path <- "../data/raw/heart_disease_data.csv"

column_names <- c('age','sex','chest_pain_type','resting_bp',
                          'cholesterol','high_blood_sugar','resting_ecg',
                          'max_heart_rate','exercise_pain','old_peak','slope',
                          'no_vessels_colored','thal','diagnosis','diagnosis_2')

data_from_function <- load_data(path, column_names,
                         separator = ",",
                         na_values = "?")

data_from_read_delim <- read_delim(path, delim = ",",
                                   col_names = column_names,
                                   na = "?") |>
    mutate_if(is.character, as.factor)

# tests
test_that("columns have expected column names and same number of columns",
          {expect_equal(column_names, colnames(data_from_function))})

test_that("returned data frame has the same number of rows",
          {expect_equal(data_from_function, data_from_read_delim)})

test_that("function return a data frame",
          {expect_true(is.data.frame(data_from_function))})
