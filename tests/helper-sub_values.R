# Species vector
Species_vec <- iris$Species

# Expected result
expected_vec <- data.frame(lunch = c("Pizza", "Pizza"),
                           snack = c("Cheetos","Donut"),
                           stringsAsFactors = TRUE) |>
  dplyr::pull(snack)

# Original data frame
original_df <- data.frame(lunch = c("Pizza","Sushi"),
                          snack = c("Sushi","Donut"),
                          stringsAsFactors = TRUE)
