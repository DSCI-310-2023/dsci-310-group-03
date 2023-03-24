#' Abstraction of histograms for factorial variables
#'
#' Create a general function to remove repetitive ggplot functions
#'
#' @param data the data frame
#' @param class_column the groups that we are going to grouped the variables by
#' @param bins a number that indicates
#'             the number of bins in histograms
#' @param ncol the number of columns when arranging the plots
#'
#' @return A histogram of all numeric variables that is
#'         grouped by the class_Column
#'
#' @examples
#' plot_hist(iris, Species, binwidth = 0.25)
#' plot_hist(iris, Species)
#' plot_hist(iris, Species, binwidth = 0.25, col = 3)
plot_hist <- function(data,
                      class_column,
                      bins = 20,
                      col = 2) {
  
  # Create a new empty list
  plots <- list()

  # Determine columns that is numeric
  numeric_col <- data |>
    dplyr::select_if(is.numeric) |>
    colnames()

  # Create a dataframe with only numeric columns and class_column
  numeric_df <- data |>
    dplyr::select(numeric_col, {{ class_column }}) |>
    as.data.frame()

  # Generate a plot for each variable that is numeric
  for (i in 1:(ncol(numeric_df) - 1)) {
    categories <- dplyr::pull(
      numeric_df,
      {{ class_column }}
    )
    
    plots[[i]] <- local({
      i <- i
      histogram <- data |>
        ggplot2::ggplot(ggplot2::aes(
          x = numeric_df[, i],
          fill = categories
        )) +
        ggplot2::geom_histogram(
          bins = bins,
          position = "dodge"
        ) +
        ggplot2::labs(
          x = colnames(numeric_df)[i],
          y = "Frequency",
          fill = colnames(numeric_df)[length(numeric_df)]
        ) +
        ggplot2::theme(text = ggplot2::element_text(size = 10)) +
        ggplot2::scale_fill_brewer(palette = "Paired")
    })
  }

  # return the arranged plots with labels
  return(cowplot::plot_grid(
    plotlist = plots,
    ncol = col,
    labels = "auto",
    label_size = 10
  ))
}

plot_hist(iris, Species)
