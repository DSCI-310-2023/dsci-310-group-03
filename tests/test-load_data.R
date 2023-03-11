library(testthat)
setwd("~/Documents/W2022/dsci-310/dsci-310-group-03/tests") 
source("../R/load_data.R")

path <- "../data/raw/heart_disease_data.csv"
column_names <- c('age','sex','chest_pain_type','resting_bp',
                          'cholesterol','high_blood_sugar','resting_ecg',
                          'max_heart_rate','exercise_pain','old_peak','slope',
                          'no_vessels_colored','thal','diagnosis','diagnosis_2')
loaded_data <- load_data(path, column_names,
                         separator = ",",
                         na_values = "?")

test_that("columns have expected column names and same number of columns",
          {expect_equal(column_names, colnames(loaded_data))})
