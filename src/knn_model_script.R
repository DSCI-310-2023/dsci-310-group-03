library(tidymodels)
library(tidyverse)

source("./R/build_model.R")

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

best_fit


knn_fit <- build_model(training_set, image_recipe, "Yes", k = optimal_k)

# predicting the whole training set to get an idea of the accuracy
# Since the choice of which variables to include as predictors
# is part of tuning your classifier, you cannot use your test data for this process!
diagnosis_test_predictions <- predict(knn_fit, training_set) %>%
  bind_cols(training_set)

# pull metrics
diagnosis_prediction_confusion <- diagnosis_test_predictions %>%
  conf_mat(truth = diagnosis, estimate = .pred_class)

diagnosis_prediction_confusion


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

two_predictors %>% arrange(desc(accuracy))

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
plot_grid(plot_false, plot_acc, ncol = 2)
