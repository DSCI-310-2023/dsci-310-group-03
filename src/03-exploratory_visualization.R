"compare the mean values of the numerical variables and the distribution of the factorial variables for observations classified as sick and healthy.
Plot the histograms to visualize the distribution of the variables.

Usage: src/03-exploratory_visualization.R <input_dir> <out_dir>

Options:
<input_dir>		  Path (not including filename) to data
<out_dir>       Path to directory where the results should be saved
  " -> doc

set.seed(1020)

opt <- docopt::docopt(doc)

# Load dataset ------------------------------------------------------------
training_set <- read.csv(paste0(opt$input_dir, "/training_set.csv"))

# Compute mean of the numerical attributes --------------------------------
summary_averages <- group03package::avg_numeric(training_set, diagnosis)

write.csv(summary_averages, paste0(opt$out_dir, "/summary_averages.csv"),
  row.names = FALSE
)

# Generate plot for ratio of numeric values ------------------------------
numeric_summary <- training_set |>
  dplyr::select(
    sex, chest_pain_type, high_blood_sugar,
    resting_ecg, diagnosis
  ) |>
  tidyr::pivot_longer(
    cols = sex:resting_ecg,
    names_to = "attribute",
    values_to = "value"
  )

numeric_plot <- numeric_summary |>
  ggplot2::ggplot() +
  ggplot2::aes(y = attribute, fill = value) +
  ggplot2::geom_bar(position = "fill") +
  ggplot2::facet_grid(cols = dplyr::vars(diagnosis)) +
  ggplot2::scale_fill_brewer(palette = "Paired") +
  ggplot2::labs(x = "Ratio", y = "Attribute", color = "Value")

ggplot2::ggsave(paste0(opt$out_dir, "/numeric_plot.png"),
  width = 20, height = 15, units = "cm"
)


# Generate plot for ratio of categorical values --------------------------------
categorical_summary <- training_set |>
  dplyr::select(exercise_pain, slope, thal, diagnosis) |>
  tidyr::pivot_longer(
    cols = exercise_pain:thal,
    names_to = "attribute",
    values_to = "value"
  )

categorical_plot <- categorical_summary |>
  ggplot2::ggplot() +
  ggplot2::aes(y = attribute, fill = value) +
  ggplot2::geom_bar(position = "fill") +
  ggplot2::facet_grid(cols = dplyr::vars(diagnosis)) +
  ggplot2::scale_fill_brewer(palette = "Paired") +
  ggplot2::labs(x = "Ratio", y = "Attribute", color = "Value")

ggplot2::ggsave(paste0(opt$out_dir, "/categorical_plot.png"),
  width = 25, height = 20, units = "cm"
)

# Generate histograms for all numeric variables --------------------------------
variables_histogram <- group03package::plot_hist(
  training_set,
  diagnosis,
  col = 3,
  sep = "_",
  title = "Histogram for different explanatory variables"
)

ggplot2::ggsave(paste0(opt$out_dir, "/variables_histogram.png"))
