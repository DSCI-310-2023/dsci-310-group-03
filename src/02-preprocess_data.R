'Performs data cleaning, pre-processing and transforming for data (from https://raw.githubusercontent.com/karlie-tr/dataset_heart_disease/main/heart_disease_data.csv).
Writes the training and test data to separate files.

Usage: src/preprocess_data.r --input=<input> --out_train=<out_train> --out_transform_train=<out_transform_train> --out_transform_test=<out_transform_test>
  
Options:
--input=<input>                              Path (including filename) to raw data (csv file)
--out_train=<out_train>                      Path to directory where the processed training data should be written
--out_transform_train=<out_tranform_train>   Path to directory where the processed tranformed training data should be written
--out_transform_test=<out_transform_test>    Path to directory where the processed transformed testing data should be written

Example:
data/processed/training_set.csv data/processed/testing_set.csv: src/preprocess_data.r 
	Rscript src/preprocess_data.r --input=../data/raw/heart_disease_data.csv --out_train=../data/processed/training_set.csv --out_transform_train=../data/processed/transformed_training_set.csv --out_transform_test=../data/processed/transformed_testing_set.csv

'-> doc

suppressMessages(library(docopt))
suppressMessages(library(tidymodels))
suppressMessages(library(here))

source(here("src/functions/load_data.R"))
source(here("src/functions/sub_values.R"))

# set seed to make sure our file is reproducible
set.seed(1020)

opt <- docopt(doc)

main <- function(input, out_train, out_transform_train, out_transform_test){
  # load data file and set column names
  column_names <- c("age", "sex", "chest_pain_type",
                    "resting_bp", "cholesterol", "high_blood_sugar",
                    "resting_ecg", "max_heart_rate", "exercise_pain",
                    "old_peak", "slope", "no_vessels_colored",
                    "thal", "diagnosis", "diagnosis_2")
  
  cleveland <- load_data(input,
                         names = column_names,
                         separator = ",",
                         na_values = "?")
  
  
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
  
  cleveland_tidy <- cleveland |>
    mutate(high_blood_sugar = high_blood_sugar_vec,
           exercise_pain = exercise_pain_vec,
           diagnosis = diagnosis_vec)
  
  # remove `diagnosis_2`
  cleveland_select <- select(cleveland_tidy, -diagnosis_2)
  
  # split data into training set and testing set
  split_data <- initial_split(cleveland_select, prop = 0.75, strata = diagnosis)
  training_set <- training(split_data)
  testing_set <- testing(split_data)
  
  # write training set to csv file
  write.csv(training_set, out_train, row.names = FALSE)
  
  # remove `sex`, `high_blood_sugar`, `chest_pain_type` from training set
  training_set <- training_set |>
    select(-sex, -high_blood_sugar, -chest_pain_type)
  
  # converting categorical variable to numeric data
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
  
  # transform training and testing set for model buiding
  training_set <- transform_numeric(training_set) |>
    na.omit()
  testing_set <- transform_numeric(testing_set)
  
  # write transformed training and testing set to seperated csv files
  write.csv(training_set, out_transform_train, row.names = FALSE)
  write.csv(testing_set, out_transform_test, row.names = FALSE)
}

main(opt[["--input"]], opt[["--out_train"]], opt[["--out_transform_train"]], opt[["--out_transform_test"]])
