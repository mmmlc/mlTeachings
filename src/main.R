source('src/lib.R')
source('src/overview/make_dataset.R')
source('src/overview/train_models.R')
source('src/overview/plot_models.R')


methods = list('linearSvm' = get_linearSvm_model,
               'radialSvm' = get_radialSvm_model,
               'qda' = get_qda_model,
               'knn' = get_knn_model
)

# 'logreg', 'adaboost'

data = get_partitioned_df()

# train selected models ####
model = train_models(methods = methods, data)

#TODO plot side by side?
# plot model of choice ####

### remove full
data[["full"]] <- NULL
plot_models(data, model)

# confusion matrix and other stats ####
model$rf$spirals$confusion_matrix

