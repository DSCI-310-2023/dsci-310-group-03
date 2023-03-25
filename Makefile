#Makefile
#Driver script to run other scripts in sequence
#
#Usage:
#to run the whole analysis from the beginning: make all
#to clear all the results output: make clean
#
all: notebook/heart_disease_classification.html

#load data
data/raw/heart_disease_data.csv: src/download_data.R
	Rscript src/download_data.R --url=https://raw.githubusercontent.com/karlie-tr/dataset_heart_disease/main/heart_disease_data.csv --out_file=data/raw/heart_disease_data.csv

#preprocess the data
data/processed/training_set.csv: data/raw/heart_disease_data.csv src/preprocess_data.R
	Rscript src/preprocess_data.r --input=data/raw/heart_disease_data.csv --out_train=results/training_set.csv --out_test=results/testing_set.csv

data/processed/testing_set.csv: data/raw/heart_disease_data.csv src/preprocess_data.R
	Rscript src/preprocess_data.r --input=data/raw/heart_disease_data.csv --out_train=results/training_set.csv --out_test=results/testing_set.csv

#Exploratory data visualization
results/numeric_plot.png: data/processed/training_set.csv src/exploratory_visualization.R
	Rscript src/exploratory_visualization.R data/processed/training_set.csv results

results/categorical_plot.png: data/processed/training_set.csv src/exploratory_visualization.R
	Rscript src/exploratory_visualization.R data/processed/training_set.csv results

results/variables_histogram.png: data/processed/training_set.csv src/exploratory_visualization.R
	Rscript src/exploratory_visualization.R data/processed/training_set.csv results

#Build and optimize model
results/cv_best_fit.csv: data/processed/training_set.csv src/model_tuning.R
	Rscript src/model_tuning.R data/processed results

results/diagnosis_prediction_confusion.csv: data/processed/training_set.csv src/model_tuning.R
	Rscript src/model_tuning.R data/processed results

results/model_formulas_result.csv: data/processed/training_set.csv src/model_tuning.R
	Rscript src/model_tuning.R data/processed results

results/predictors_result.png: data/processed/training_set.csv src/model_tuning.R
	Rscript src/model_tuning.R data/processed results

#Model selection and verification
results/selected_formula_cv_result.csv: data/processed/training_set.csv data/processed/testing_set.csv src/model_selection_verification.R
	Rscript src/model_selection_verification.R data/processed results results

results/test_results.csv: data/processed/training_set.csv data/processed/testing_set.csv src/model_selection_verification.R
	Rscript src/model_selection_verification.R data/processed results results

results/final_classification_plot.csv: data/processed/training_set.csv data/processed/testing_set.csv src/model_selection_verification.R
	Rscript src/model_selection_verification.R data/processed results results

#render report
notebook/notebook/heart_disease_classification.html: notebook/notebook/heart_disease_classification.Rmd results/numeric_plot.png results/categorical_plot.png results/variables_histogram.png results/cv_best_fit.csv results/diagnosis_prediction_confusion.csv results/model_formulas_result.csv results/predictors_result.png results/selected_formula_cv_result.csv results/test_results.csv results/final_classification_plot.csv
	Rscript -e "rmarkdown::render('notebook/'heart_disease_classification.Rmd)"

clean:
	rm -f data/processed/training_set.csv data/processed/testing_set.csv data/raw/heart_disease_data.csv
	rm -f results/numeric_plot.png 
	rm -f results/categorical_plot.png
	rm -f results/variables_histogram.png
	rm -f results/cv_best_fit.csv
	rm -f results/diagnosis_prediction_confusion.csv
	rm -f results/model_formulas_result.csv
	rm -f results/predictors_result.png
	rm -f results/selected_formula_cv_result.csv
	rm -f results/test_results.csv
	rm -f results/final_classification_plot.csv