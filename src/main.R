source('src/lib.R')
source('src/overview/make_dataset.R')
source('src/overview/train_models.R')
source('src/overview/plot_models.R')


methods = c('svmRadial', 'svmLinear', 'qda', 'knn', 'rf', 'nb' )
# 'logreg', 'adaboost'

data = get_partitioned_df()

# train selected models ####
model = train_models(methods = methods)


# plot model of choice ####
plot_models(model$nb$spirals$model, data$spirals$full_val)

# confusion matrix and other stats ####
model$rf$spirals$confusion_matrix


data$circles$full_val$type %>% unique()
