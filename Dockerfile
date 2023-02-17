FROM rocker/rstudio:4.1.3

ENV RENV_VERSION 0.15.2-2
RUN Rscript -e "install.packages('remotes')"
RUN Rscript -e "remotes::install_github('rstudio/renv@${RENV_VERSION}')"

COPY renv.lock renv.lock
COPY renv renv
COPY .Rprofile .

RUN Rscript -e "renv::restore()"