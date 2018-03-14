##ci sto lavorando!

get_gaussianProcess_model <- function(x_train,
                                y_train,
                                x_val = NULL,
                                y_val = NULL){
  
  
  model = list()
  
  model$model = kernlab::gausspr(x = x_train,
                                 y = y_train
  )
  
  if(!is.null(x_val) & !is.null(y_val)){
    
    model$y_class = model$model %>% predict(newdata = x_val, type = 'response')
    model$y_prob = model$model %>% predict(newdata = x_val, type = 'probabilities')
    model$confusionMatrix = confusionMatrix(model$y_class, y_val)
    model$y_class = model$y_class %>% as_data_frame()
  }
  
  return(model)
}

# train(x = x_train,
#       y = y_train,
#       method = 'gaussprLinear',
#       trControl = trainControl(classProbs =  TRUE))
# 
# gaussProcess = kernlab::gausspr(x = data$normal$x_train,
#                                 y = data$normal$y_train$class)
# gaussProcess %>% predict(data$normal$x_val, type = 'response')
gaussProcess %>% predict(data$normal$x_val, type = 'probabilities') %>% class
