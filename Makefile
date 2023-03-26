#Makefile
#Driver script to run other scripts in sequence
#
#Usage:
#to run the whole analysis from the beginning: make all
#to clear all the results output: make clean
#

all: 
	make clean
	make run-analysis
	make render-report
	make clean

.PHONY: run-analysis
analysis: results/numeric_plot.png results/categorical_plot.png results/variables_histogram.png results/cv_best_fit.csv results/conf_matrix_fig.png results/model_formulas_result.csv results/predictors_result.png results/selected_formula_cv_result.csv results/test_results.csv results/final_classification_plot.csv
# load data
data/raw/heart_disease_data.csv: src/01-download_data.R
	Rscript src/01-download_data.R --url=https://raw.githubusercontent.com/karlie-tr/dataset_heart_disease/main/heart_disease_data.csv --out_file=data/raw/heart_disease_data.csv

# preprocess the data
data/processed/training_set.csv data/processed/transformed_training_set.csv data/processed/transformed_testing_set.csv: data/raw/heart_disease_data.csv src/02-preprocess_data.R
	Rscript src/02-preprocess_data.R --input=data/raw/heart_disease_data.csv --out_train=data/processed/training_set.csv --out_transform_train=data/processed/transformed_training_set.csv --out_transform_test=data/processed/transformed_testing_set.csv

# Exploratory data visualization
results/summary_averages.csv: data/processed/training_set.csv src/03-exploratory_visualization.R
	Rscript src/03-exploratory_visualization.R data/processed results

results/numeric_plot.png: data/processed/training_set.csv src/03-exploratory_visualization.R
	Rscript src/03-exploratory_visualization.R data/processed results

results/categorical_plot.png: data/processed/training_set.csv src/03-exploratory_visualization.R
	Rscript src/03-exploratory_visualization.R data/processed results

results/variables_histogram.png: data/processed/training_set.csv src/03-exploratory_visualization.R
	Rscript src/03-exploratory_visualization.R data/processed results

# Build and optimize model
results/cv_best_fit.csv: data/processed/training_set.csv src/04-model_tuning.R
	Rscript src/04-model_tuning.R data/processed results

results/conf_matrix_fig.png: data/processed/training_set.csv src/04-model_tuning.R
	Rscript src/04-model_tuning.R data/processed results

results/model_formulas_result.csv: data/processed/training_set.csv src/04-model_tuning.R
	Rscript src/04-model_tuning.R data/processed results

results/predictors_result.png: data/processed/training_set.csv src/04-model_tuning.R
	Rscript src/04-model_tuning.R data/processed results

# Model selection and verification
results/selected_formula_cv_result.csv: data/processed/training_set.csv src/05-model_selection_verification.R
	Rscript src/05-model_selection_verification.R data/processed results results

results/test_results.csv: data/processed/training_set.csv data/processed/transformed_testing_set.csv src/05-model_selection_verification.R
	Rscript src/05-model_selection_verification.R data/processed results results

results/final_classification_plot.csv: data/processed/training_set.csv data/processed/transformed_testing_set.csv src/05-model_selection_verification.R
	Rscript src/05-model_selection_verification.R data/processed results results


.PHONY: render-report
report:
	Rscript -e "rmarkdown::render('doc/heart_disease_classification.Rmd', output_dir = here::here('doc'))"


.PHONY: clean
clean:
	rm -f data/processed/training_set.csv data/processed/transformed_testing_set.csv data/processed/transformed_training_set.csv data/raw/heart_disease_data.csv
	rm -f results/numeric_plot.png 
	rm -f results/categorical_plot.png
	rm -f results/variables_histogram.png
	rm -f results/cv_best_fit.csv
	rm -f results/conf_matrix_fig.png
	rm -f results/model_formulas_result.csv
	rm -f results/predictors_result.png
	rm -f results/selected_formula_cv_result.csv
	rm -f results/test_results.csv
	rm -f results/final_classification_plot.png
	rm -f results/summary_averages.csv
	rm -f doc/heart_disease_classification.html

.PHONY: run-docker
run-docker:
	docker run --rm -it -v "/${PWD}:/home/jovyan/work" -p 8888:8888 karlietr/dsci-310-group-03:latest make -C "/home/jovyan/work" all
