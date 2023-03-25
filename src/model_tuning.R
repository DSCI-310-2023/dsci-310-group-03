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

library(docopt)
library(tidymodels)
library(tidyverse)
library(cowplot)
library(here)
source(here("R/build_model.R"))
set.seed(1020)

opt <- docopt(doc)

training_set <- read.csv(paste0(opt$input_dir,'/transformed_training_set.csv'))

# Perform cross validation to find optimal k
vfold <- vfold_cv(training_set, v = 5, strata = diagnosis)
gridvals <- tibble(neighbors = seq(1, 30, by = 2))

image_recipe <- recipe(diagnosis ~ ., data = training_set) %>%
  step_scale(all_predictors()) %>%
  step_center(all_predictors())

knn_fit <- build_model(training_set,
                       image_recipe,
                       optimal = "None",
                       vfold = vfold,
                       gridvals = gridvals)

best_fit <- knn_fit %>%
  filter(.metric == "accuracy") %>%
  arrange(desc(mean)) %>%
  slice(1)

optimal_k <- best_fit %>% pull(neighbors)

write.csv(best_fit, paste0(opt$out_dir,"/cv_best_fit.csv"))

knn_fit <- build_model(training_set, image_recipe, "Yes", k = optimal_k)

# predicting the whole training set to get an idea of the accuracy
# Since the choice of which variables to include as predictors
# is part of tuning your classifier, you cannot use your test data for this process!
diagnosis_test_predictions <- predict(knn_fit, training_set) %>%
  bind_cols(training_set)
diagnosis_test_predictions$diagnosis <- as.factor(diagnosis_test_predictions$diagnosis)
# pull metrics
diagnosis_prediction_confusion <- diagnosis_test_predictions %>%
  conf_mat(truth = diagnosis, estimate = .pred_class)
capture.output(diagnosis_prediction_confusion, file = paste0(opt$out_dir,"/diagnosis_prediction_confusion.csv"))

### WARNING ###
# This cell takes about 4 minutes to run!
# We print the current formula we train to show the progress made
# The last formula "diagnosis ~ thal + no_vessels_colored"
# please do not interrupt the kernel and just let it take it's time
### WARNING ###

predictors <- colnames(training_set %>% select(-diagnosis))
# iterate over all pairs of predictors
two_predictors <- tibble(formula = c("diagnosis ~ ."), k = c(optimal_k),
                         accuracy = c(best_fit %>% pull(mean)),
                         false_healthy = c(diagnosis_prediction_confusion %>%
                                             tidy() %>%
                                             filter(name == "cell_1_2") %>%
                                             pull(value)))

for (i in 2:length(predictors)) {
  for (j in 1:(i - 1)) {
    model_string <- paste("diagnosis", "~",
                          predictors[i], "+",
                          predictors[j])
    
    print(model_string)
    flush.console()
    
    # find best k
    image_recipe <- recipe(as.formula(model_string),
                           data = training_set) %>%
      step_scale(all_predictors()) %>%
      step_center(all_predictors())
    
    knn_fit <- build_model(training_set,
                           image_recipe,
                           "None",
                           vfold = vfold,
                           gridvals = gridvals)
    
    best_fit <- knn_fit %>%
      filter(.metric == "accuracy") %>%
      arrange(desc(mean)) %>%
      slice(1)
    
    optimal_k <- best_fit %>% pull(neighbors)
    
    # train
    knn_fit <- build_model(training_set, image_recipe, "Yes", k = optimal_k)
    
    predictions <- predict(knn_fit, training_set) %>%
      bind_cols(training_set)
    predictions$diagnosis <- as.factor(predictions$diagnosis)
    diagnosis_prediction_confusion <- predictions %>%
      conf_mat(truth = diagnosis, estimate = .pred_class) %>%
      tidy()
    
    two_predictors <- two_predictors %>%
      add_row(formula = model_string,
              k = optimal_k,
              accuracy = best_fit %>% pull(mean),
              false_healthy = diagnosis_prediction_confusion %>%
                filter(name == "cell_1_2") %>%
                pull(value))
  }
}

two_predictors <- two_predictors %>% arrange(desc(accuracy))

write.csv(two_predictors,paste0(opt$out_dir,"/model_formulas_result.csv"))

plot_acc <- two_predictors %>%
  ggplot(aes(x = accuracy, y = reorder(formula, accuracy))) +
  geom_bar(stat = "identity", fill = "#1f78b4") +
  scale_x_continuous(labels = scales::percent,
                     limits = c(0, 1)) +
  labs(x = "Accuracy") +
  theme(axis.text.y = element_blank())

plot_false <- two_predictors %>% 
  ggplot(aes(x = false_healthy, y = reorder(formula, accuracy))) +
  geom_bar(stat = "identity", fill = "#a6cee3") +
  labs(x = "False Negatives", y = "Formula")

options(repr.plot.width = 12, repr.plot.height = 12)
plot <- plot_grid(plot_false, plot_acc, ncol = 2)

ggsave(paste0(opt$out_dir,"/predictors_result.png"))

