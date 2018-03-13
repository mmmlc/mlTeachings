source('src/lib.R')

methods = list('linearSvm' = get_linearSvm_model,
               'radialSvm' = get_radialSvm_model,
               'qda' = get_qda_model,
               'knn' = get_knn_model
)

models = train_models(methods)

data = get_partitioned_df()


## deprecated

plot_models(models$knn$circles$model,
            data$circles$full_val)











# get_train_test_split <- function(df, p = 0.4) {
#   train_index <- createDataPartition(1:nrow(df), list = FALSE, p = p)
#   
#   list(
#     train_df = df[train_index,],
#     test_df = df[-train_index,]
#   )
#   
# }
# 
# full_df <- get_full_dataset()
# 
# #### @TODO add same logic for SVM
# #### @TODO add generic code to handle all the models and all the dataset in one facet wrap
# 
# df <- full_df %>% filter(type == "linear")
# split_list <- get_train_test_split(df)
# plot_models(get_knn_model(split_list$train_df), split_list$train_df)