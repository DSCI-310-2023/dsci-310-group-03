#' Replace values in a specified column
#'
#' @param data a data frame
#' @param column a column that exists within the data frame
#' @param replacement a string
#' @param original a string
#'
#' @return A vector of the new column with the replaced values
#' @export
#'
#' @examples
#' sub_values(iris, Species, "replaced_Setosa", "setosa")

sub_values <- function(dataset, column, replacement, original) {
  if (!is.data.frame(dataset)) {
    stop("`dataset` should be a data frame or data frame extension")
  }

  col_name <- deparse(substitute(column))
  cols <- colnames(dataset)

  if (!(col_name %in% cols)) {
    stop(paste("'", col_name, "'", " does not exist in this data frame",
      sep = ""
    ))
  }

  new_data <-
    dataset |>
    dplyr::mutate({{ column }} := sub(original, replacement, {{ column }})) |>
    dplyr::mutate_if(is.character, as.factor)
  new_column <- dplyr::pull(new_data, {{ column }})

  return(new_column)
}
