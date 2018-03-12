source("src/overview/make_dataset.R")
source("src/overview/plot_models.R")
source("src/overview/knn.R")

get_train_test_split <- function(df, p = 0.4) {
  train_index <- createDataPartition(1:nrow(df), list = FALSE, p = p)
  
  list(
    train_df = df[train_index,],
    test_df = df[-train_index,]
  )
  
}

full_df <- get_full_dataset()

#### @TODO add same logic for SVM
#### @TODO add generic code to handle all the models and all the dataset in one facet wrap

df <- full_df %>% filter(type == "linear")
split_list <- get_train_test_split(df)
plot_models(get_knn_model(split_list$train_df), split_list$train_df)