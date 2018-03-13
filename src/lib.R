require(tidyverse)
require(caret)
require(keras)
require(mlbench)
require(ggthemes)
require(assertthat)

source('src/overview/make_dataset.R')

source('src/overview/train_models.R')
source('src/overview/plot_models.R')

source('src/overview/linear_svm.R')
source('src/overview/radial_svm.R')
source('src/overview/qda.R')
source('src/overview/knn.R')