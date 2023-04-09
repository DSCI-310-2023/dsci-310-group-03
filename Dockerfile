FROM rocker/tidyverse:4.1.3

RUN Rscript -e "install.packages('remotes', repos='https://cran.us.r-project.org')"

RUN Rscript -e "remotes::install_version('cowplot', '1.1.1', repos = 'https://cloud.r-project.org')"
RUN Rscript -e "remotes::install_version('RColorBrewer', '1.1-2', repos = 'https://cloud.r-project.org')"
RUN Rscript -e "remotes::install_version('kknn', '1.3.1', repos = 'https://cloud.r-project.org')"
RUN Rscript -e "remotes::install_version('testthat', '3.1.3', repos = 'https://cloud.r-project.org')"
RUN Rscript -e "remotes::install_version('vdiffr', '1.0.5', repos = 'https://cloud.r-project.org')"
RUN Rscript -e "remotes::install_version('docopt', '0.7.1', repos = 'https://cloud.r-project.org')"
RUN Rscript -e "remotes::install_version('here', '1.0.1', repos = 'https://cloud.r-project.org')"
RUN Rscript -e "remotes::install_version('reader', '1.0.6', repos = 'https://cloud.r-project.org')"
RUN Rscript -e "remotes::install_version('bookdown', '0.19', repos = 'https://cloud.r-project.org')"
RUN Rscript -e "remotes::install_version('markdown', '1.1', repos = 'https://cloud.r-project.org')"
RUN Rscript -e "remotes::install_github('karlie-tr/dsci-310-group-03-pkg', force = TRUE)"