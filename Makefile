# Makefile
# Driver script to run other scripts in sequence

# Usage:
# to run the whole analysis from the beginning: make all
# to clear all the results output: make clean

all: 
	make clean
	make analysis
	make report

# Run the analysis
.PHONY: analysis
analysis: 
	make load-data
	make eda
	make build-model
	make verify-model	

# Download data and perform preprocessing for model building
.PHONY: load-data
load-data: data/raw/heart_disease_data.csv data/processed/training_set.csv data/processed/transformed_training_set.csv data/processed/transformed_testing_set.csv

data/raw/heart_disease_data.csv: src/01-download_data.R
	Rscript src/01-download_data.R --url=https://raw.githubusercontent.com/karlie-tr/dataset_heart_disease/main/heart_disease_data.csv --out_file=data/raw/heart_disease_data.csv

data/processed/training_set.csv data/processed/transformed_training_set.csv data/processed/transformed_testing_set.csv: data/raw/heart_disease_data.csv src/02-preprocess_data.R
	Rscript src/02-preprocess_data.R --input=data/raw/heart_disease_data.csv --out_train=data/processed/training_set.csv --out_transform_train=data/processed/transformed_training_set.csv --out_transform_test=data/processed/transformed_testing_set.csv

# Create EDA from the data
.PHONY: eda
eda: results/summary_averages.csv results/numeric_plot.png results/categorical_plot.png results/variables_histogram.png

results/summary_averages.csv: data/processed/training_set.csv src/03-exploratory_visualization.R
	Rscript src/03-exploratory_visualization.R data/processed results

results/numeric_plot.png: data/processed/training_set.csv src/03-exploratory_visualization.R
	Rscript src/03-exploratory_visualization.R data/processed results

results/categorical_plot.png: data/processed/training_set.csv src/03-exploratory_visualization.R
	Rscript src/03-exploratory_visualization.R data/processed results

results/variables_histogram.png: data/processed/training_set.csv src/03-exploratory_visualization.R
	Rscript src/03-exploratory_visualization.R data/processed results

# Model building
.PHONY: build-model
build-model: results/cv_best_fit.csv results/conf_matrix_fig.png results/conf_matrix_table.csv results/model_formulas_result.csv results/predictors_result.png

results/cv_best_fit.csv: data/processed/training_set.csv src/04-model_tuning.R
	Rscript src/04-model_tuning.R data/processed results

results/conf_matrix_fig.png: data/processed/training_set.csv src/04-model_tuning.R
	Rscript src/04-model_tuning.R data/processed results

results/conf_matrix_table.csv: data/processed/training_set.csv src/04-model_tuning.R
	Rscript src/04-model_tuning.R data/processed results

results/model_formulas_result.csv: data/processed/training_set.csv src/04-model_tuning.R
	Rscript src/04-model_tuning.R data/processed results

results/predictors_result.png: data/processed/training_set.csv src/04-model_tuning.R
	Rscript src/04-model_tuning.R data/processed results

# Model Selection and Verification 
.PHONY: verify-model
verify-model: results/selected_formula_cv_result.csv results/test_results.csv results/final_classification_plot.png

results/selected_formula_cv_result.csv: data/processed/training_set.csv src/05-model_selection_verification.R
	Rscript src/05-model_selection_verification.R data/processed results results

results/test_results.csv: data/processed/training_set.csv data/processed/transformed_testing_set.csv src/05-model_selection_verification.R
	Rscript src/05-model_selection_verification.R data/processed results results

results/final_classification_plot.png: data/processed/training_set.csv data/processed/transformed_testing_set.csv src/05-model_selection_verification.R
	Rscript src/05-model_selection_verification.R data/processed results results

# Render reports in both html format
.PHONY: report
report: 
	Rscript -e "rmarkdown::render('doc/heart_disease_classification.Rmd', output_dir = here::here('doc'))"
  
# Delete the generated data, plots, and tables
.PHONY: clean
clean:
	rm -f data/processed/*.csv
	rm -f data/raw/heart_disease_data.csv
	rm -f results/*.png 
	rm -f results/*.csv
	rm -f doc/heart_disease_classification.html
	rm -f doc/heart_disease_classification.pdf

# Create a docker contaner from specified image
.PHONY: docker
docker:
	docker run --rm -it -v "/${PWD}:/home/rstudio" -p 8787:8787 -e PASSWORD=password karlietr/dsci-310-group-03:latest
