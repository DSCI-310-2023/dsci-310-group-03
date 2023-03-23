#' Abstraction of histograms for factorial variables
#'
#' Create a general function to remove repetitive ggplot functions
#'
#' @param data the data frame
#' @param class_column the groups that we are going to grouped the variables by
#' @param binwidth a number that indicates 
#'                 the bin width of the individual histograms
#' @param ncol the number of columns when arranging the plots
#'
#' @return A histogram of all numeric variables that is 
#'         grouped by the class_Column
#'
#' @examples
#' plot_hist(iris, Species, binwidth = 0.25)

plot_hist <- function(data, 
                     class_column, 
                     binwidth = 20,
                     ncol = 2) {
  
  # Create a new empty list
  plots <- list()
  
  # Generate a plot for each variable that is not numeric
  for (i in 1:ncol(data)) {
    
    if (!is.numeric(data[ ,i])) {
      next
    }
    
    x_axis <- data[ ,i]
    x_label <- colnames(data)[i]
    fill <- dplyr::pull(data, {{ class_column }})
    
    histogram <- data |>
      ggplot2::ggplot(ggplot2::aes(x = x_axis,
                                   fill = fill)) +
      ggplot2::geom_histogram(binwidth = binwidth,
                              position = "dodge") +
      ggplot2::labs(x = print(x_label), 
                    y = "Frequency", 
                    fill = names(fill)) +
      ggplot2::theme(text = ggplot2::element_text(size = 10)) +
      ggplot2::scale_fill_brewer(palette = "Paired")
    
    plots[[i]] <- histogram
  
  }
  
  # return the arranged plots with labels
  return(cowplot::plot_grid(plotlist = plots,
                            ncol = ncol,
                            labels = "auto",
                            label_size = 10))
}
