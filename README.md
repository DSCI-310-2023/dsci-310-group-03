# Diagnosing Heart Disease
- Authors: Hanzhang Cao, Karlie Truong, Kaylie Nguyen, Ser Jie Ng
- Contributors: Hanzhang Cao, Matthias Kammueller, Nicole White

## About
The project is developed upon the dsci100 term project by the contributors listed above. Permission to reuse the data analysis has been given by all contributors. We aim to determine: Based on only two predictors gathered from health checkups performed by doctors, does somebody suffer from heart disease?

To answer this question, we analyze the Cleveland data file from https://archive.ics.uci.edu/ml/datasets/Heart+Disease, containing data collected by Robert Detrano at the V.A. Medical Center, Long Beach and Cleveland Clinic Foundation in 1988. This dataset contains 303 instances. 

We attempt to build a classification model using the K-nearest neighbour algorithm to predict heart disease diagnosis. Our model offers a preliminary diagnosis based 2 symptoms. This can save medical costs for patients who are properly diagnosed with heart disease by our model as well as diagnostic time. 

## Team work Contract
Team work contract for group 03 is found in the README.md file in [commit ba459c1](https://github.com/karlie-tr/dsci-310-group-03/tree/ba459c1340d4a1efffd9a90d9d0eecddbd498a81)

## Report
The data analysis report can be found [here](https://github.com/karlie-tr/dsci-310-group-03/blob/1c9dee99b0c500339d5705034ac46a6c5b25daaa/heart_disease_classification.ipynb)

## Usage
In your terminal, navigate to the folder where you want to store the project then clone it project into your local computer 
    ```git clone https://github.com/karlie-tr/dsci-310-group-03.git```
Once the git repository is on your computer, navigate into the folder with 
    ```cd dsci-310-group-03```
The analysis can be run using 2 different ways:
### Running the analysis from a container
To maintain the reproducibility of this project, we use Docker container images to create the same computational environment that the project was created on. In order to run our analysis, please follow the steps listed below:
1. Create an account and install DockerHub following the instruction [here](https://docs.docker.com/get-docker/)
2. In your terminal, pull the lastest version of the Docker image
    ```docker pull karlietr/dsci-310-group-03:latest```
3. To run the analysis from the Docker container:
    - In terminal:
    ```docker run --rm -it -v "/${PWD}:/home/jovyan/work" -p 8888:8888 karlietr/dsci-310-group-03:latest```
        - Troubleshooting:
        If encounter *The input device is not a TTY* error, use
        ```docker run --rm -i -v "/${PWD}:/home/jovyan/work" -p 8888:8888 karlietr/dsci-310-group-03:latest```
### Running the analysis from local computer:
To run this analysis in your local computer:
1. Install all the packages listed in dependencies below.
2. Clone this repository in your terminal:
    `git clone https://github.com/karlie-tr/dsci-310-group-03.git`
3. To run the entire analysis from the beginning:
    `make all`
4. To clear all the results and reset to beginning:
    `make clean`

## Dependencies
|Package | Version |
|--------|---------|
|R|4.1.3|
|tidyverse |1.3.1|
|tidymodels|0.2.0|
|RColorBrewer|1.1-2|
|cowplot|1.1.1|
|kknn|1.3.1|
|testthat|3.1.3|
|vdiffr|1.0.5|
|devtools|2.4.5|
|docopt|0.7.1|
|here|1.0.1|

## License Information
Our project uses the MIT open source license.


