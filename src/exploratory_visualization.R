"
Usage: src/exploratory_visualization.R --input=<input> --out_dir=<out_dir>
Options:
--input_dir=<input_dir>		Path (including filename) to raw data
--out_dir=<output_dir>		Path to directory where the results should be saved
  " -> doc

source("../R/average_numeric.R")
source("../R/abstraction_histogram.R")
options(repr.matrix.max.rows = 6)
options(repr.plot.width = 12, repr.plot.height = 7) 

opt <- docopt(doc)


# Average values of the numerical attributes
summary_averages <- avg_numeric(training_set, diagnosis)
summary_averages

numeric_summary <- training_set |>
  dplyr::select(sex, chest_pain_type, high_blood_sugar,
         resting_ecg, diagnosis) |> 
  pivot_longer(cols = sex:resting_ecg,
               names_to = "attribute",
               values_to = "value")

numeric_plot <- numeric_summary |>
  ggplot() +
  aes(y = attribute, fill = value) +
  geom_bar(position = "fill") +
  facet_grid(cols = vars(diagnosis)) +
  scale_fill_brewer(palette = "Paired") +
  labs(x = "Ratio", y = "Attribute", color = "Value")

categorical_summary <- training_set |>
  dplyr::select(exercise_pain, slope, thal, diagnosis) |>
  pivot_longer(cols = exercise_pain:thal,
               names_to = "attribute",
               values_to = "value")

categorical_plot <- categorical_summary |>
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
