options(warn = -1)

suppressMessages(
  {
    require(tidyverse)
    require(caret)
    require(keras)
    require(mlbench)
    require(ggthemes)
    require(assertthat)
    require(kernlab)
    require(rattle)
    require(Metrics)
    require(AUC)
  }
)


# install_keras()

source('src/overview/make_dataset.R')

source('src/overview/train_models.R')
source('src/overview/plot_models.R')

source('src/overview/linear_svm.R')
source('src/overview/radial_svm.R')
source('src/overview/polynomial_svm.R')
source('src/overview/qda.R')
source('src/overview/knn.R')
source('src/overview/rf.R')
source('src/overview/logistic_regression.R')
source('src/overview/decision_tree.R')
source('src/overview/gaussian_process.R')
source('src/overview/mlp.R')
source('src/overview/nnet.R')
source('src/overview/fancyRPartPlot.R')
