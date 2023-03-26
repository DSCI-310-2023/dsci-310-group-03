"Select a model from the options in the model tuning and predict on testing set

Outputs:
A csv file showing the accuracy result for selected formula, saved as 'selected_formula_cv_result.csv'
A csv file for accuracy results and confusion matrix for the selected formula on the testing set,
saved as 'test_results.csv'
A plot showing the domains of classification for the final model, saved as 'final_classification_plot.csv'

Usage: src/model_selection_verification.R <data_dir> <results_dir> <out_dir>

<data_dir>		  Path (not including filename) to data
<results_dir>   Path to directory where the model results are found
<output_dir>		Path to directory where the results should be saved
" -> doc

library(docopt)
library(tidymodels)
library(tidyverse)
set.seed(1020)

opt <- docopt(doc)

# read in datafiles ------------------------------------------------------------
two_predictors <- read.csv(paste0(opt$results_dir, "/model_formulas_result.csv"))
testing_set <- read.csv(paste0(opt$data_dir, "/transformed_testing_set.csv"))
training_set <- read.csv(paste0(opt$data_dir, "/transformed_training_set.csv"))

# build model with selected formula -------------------------------------------

testing_set <- testing_set |>
  select(-sex, -high_blood_sugar, -chest_pain_type)

training_set$diagnosis <- as.factor(training_set$diagnosis)

testing_set$diagnosis <- as.factor(testing_set$diagnosis)

selected_formula_cv_result <- two_predictors |> 
  filter(formula == "diagnosis ~ ." |
         formula == "diagnosis ~ exercise_pain + age")

write.csv(selected_formula_cv_result, 
  paste0(opt$out_dir, "/selected_formula_cv_result.csv"),
  row.names = FALSE
)

image_recipe <- recipe(diagnosis ~ exercise_pain + age, data = training_set) |>
  step_scale(all_predictors()) |>
  step_center(all_predictors())

knn_spec <- nearest_neighbor(weight_func = "rectangular", neighbors = 11) |>
  set_engine("kknn") |>
  set_mode("classification")

knn_fit <- workflow() |>
  add_recipe(image_recipe) |>
  add_model(knn_spec) |>
  fit(data = training_set)

# determine model accuracy ----------------------------------------------------

testing_set <- testing_set |> na.omit()

predictions <- predict(knn_fit, testing_set) |>
  bind_cols(testing_set)

final_quality <- predictions |>
  metrics(truth = diagnosis, estimate = .pred_class) |>
  filter(.metric == "accuracy")

write.csv(final_quality, paste0(opt$out_dir, "/test_results.csv"),
  row.names = FALSE)

# Model visualization ---------------------------------------------------------
# Code taken and adapted 
# from https://datasciencebook.ca/classification.html#fig:05-upsample-plot

# bind training_set and testing_set for viz
cleveland <- rbind(training_set, testing_set)

# define x and y grids
x_grid <- c(min(cleveland$exercise_pain, na.rm = TRUE),
            max(cleveland$exercise_pain, na.rm = TRUE))

y_grid <- min(cleveland$age):max(cleveland$age)

ex_age_grid <- as_tibble(expand.grid(
  exercise_pain = x_grid,
  age = y_grid
))

# use the fit workflow to make predictions at the grid points
knn_pred <- predict(knn_fit, ex_age_grid)

# bind the predictions as a new column with the grid points
prediction_table <- bind_cols(knn_pred, ex_age_grid) |>
  rename(Class = .pred_class)

# plot:
#   1. the colored scatter of the original data
#   2. the faded colored scatter for the grid points
wkflw_plot <-
  ggplot() +
  geom_point(
    data = cleveland,
    mapping = aes(
      x = exercise_pain,
      y = age,
      color = diagnosis
    ),
    alpha = 0.75
  ) +
  geom_point(
    data = prediction_table,
    mapping = aes(
      x = exercise_pain,
      y = age,
      color = Class
    ),
    alpha = 0.02,
    size = 10
  ) +
  labs(
    color = "Diagnosis",
    x = "Excercise Pain",
    y = "Age (years)"
  ) +
  scale_color_manual(
    labels = c("Healthy", "Sick"),
    values = c("steelblue2", "orange2")
  ) +
  theme(text = element_text(size = 12))

ggsave(paste0(opt$out_dir, "/final_classification_plot.png"))
