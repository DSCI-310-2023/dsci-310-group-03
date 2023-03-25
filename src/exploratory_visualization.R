"compare the mean values of the numerical variables and the distribution of the factorial variables for observations classified as sick and healthy.
Plot the histograms to visualize the distribution of the variables.

Usage: src/exploratory_visualization.R --input=<input> --out_dir=<out_dir>

Options:
--input_dir=<input_dir>		Path (including filename) to raw data
--out_dir=<output_dir>		Path to directory where the results should be saved
  " -> doc
library(docopt)
library(tidymodels)
library(tidyverse)
library(cowplot)
library(here)
set.seed(1020)
source(here("R/average_numeric.R"))
source(here("R/plot_hist.R"))


opt <- docopt(doc)
training_set <- read.csv(paste0(opt$input_dir,"/training_set.csv"))

# Average values of the numerical attributes
summary_averages <- avg_numeric(training_set, diagnosis)
summary_averages
write_csv(summary_averages, paste0(opt$out_dir,"/summary_averages.csv"))

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

ggsave("numeric_plot.png", device = "png", path = out_dir, width = 10, height = 3)

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

plot_grid(numeric_plot, categorical_plot, ncol = 1)
ggsave("categorical_plot.png", device = "png", path = out_dir, width = 10, height = 3)

variables_histogram<- plot_hist(training_set, diagnosis, sep = "_", bins = 25, col = 3)
ggsave("variables_histogram.png", device = "png", path = out_dir, width = 10, height = 8)


