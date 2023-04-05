# Function input ---------------------------------------------------------------
lunch <- c("Pizza", "Sushi")
snack <- c("Sushi", "Donut")
price <- c(12, 30)

food_df <- data.frame(lunch, snack, price, stringsAsFactors = TRUE)

food_df_as_list <- list(lunch, snack, price)

empty_df <- data.frame(
  lunch = factor(),
  snack = factor()
)

# Expected result --------------------------------------------------------------
expected_vec <- data.frame(
  lunch = c("Pizza", "Pizza"),
  snack = c("Cheetos", "Donut"),
  price = c(12, 30),
  stringsAsFactors = TRUE
) |>
  dplyr::pull(snack)

species_vec <- iris$Species
