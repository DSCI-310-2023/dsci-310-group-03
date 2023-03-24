# load libraries
library(tidyverse)
library(repr)
library(tidymodels)
library(RColorBrewer)
library(cowplot)
options(repr.matrix.max.rows = 6)
options(repr.plot.width = 12, repr.plot.height = 7) 
# Rscripts

source("../R/average_numeric.R")
source("../R/abstraction_histogram.R")


source("./R/preprocess_data.R")

# Average values of the numerical attributes
summary_averages <- avg_numeric(training_set, diagnosis)
summary_averages

numeric_summary <- training_set %>%
  select(sex, chest_pain_type, high_blood_sugar,
         resting_ecg, diagnosis) %>% 
  pivot_longer(cols = sex:resting_ecg,
               names_to = "attribute",
               values_to = "value")

numeric_plot <- numeric_summary %>%
  ggplot() +
  aes(y = attribute, fill = value) +
  geom_bar(position = "fill") +
  facet_grid(cols = vars(diagnosis)) +
  scale_fill_brewer(palette = "Paired") +
  labs(x = "Ratio", y = "Attribute", color = "Value")

categorical_summary <- training_set %>%
  select(exercise_pain, slope, thal, diagnosis) %>%
  pivot_longer(cols = exercise_pain:thal,
               names_to = "attribute",
               values_to = "value")

categorical_plot <- categorical_summary %>%
  ggplot() +
  aes(y = attribute, fill = value) +
  geom_bar(position = "fill") +
  facet_grid(cols = vars(diagnosis)) +
  scale_fill_brewer(palette = "Paired") +
  labs(x = "Ratio", y = "Attribute", color = "Value")

plot_grid(numeric_plot, categorical_plot, ncol = 1)

# Histograms for individual variables
cholesterol_histogram <-
  abs_hist(training_set$cholesterol, "Serum Cholesterol (mg/dl)",
           training_set, training_set$diagnosis,
           "Percentage of Observations", "Diagnosis")

age_histogram <-
  abs_hist(training_set$age, "Age", 
           training_set, training_set$diagnosis,
           "Percentage of Observations", "Diagnosis")

resting_bp_histogram <-
  abs_hist(training_set$resting_bp, "Resting Blood Pressure(mm Hg)",
           training_set, training_set$diagnosis,
           "Percentage of Observations", "Diagnosis")

max_heart_rate_histogram <-
  abs_hist(training_set$max_heart_rate, "Max Heart Rate(Beats/min)",
           training_set, training_set$diagnosis,
           "Percentage of Observations", "Diagnosis")

old_peak_histogram <- 
  abs_hist(training_set$old_peak, "Oldpeak",
           training_set, training_set$diagnosis,
           "Percentage of Observations", "Diagnosis")

no_vessels_colored_histogram <- 
  abs_hist(training_set$no_vessels_colored, "Number of colored vessels",
           training_set, training_set$diagnosis,
           "Percentage of Observations", "Diagnosis")

options(repr.plot.width = 16, repr.plot.height = 6) 
plot_grid(cholesterol_histogram, age_histogram,
          resting_bp_histogram, max_heart_rate_histogram,
          old_peak_histogram, no_vessels_colored_histogram, ncol = 3)

training_set <- training_set %>%
  select(-sex, -high_blood_sugar, -chest_pain_type)

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

# removing NA rows to make sure our cross-validation works
before <- nrow(training_set)
training_set <- training_set %>% na.omit()
after <- nrow(training_set)
print(paste("Removed entries:", before - after, "out of", before))

# count sick entries
nr_sick <- training_set %>% filter(diagnosis == "sick") %>% nrow()
print(paste("Sick entries:", nr_sick, "/", nrow(training_set)))

