#'Building model
#'
#'Function to build knn model with cross validation
#'
#'@param recipe a recipe to prepare the data for modelling
#'@param optimal a variable that takes in the string "None" or "Yes" to specify whether
#'to use tune() for the neighbors("None" optimal yet) or use an existing number of optimal k
#'@param k Additional numeric argument, take in an integer to indicate the number of
#'optimal neighbors for the model
#'
#'@return a fitted knn model
#'
#'@export
#'
#'@example build_model(image_recipe, NULL)

build_model <- function(recipe, optimal, k) {
  if(optimal=="None"){
    knn_spec <- nearest_neighbor(weight_func = "rectangular", neighbors = tune()) %>%
      set_engine("kknn") %>%
      set_mode("classification")
    }
  else {
    knn_spec <- nearest_neighbor(weight_func = "rectangular", neighbors = 13) %>%
      set_engine("kknn") %>%
      set_mode("classification")
   }
  knn_fit <- workflow() %>%
    add_recipe(recipe) %>%
    add_model(knn_spec) %>%
    tune_grid(resamples = {{vfold}}, grid={{gridvals}})%>%
    collect_metrics()
  
  return(knn_fit)
}