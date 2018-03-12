source('src/lib.R')

get_knn_model <- function(train_df) {
  knn <- train(train_df %>% select(x,y), 
               train_df %>% pull(class), 
               method = "knn", 
               tuneGrid = expand.grid(k = 3),
               trControl = trainControl(classProbs =  TRUE, method = "none"))
  knn
}