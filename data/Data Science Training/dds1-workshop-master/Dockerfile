FROM jupyter/base-notebook:ae885c0a6226

USER root

RUN pip install --no-cache-dir \
                    numpy \
                    pandas \
                    scipy \
                    scikit-learn \
                    statsmodels \
                    matplotlib \
                    nbval \
                    keras \
                    tensorflow \
                    nltk \
                    pandas_datareader \
                    xlrd

ENV XDG_CACHE_HOME /home/$NB_USER/.cache/
RUN MPLBACKEND=Agg python -c "import matplotlib.pyplot" && \
    fix-permissions /home/$NB_USER

USER $NB_USER

MAINTAINER Phil Winder <phil@WinderResearch.com>
USER root
ENV SRC_DIR /src
RUN mkdir $SRC_DIR
COPY . .
COPY . /src
RUN chown -R $NB_USER:users $SRC_DIR && chown -R $NB_USER:users /home/$NB_USER
USER $NB_USER
