#' Compute averages of numeric factors
#'
#' Function to compare the mean values of the numerical attributes
#'
#' @param dataset the training set with a list of numerical attributes
#' @param class_col the name for the column to group by
#'
#' @example
#' avg_numeric(iris,Species)

avg_numeric <- function(dataset, class_col) {
  
  if (!is.data.frame(dataset)) {
    stop("dataset` should be a data frame or data frame extension")
  }
  
  if (is.character(dataset$class_col)) {
    new_dataset <- dataset |>
      mutate({{ class_col }} := as.factor({{ class_col }}))
  }
  new_dataset <- dataset
  summary_averages <- dataset |>
    dplyr::group_by({{ class_col }}) |>
    dplyr::summarise_if(is.numeric, mean, na.rm = TRUE) |>
    as.data.frame()

  return(summary_averages)
}

