# Define variables ---------------------------------------------------------
path <- "../../data/raw/heart_disease_data.csv"

column_names <- c(
  "age", "sex", "chest_pain_type", "resting_bp",
  "cholesterol", "high_blood_sugar", "resting_ecg",
  "max_heart_rate", "exercise_pain", "old_peak", "slope",
  "no_vessels_colored", "thal", "diagnosis", "diagnosis_2"
)

# Load helper data --------------------------------------------------------

data_from_read_delim <- readr::read_delim(
  path,
  delim = ",",
  col_names = column_names,
  na = "?"
) |>
  dplyr::mutate_if(is.character, as.factor)

