source('src/lib.R')

methods = list()

methods = list('logReg' = get_logisticRegression_model,
               'linearSvm' = get_linearSvm_model,
               'radialSvm' = get_radialSvm_model,
               'qda' = get_qda_model,
               'knn' = get_knn_model,
               'rf' = get_rf_model,
               'dt' = get_decision_tree_model
               )


# 'logreg', 'adaboost'

# methods = list('xxx' = get_decision_tree_model)

# train selected models ####
model = train_models(methods = methods)

# plot trained models ####

data = get_partitioned_df(include_full = F)
plot_models(data, model)

model$glm$normal$y_prob

# confusion matrix and other stats ####
model$rf$spirals$confusion_matrix


