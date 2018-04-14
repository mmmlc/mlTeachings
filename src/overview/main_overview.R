source('src/lib.R')

methods = list()

methods = list('logReg' = get_logisticRegression_model,
               'linearSvm' = get_linearSvm_model,
               'polynomialSvm' = get_polySvm_model,
               'radialSvm' = get_radialSvm_model,
               'qda' = get_qda_model,
               'gaussProcess' = get_gaussianProcess_model,
               'knn' = get_knn_model,
               'dt' = get_decision_tree_model,
               'rf' = get_rf_model,
               'nnet' = get_nnet_model
)

# train selected models ####
model = train_models(methods = methods)

# plot trained models ####

data = get_partitioned_df(include_full = F)
plot_models(data, model)

model$polynomialSvm$spirals$model$bestTune

