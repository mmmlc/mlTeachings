get_qda_model <- function(x_train,
                                y_train,
                                x_val = NULL,
                                y_val = NULL){
  
  
  model = list()
  
  model$model = train(x = x_train,
                      y = y_train,
                      method = 'qda',
                      trControl = trainControl(classProbs =  TRUE))
  
  if(!is.null(x_val) & !is.null(y_val)){
    
    model$y_class = model$model %>% predict(newdata = x_val, type = 'raw')
    model$y_prob = model$model %>% predict(newdata = x_val, type = 'prob')
    model$confusionMatrix = confusionMatrix(model$y_class, y_val)
    model$y_class = model$y_class %>% as_data_frame()
  }
  
  return(model)
}
