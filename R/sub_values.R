#' Replace values in a specified column
#' 
#' @param .data a data frame
#' @param column a column name
#' @param replacement a string
#' @param original a string
#' 
#' @result a data frame with the new column  
#'
#' @example 
#'  sub_values(iris, Species, 'replaced_Setosa', 'setosa')

library(dplyr)

sub_values <- function(data, column, replacement, original) {
  
  new_data <- 
    data |>
    mutate({{column}} := sub(original, replacement, {{column}})) |>
    mutate_if(is.character, as.factor)
  
  return(new_data)
}


