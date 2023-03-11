#'Building model
#'
#'Function build_model() to build knn model with cross validation
#'
#'@param training_set dataframe containing the data to train the model on
#'@param recipe a recipe to prepare the data for modelling
#'@param optimal a variable that takes in the string "None" or "Yes" to specify whether
#'to use tune() for the neighbors("None" optimal yet) or use an existing number of optimal k
#'@param k Additional numeric argument, take in an integer to indicate the number of
#'optimal neighbors for the model
#'@param vfold dataframe containing data splitted into folds for cross validation
#'@param gridvals tibble containing values of k for tuning
#'
#'@return a fitted knn model
#'
#''@example build_model(image_recipe, NULL)
#'
#'@export
#'
#

build_model <- function(training_set, recipe, optimal, vfold, gridvals, k) {
  if(optimal=="None"){
    knn_spec <- nearest_neighbor(weight_func = "rectangular", neighbors = tune()) %>%
      set_engine("kknn") %>%
      set_mode("classification")
    knn_fit <- workflow() %>%
      add_recipe(recipe) %>%
      add_model(knn_spec) %>%
      tune_grid(resamples = {{vfold}}, grid={{gridvals}})%>%
      collect_metrics()
  }
  else if (optimal == 'Yes') {
    knn_spec <- nearest_neighbor(weight_func = "rectangular", neighbors = k) %>%
      set_engine("kknn") %>%
      set_mode("classification")
    knn_fit <- workflow() %>%
      add_recipe(recipe) %>%
      add_model(knn_spec) %>%
      fit(data = {{training_set}})
  }
  
  
  return(knn_fit)
}

