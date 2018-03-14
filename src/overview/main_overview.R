source('src/lib.R')


methods = list('linearSvm' = get_linearSvm_model,
               'radialSvm' = get_radialSvm_model,
               'qda' = get_qda_model,
               'knn' = get_knn_model,
               'rf' = get_rf_model
)

# 'logreg', 'adaboost'


# train selected models ####
model = train_models(methods = methods)


# plot trained models ####

data = get_partitioned_df(include_full = F)
plot_models(data, model)

# confusion matrix and other stats ####
model$rf$spirals$confusion_matrix
