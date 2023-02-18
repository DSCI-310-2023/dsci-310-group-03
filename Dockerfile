FROM jupyter/r-notebook:r-4.1.3

RUN Rscript -e "install.packages('remotes', repos='https://cran.us.r-project.org')"

RUN Rscript -e "remotes::install_version('cowplot', version='1.1.1')"
RUN Rscript -e "remotes::install_version('RColorBrewer', version='1.1-2')"