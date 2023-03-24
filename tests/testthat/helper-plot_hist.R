
# Plot for Sepal.Length -----------------------------------
histogram_1 <- iris |>
  ggplot2::ggplot(ggplot2::aes(x = Sepal.Length, fill = Species)) +
  ggplot2::geom_histogram(bins = 20, position = "dodge") +
  ggplot2::labs(x = "Sepal.Length",
                y = "Frequency",
                fill = "Species") +
  ggplot2::theme(text = ggplot2::element_text(size = 10)) +
  ggplot2::scale_fill_brewer(palette = "Paired")

# Plot for Sepal.Width --------------------------------------------
histogram_2 <- iris |>
  ggplot2::ggplot(ggplot2::aes(x = Sepal.Width, fill = Species)) +
  ggplot2::geom_histogram(bins = 20, position = "dodge") +
  ggplot2::labs(x = "Sepal.Width",
                y = "Frequency",
                fill = "Species") +
  ggplot2::theme(text = ggplot2::element_text(size = 10)) +
  ggplot2::scale_fill_brewer(palette = "Paired")

# Plot for Petal.Length -------------------------------------------
histogram_3 <- iris |>
  ggplot2::ggplot(ggplot2::aes(x = Petal.Length, fill = Species)) +
  ggplot2::geom_histogram(bins = 20, position = "dodge") +
  ggplot2::labs(x = "Petal.Length",
                y = "Frequency",
                fill = "Species") +
  ggplot2::theme(text = ggplot2::element_text(size = 10)) +
  ggplot2::scale_fill_brewer(palette = "Paired")

# Plot for Petal.Width -------------------------------------------
histogram_4 <- iris |>
  ggplot2::ggplot(ggplot2::aes(x = Petal.Width, fill = Species)) +
  ggplot2::geom_histogram(bins = 20, position = "dodge") +
  ggplot2::labs(x = "Petal.Width",
                y = "Frequency",
                fill = "Species") +
  ggplot2::theme(text = ggplot2::element_text(size = 10)) +
  ggplot2::scale_fill_brewer(palette = "Paired")


