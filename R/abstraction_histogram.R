#' Abstraction of histograms for factorial variables
#'
#' Create a general function to remove repetitive ggplot functions
#'
#'
#'#'
#' @param x_aes x-value, factorial variable of the histogram
#' @param x_lab label for x-value of the histogram
#' @param data data set to study for the histogram
#' @param fill_aes variable to study for the histogram, "Diagnosis"
#' @param y_lab label for y-value of the histogram
#' @param fill_lab label for the variable, "Diagnosis" to study for the histogram
#'
#' @return A histogram based on study on diagnosis given different x-variable
#'
#' @export
#'
#' @examples
#' abs_hist(training_set$age, "Age", training_set, training_set$diagnosis, "Percentage of Observations", "Diagnosis")
abs_hist <- function(x_aes,  x_lab, data, fill_aes, y_lab, fill_lab) {
  # returns a histogram 
  histogram <- ggplot(data, aes(x = x_aes, fill = fill_aes)) + 
    geom_histogram(position="dodge") +
    labs(x = x_lab, y = y_lab, fill = fill_lab)+
    theme(text = element_text(size = 10)) +
    scale_fill_brewer(palette = "Paired")
  return(histogram)
}


