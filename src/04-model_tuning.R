"Fits knn model on the training set with cross validation and return the optimal number of neighbors k
as well as the best fit results. Additionally perform feature selection and output results for diferent 
combinations of predictors.

Outputs:
The best fit result from cross validation is saved as 'cv_best_fit.csv'
The diagnosis prediction confusion matrix is saved as 'diagnosis_prediction_confusion.csv'
The results for different tried formulas is saved as 'model_formulas_result.csv'
The plot for predictors results is saved as 'predictors_result.png'

Usage: src/model_tuning.R <input_dir> <out_dir>

Options:
<input_dir>		Path (not including filename) to data
<out_dir>       Path to directory where the results should be saved
" -> doc

# Set up -----------------------------------------------------------------------

set.seed(1020)

source(here::here("src/functions/build_model.R"))

opt <- docopt::docopt(doc)

# Load data --------------------------------------------------------------------
training_set <- reader::read_csv(paste0(opt$input_dir, "/transformed_training_set.csv"))

# Perform cross validation to find optimal k -----------------------------------
vfold <- tidymodels::vfold_cv(training_set, v = 5, strata = diagnosis)
gridvals <- tibble(neighbors = seq(1, 30, by = 2))

image_recipe <- recipes::recipe(diagnosis ~ ., data = training_set) |>
  recipes::step_scale(all_predictors()) |>
  recipes::step_center(all_predictors())

knn_fit <- build_model(training_set,
  image_recipe,
  optimal = "None",
  vfold = vfold,
  gridvals = gridvals
)

best_fit <- knn_fit |>
  dplyr::filter(.metric == "accuracy") |>
  dplyr::arrange(desc(mean)) |>
  dplyr::slice(1)

optimal_k <- best_fit |> dplyr::pull(neighbors)

write.csv(best_fit, paste0(opt$out_dir, "/cv_best_fit.csv"),
  row.names = FALSE
)

knn_fit <- build_model(training_set, image_recipe, "Yes", k = optimal_k)

# Predicting the training set --------------------------------------------------
diagnosis_test_predictions <- ipred::predict(knn_fit, training_set) |>
  dplyr::bind_cols(training_set)

diagnosis_test_predictions$diagnosis <-
  as.factor(diagnosis_test_predictions$diagnosis)

# pull metrics
diagnosis_prediction_confusion <- diagnosis_test_predictions |>
  yardstick::conf_mat(truth = diagnosis, estimate = .pred_class)

# plot confusion matrix for predictions
conf_matrix_fig <-
  ggplot2::autoplot(diagnosis_prediction_confusion, type = "heatmap") +
  ggplot2::scale_fill_gradient(low = "#D6EAF8", high = "#2E86C1") +
  ggplot2::ggtitle("Heat Map Of The Confusion Matrix for All Predictors")

ggsave(paste0(opt$out_dir, "/conf_matrix_fig.png"))

# Plot accuracy of models that used different predictor pairs ------------------

predictors <- colnames(training_set |> dplyr::select(-diagnosis))

# iterate over all pairs of predictors
two_predictors <- tibble(
  formula = c("diagnosis ~ ."), k = c(optimal_k),
  accuracy = c(best_fit |> dlypr::pull(mean)),
  false_healthy = c(diagnosis_prediction_confusion |>
    broom::tidy() |>
    dplyr::filter(name == "cell_1_2") |>
    dplyr::pull(value))
)

for (i in 2:length(predictors)) {
  for (j in 1:(i - 1)) {
    model_string <- paste(
      "diagnosis", "~",
      predictors[i], "+",
      predictors[j]
    )

    print(model_string)
    flush.console()

    # find best k
    image_recipe <- recipes::recipe(as.formula(model_string),
      data = training_set
    ) |>
      recipes::step_scale(all_predictors()) |>
      recipes::step_center(all_predictors())

    knn_fit <- build_model(training_set,
      image_recipe,
      "None",
      vfold = vfold,
      gridvals = gridvals
    )

    best_fit <- knn_fit |>
      dplyr::filter(.metric == "accuracy") |>
      dplyr::arrange(desc(mean)) |>
      dplyr::slice(1)

    optimal_k <- best_fit |> dplyr::pull(neighbors)

    # train
    knn_fit <- build_model(training_set, image_recipe, "Yes", k = optimal_k)

    predictions <- ipred::predict(knn_fit, training_set) |>
      dplyr::bind_cols(training_set)

    predictions$diagnosis <- as.factor(predictions$diagnosis)

    diagnosis_prediction_confusion <- predictions |>
      yardstick::conf_mat(truth = diagnosis, estimate = .pred_class) |>
      broom::tidy()

    two_predictors <- two_predictors |>
      tibble::add_row(
        formula = model_string,
        k = optimal_k,
        accuracy = best_fit |> pull(mean),
        false_healthy = diagnosis_prediction_confusion |>
          filter(name == "cell_1_2") |>
          pull(value)
      )
  }
}

two_predictors <- two_predictors |> dylpr::arrange(desc(accuracy))

# save results
write.csv(two_predictors, paste0(opt$out_dir, "/model_formulas_result.csv"),
  row.names = FALSE
)

# plot accuracy and false healthy data
plot_acc <- two_predictors |>
  ggplot2::ggplot(aes(x = accuracy, y = reorder(formula, accuracy))) +
  ggplot2::geom_bar(stat = "identity", fill = "#1f78b4") +
  ggplot2::scale_x_continuous(
    labels = scales::percent,
    limits = c(0, 1)
  ) +
  ggplot2::labs(x = "Accuracy", y = "Formula") +
  ggplot2::theme(axis.text.y = element_blank())

plot_false <- two_predictors |>
  ggplot2::ggplot(aes(x = false_healthy, y = reorder(formula, accuracy))) +
  ggplot2::geom_bar(stat = "identity", fill = "#a6cee3") +
  ggplot2::labs(x = "False Negatives", y = "Formula")

title <- ggplot2::ggdraw() +
  ggplot2::draw_label(
    "The False Negative and Accuracy Precentage by Predictors",
    fontface = "bold"
  )

plot <- cowplot::plot_grid(plot_false,
  plot_acc,
  ncol = 2,
  labels = "AUTO",
  align = "h"
)

plot_with_title <- cowplot::plot_grid(title,
  plot,
  ncol = 1,
  rel_heights = c(0.025, 1)
)

ggsave(paste0(opt$out_dir, "/predictors_result.png"),
  width = 20, height = 30, units = "cm"
)
