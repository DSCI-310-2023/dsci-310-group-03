'
Downloads  data from the web to a local filepath as either a csv file format.

Usage: src/download_data.py --url=<url> --out_file=<out_file>

Options:
--url=<url>              URL from where to download the data
--out_file=<out_file>    Path (including filename) of where to locally write the file

Example: 
data/raw/heart_disease_data.csv: src/download_data.R
  Rscript src/download_data.R --out_type=csv --url=https://archive.ics.uci.edu/ml/machine-learning-databases/heart-disease/cleve.mod --out_file="../data/raw/heart_disease_data.csv"
' -> doc

library(docopt)

opt <- docopt(doc)

main <- function(url, out_file) {
  # read data downloaded from the web
  heart_disease_data <- read.csv(url, sep=" ", skip=20, header=FALSE)
  
  # write the data locally
  write.table(heart_disease_data, out_file, row.names = FALSE, col.names = FALSE, sep = ',')
}

main(opt[["--url"]], opt[["--out_file"]])