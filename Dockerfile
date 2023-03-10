FROM jupyter/r-notebook:r-4.1.3

RUN Rscript -e "install.packages('remotes', repos='https://cloud.r-project.org')"

RUN Rscript -e "remotes::install_version('cowplot', '1.1.1')"
RUN Rscript -e "remotes::install_version('RColorBrewer', '1.1-2')"
RUN Rscript -e "remotes::install_version('kknn','1.3.1')"
RUN Rscript -e "remotes::install_version('testthat, '3.1.6')"