#' Compute averages of numeric factors
#'
#' Function to compare the mean values of the numerical attributes
#'
#' @param dataset the training set with a list of numerical attributes
#' @param class_col the name for the column to group by

#' @example
#' avg_numeric(iris,Species)

avg_numeric <- function(dataset, class_col) {
  summary_averages <- dataset |>
    dplyr::group_by({{ class_col }}) |>
    dplyr::summarise_if(is.numeric, mean, na.rm = TRUE)

  return(summary_averages)
}

