"compare the mean values of the numerical variables and the distribution of the factorial variables for observations classified as sick and healthy.
Plot the histograms to visualize the distribution of the variables.

Usage: src/exploratory_visualization.R <input_dir> <out_dir>

Options:
<input_dir>		  Path (not including filename) to data
<out_dir>       Path to directory where the results should be saved
  " -> doc

# Set up ----------------------------------------------------------
library(docopt)
library(tidymodels)
library(tidyverse)
library(cowplot)
library(here)

set.seed(1020)

source(here("R/average_numeric.R"))
source(here("R/plot_hist.R"))

opt <- docopt(doc)

# Load dataset ------------------------------------------------------------
training_set <- read.csv(paste0(opt$input_dir,"/training_set.csv"))

# Compute mean of the numerical attributes --------------------------------
summary_averages <- avg_numeric(training_set, diagnosis)

write.csv(summary_averages, paste0(opt$out_dir,"/summary_averages.csv"),
          row.names = FALSE)

# Generate plot for ratio of numeric values ------------------------------
numeric_summary <- training_set |>
  select(sex, chest_pain_type, high_blood_sugar,
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

ggsave(paste0(opt$out_dir,"/numeric_plot.png"),
       width = 20, height = 15, units = "cm")


# Generate plot for ratio of categorical values --------------------------
categorical_summary <- training_set |>
  select(exercise_pain, slope, thal, diagnosis) |>
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

ggsave(paste0(opt$out_dir,"/categorical_plot.png"),
       width = 25, height = 20, units = "cm")

# Generate histograms for all numeric variables --------------------------
variables_histogram <- plot_hist(
  training_set,
  diagnosis,
  col = 3,
  sep = "_",
  title ="Histogram for different explanatory variables")

ggsave(paste0(opt$out_dir,"/variables_histogram.png"))
