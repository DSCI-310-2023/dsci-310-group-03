'Performs data cleaning, pre-processing and transforming for data (from https://archive.ics.uci.edu/ml/machine-learning-databases/heart-disease/processed.cleveland.data).
Writes the training and test data to separate files.

Usage: src/preprocess_data.r --input=<input> --out_train=<out_train> --out_test=<out_test>
  
Options:
--input=<input>           Path (including filename) to raw data (csv file)
--out_train=<out_train>   Path to directory where the processed training data should be written
--out_test=<out_test>     Path to directory where the processed testing data should be written

Example:
results/training_set.csv results/testing_set.csv: src/preprocess_data.r 
	Rscript src/preprocess_data.r --input="../data/raw/heart_disease_data.csv" --out_train="../results/training_set.csv" --out_test="../results/testing_set.csv"

' -> doc

library(tidyverse)
library(repr)
library(tidymodels)
library(docopt)
library(RColorBrewer)
library(cowplot)
options(repr.matrix.max.rows = 6)
options(repr.plot.width = 12, repr.plot.height = 7) 
# Rscripts
source("../R/load_data.R")
source("../R/sub_values.R")
source("../R/average_numeric.R")
source("../R/abstraction_histogram.R")
source("../R/build_model.R")
# set seed to make sure our file is reproducible
set.seed(1020)

opt <- docopt(doc)

main <- function(input, out_dir){
  # Load data file and set column names
  column_names <- c("age", "sex", "chest_pain_type",
                    "resting_bp", "cholesterol", "high_blood_sugar",
                    "resting_ecg", "max_heart_rate", "exercise_pain",
                    "old_peak", "slope", "no_vessels_colored",
                    "thal", "diagnosis", "diagnosis_2")
  cleveland <- load_data(input,
                         names = column_names,
                         separator = ",",
                         na_values = "?")
  glimpse(cleveland)
  
  
  # replace values in dataframe for readability
  high_blood_sugar_vec <-
    sub_values(cleveland, high_blood_sugar,
               replacement = "true", original = "TRUE")
  
  exercise_pain_vec <-
    sub_values(cleveland, exercise_pain,
               replacement = "true", original = "TRUE")
  
  diagnosis_vec <-
    sub_values(cleveland, diagnosis,
               replacement = "healthy", original = "buff")
  
  cleveland <- cleveland %>%
    mutate(high_blood_sugar = high_blood_sugar_vec,
           exercise_pain = exercise_pain_vec,
           diagnosis = diagnosis_vec)
  cleveland
  
  cleveland_select <- select(cleveland, -diagnosis_2)
  
  cleveland_select
  
  split_data <- initial_split(cleveland_select, prop = 0.75, strata = diagnosis)
  training_set <- training(split_data)
  testing_set <- testing(split_data)
  
  training_set
  
  # Converting categorical variable to numeric data
  transform_numeric <- function(df) {
    mutated <- mutate(
      df,
      
      exercise_pain = as.character(exercise_pain),
      exercise_pain = replace(exercise_pain, exercise_pain == "fal", "0"),
      exercise_pain = as.numeric(replace(exercise_pain, exercise_pain == "true", "1")),
      
      slope = as.character(slope),
      slope = replace(slope, slope == "down", "-1"),
      slope = replace(slope, slope == "flat", "0"),
      slope = as.numeric(replace(slope, slope == "up", "1")),
      
      # Below values are "non-standard" values for a better scale
      thal = as.character(thal),
      thal = replace(thal, thal == "rev", "4"),
      thal = replace(thal, thal == "norm", "0"),
      thal = as.numeric(replace(thal, thal == "fix", "5")),
      
      resting_ecg = as.character(resting_ecg),
      resting_ecg = replace(resting_ecg, resting_ecg == "abn", "4"),
      resting_ecg = replace(resting_ecg, resting_ecg == "norm", "0"),
      resting_ecg = as.numeric(replace(resting_ecg, resting_ecg == "hyp", "5")),
    )
    return(mutated)
  }
  
  training_set <- transform_numeric(training_set)
  testing_set <- transform_numeric(testing_set)
  
  # write training data to csv files
  write_csv(training_set, out_dir)
  write_csv(training_set, out_dir)
}

main(opt[["--input"]], opt[["--out_train"]], opt[["--out_test"]])
