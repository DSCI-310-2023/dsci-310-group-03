#'Building model
#'
#'Function build_model() to build knn model with cross validation
#'
#'@param recipe a recipe to prepare the data for modelling
#'@param optimal a variable that takes in the string "None" or "Yes" to specify whether
#'to use tune() for the neighbors("None" optimal yet) or use an existing number of optimal k
#'@param k Additional numeric argument, take in an integer to indicate the number of
#'optimal neighbors for the model
#'
#'@return a fitted knn model
#'
#''@example build_model(image_recipe, NULL)
#'
#''Function get_best_fit() to obtain the statistics of the best knn_fit after tuning
#'@param model a fitted model, such as the return from the previous function
#'
#'@return a dataframe of the statistics for the optimal knn model
#'
#'@example get_best_k(knn_fit)
#'
#'@export
#'
#

build_model <- function(recipe, optimal, k) {
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

get_best_fit <- function(model) {
  best_fit <- knn_fit %>%
    filter(.metric == "accuracy") %>%
    arrange(desc(mean)) %>% 
    slice(1)
  return(best_fit)
}
