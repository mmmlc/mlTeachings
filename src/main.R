source('src/lib.R')
source('src/overview/make_dataset.R')
source('src/overview/train_models.R')
source('src/overview/plot_models.R')


methods = c('svmRadial', 'svmLinear', 'qda', 'knn', 'rf', 'nb', 'ada' )
# 'logreg', 'adaboost'

data = get_partitioned_df()

# train selected models ####
model = train_models(methods = 'ada')

#TODO plot side by side?
# plot model of choice ####
plot_models(model$nb$spirals$model, data$spirals$full)

# confusion matrix and other stats ####
model$rf$spirals$confusion_matrix

