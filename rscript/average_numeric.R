#'Compute averages of numeric factors
#'
#'Function to compare the mean values of the numerical attributes
#'
#'@param dataset the training set with a list of numerical attributes
#'@param class_col the name for the column to group by
#'
#'@export
#'
#'@example
#'avg_numeric(iris,Species)
#'
library(dplyr)
avg_numeric<- function(dataset, class_col){
  # returns a summary table of Average values of the numerical variables 
  summary_averages <- dataset |>
    group_by({{class_col}}) |>
    summarise_if(is.numeric, mean, na.rm = TRUE)
  return(summary_averages)
}

