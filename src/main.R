source('src/lib.R')
source('src/overview/make_dataset.R')
source('src/overview/train_models.R')
source('src/overview/plot_models.R')


methods = c('svmRadial', 'svmLinear', 'qda', 'knn', 'rf', 'nb')
# 'logreg', 'adaboost'

data = get_partitioned_df()

# train selected models ####
model = train_models(methods = methods)

#TODO plot side by side?
# plot model of choice ####
plot_models(model$rf$circles$model, data$circles$full_val)

# confusion matrix and other stats ####
model$rf$spirals$confusion_matrix

