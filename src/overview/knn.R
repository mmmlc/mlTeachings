# source('src/lib.R')
# 
# get_knn_model <- function(train_df) {
#   knn <- train(train_df %>% select(x,y), 
#                train_df %>% pull(class), 
#                method = "knn", 
#                tuneGrid = expand.grid(k = 3),
#                trControl = trainControl(classProbs =  TRUE, method = "none"))
#   knn
# }

### fabio ti metto qua un esempio base di come ho strutturato la funzione, soratutto in termini di I/O.
# ne abbiamo parlato con luxca la cosa che ci sembrava piu opportuna era di creare una funzione riuilizzabile, che quindi
# prendesse in input non la listona, bensi quattro parametri. poi la parametrizzazione viene gestita a piu
# alto livello

get_knn_model <- function(x_train,
                          y_train,
                          x_val = NULL,
                          y_val = NULL){
  
  
  model = list()
  
  model$model = train(x = x_train,
                      y = y_train,
                      method = 'knn',
                      trControl = trainControl(classProbs =  TRUE))
  
  if(!is.null(x_val) & !is.null(y_val)){
    
    model$y_class = model$model %>% predict(newdata = x_val, type = 'raw')
    model$y_prob = model$model %>% predict(newdata = x_val, type = 'prob')
    model$confusionMatrix = confusionMatrix(model$y_class, y_val)
    model$y_class = model$y_class %>% as_data_frame()
  }
  
  return(model)
}

source('src/lib.R')
source('src/overview/make_dataset.R')
source('src/overview/plot_models.R')
data = get_partitioned_df()

model = get_knn_model(data$normal$x_train,
                      data$normal$y_train$class,
                      data$normal$x_val,
                      data$normal$y_val$class)