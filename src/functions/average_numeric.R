#' Compute averages of numeric factors
#'
#' @param dataset A data frame
#' @param class_col The name of the column to group by
#'
#' @return A data frame that contains the mean values of all numerical variables
#' @export
#'
#' @examples
#' avg_numeric(iris, Species)

avg_numeric <- function(dataset, class_col) {
  if (!is.data.frame(dataset)) {
    stop("`dataset` should be a data frame or data frame extension")
  }

  col_name <- deparse(substitute(class_col))
  cols <- colnames(dataset)

  if (!(col_name %in% cols)) {
    stop(paste("'",col_name,"'", " does not exist in this data frame",
               sep = ""))
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
