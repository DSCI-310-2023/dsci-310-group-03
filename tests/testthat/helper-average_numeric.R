# Set seed to make dataframe reproducible -------------------------------------
set.seed(105)

# Set up helper data frame ----------------------------------------------------
age <- round(runif(n = 5, min = 12, max = 20), 0)
height <- round(runif(n = 5, min = 120, max = 180), 2)
gender <- factor(c("M", "F", "F", "M", "M"))
final_grade <- c("A", "B", "C", "D", "F")

# function input for tests ----------------------------------------------------
grade_df <- data.frame(age, height, gender, final_grade)

empty_df <- data.frame(
  age = numeric(),
  height = numeric(),
  gender = factor(),
  final_grade = factor()
)

grade_df_as_list <- list(age, height, gender, final_grade)

# expected function output ----------------------------------------------------
grouped_by_gender_output <- grade_df |>
  dplyr::group_by(gender) |>
  dplyr::select_if(is.numeric) |>
  dplyr::summarize_all(mean, na = TRUE) |>
  as.data.frame()

grouped_by_grades_output <- grade_df |>
  dplyr::group_by(final_grade) |>
  dplyr::select_if(is.numeric) |>
  dplyr::summarize_all(mean, na = TRUE)|>
  as.data.frame()

