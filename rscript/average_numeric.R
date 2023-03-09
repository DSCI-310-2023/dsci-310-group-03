#'Compute averages of numeric factors
#'
#'Function to compare the mean values of the numerical attributes
#'
#'@param data the training set with a list of numerical attributes
#'
#'@export
#'
#'@example
#'avg_numeric<-function(training_set)
#'
avg_numeric<- function(data){
  # returns a summary table of Average values of the numerical attributes 
  summary_averages <- data %>%
    group_by(diagnosis) %>%
    summarize(count=n(), 
              mean_age=mean(age), 
              mean_resting_bp=mean(resting_bp), 
              mean_cholesterol=mean(cholesterol),
              mean_max_heart_rate=mean(max_heart_rate), 
              mean_old_peak=mean(old_peak),
              mean_no_vessels_colored=mean(no_vessels_colored, na.rm = TRUE))
  return(summary_averages)
}
