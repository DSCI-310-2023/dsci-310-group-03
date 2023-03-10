library(tidyverse)
library(tidymodels)
library(ggplot2)
library(devtools)
library(testthat)
library(vdiffr)

cleveland <- read_delim("../data/raw/heart_disease_data.csv", 
                        col_names = c('age','sex','chest_pain_type','resting_bp','cholesterol','high_blood_sugar','resting_ecg',
                                      'max_heart_rate','exercise_pain','old_peak','slope','no_vessels_colored','thal',
                                      'diagnosis','diagnosis_2'),
                        delim = ",",
                        show_col_types = FALSE,
                        na = "?")

cleveland <- cleveland %>%
  mutate(no_vessels_colored = as.numeric(no_vessels_colored),
         high_blood_sugar = sub('TRUE', 'true',high_blood_sugar),    # replace 'fal' with FALSE for readability
         exercise_pain = sub('TRUE', 'true',exercise_pain),          
         diagnosis = sub('buff','healthy', diagnosis)) %>%           # replace 'buff' with 'healthy' for readability
  mutate_if(is.character, as.factor)   

cleveland_select <- select(cleveland, -diagnosis_2)

split_data = initial_split(cleveland_select, prop=0.75, strata=diagnosis)
training_set <- training(split_data)

source("../R/abstraction_histogram.R")

# Tests for abstraction of histogram - test if abs_hist function works

test_that("ggplot2 histogram works", {
  cholesterol_histogram_ggplot <- ggplot(training_set, aes(x = cholesterol, fill = diagnosis)) +
    geom_histogram(position="dodge") +
    labs(x = "Serum Cholesterol (mg/dl)", y="Percentage of Observations", fill = "Diagnosis")+
    theme(text = element_text(size = 10)) +
    scale_fill_brewer(palette = "Paired")
  vdiffr::expect_doppelganger("cholesterol ggplot histogram", cholesterol_histogram_ggplot)
  
  cholesterol_histogram <- abs_hist(training_set$cholesterol, "Serum Cholesterol (mg/dl)", training_set, training_set$diagnosis, "Percentage of Observations", "Diagnosis")
  vdiffr::expect_doppelganger("cholesterol abs hist histogram", cholesterol_histogram)  
})


test_that("ggplot2 histogram works", {
  age_histogram_ggplot <- ggplot(training_set, aes(x = age, fill = diagnosis)) +
    geom_histogram(position="dodge") +
    labs(x = "Age", y="Percentage of Observations", fill = "Diagnosis")+
    theme(text = element_text(size = 10))+
    scale_fill_brewer(palette = "Paired")
  vdiffr::expect_doppelganger("age ggplot histogram", age_histogram_ggplot)
  
  age_histogram <- abs_hist(training_set$age, "Age", training_set, training_set$diagnosis, "Percentage of Observations", "Diagnosis")
  vdiffr::expect_doppelganger("age abs hist histogram", age_histogram)  
})
