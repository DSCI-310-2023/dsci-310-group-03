#' Replace values in a specified column
#'
#' @param data a data frame
#' @param column a column that exists within the data frame
#' @param replacement a string
#' @param original a string
#'
#' @result the new column with the replaced values
#'
#' @example
#'  sub_values(iris, Species, 'replaced_Setosa', 'setosa')

sub_values <- function(data, column, replacement, original) {
  new_data <-
    data |>
    dplyr::mutate({{ column }} := sub(original, replacement, {{ column }})) |>
    dplyr::mutate_if(is.character, as.factor)
  new_column <- dplyr::pull(new_data, {{ column }})

  return(new_column)
}
