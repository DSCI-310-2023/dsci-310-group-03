#'Data encoding for model
#'
#'Function to convert the categorical variables to quantitative
#'
#'@param df a dataframe consisting of the data of interest
#'
#'@export
#'
#'@example
#'transform_numeric(df)

transform_numeric <- function(df) {
    mutated <- mutate(df,
                    exercise_pain=as.character(exercise_pain),
                    exercise_pain=replace(exercise_pain, exercise_pain=="fal", "0"),
                    exercise_pain=as.numeric(replace(exercise_pain, exercise_pain=="true", "1")),
                    
                    slope=as.character(slope),
                    slope=replace(slope, slope=="down", "-1"),
                    slope=replace(slope, slope=="flat", "0"),
                    slope=as.numeric(replace(slope, slope=="up", "1")),
                    
                    # Below values are 'non-standard' values for a better scale
                    thal=as.character(thal),
                    thal=replace(thal, thal=="rev", "4"),
                    thal=replace(thal, thal=="norm", "0"),
                    thal=as.numeric(replace(thal, thal=="fix", "5")),

                    resting_ecg=as.character(resting_ecg),
                    resting_ecg=replace(resting_ecg, resting_ecg=="abn", "4"),
                    resting_ecg=replace(resting_ecg, resting_ecg=="norm", "0"),
                    resting_ecg=as.numeric(replace(resting_ecg, resting_ecg=="hyp", "5")),
                    )
    return(mutated)
    }
   