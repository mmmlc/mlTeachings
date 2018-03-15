get_gaussianProcess_model <- function(x_train,
                                      y_train,
                                      x_val = NULL,
                                      y_val = NULL){
  
  
  model = list()
  
  model$model$finalModel = kernlab::gausspr(x = x_train,
                                            y = y_train
  )
  
  if(!is.null(x_val) & !is.null(y_val)){
    
    model$y_class = model$model$finalModel %>% predict(newdata = x_val, type = 'response')
    model$y_prob = model$model$finalModel %>% predict(newdata = x_val, type = 'probabilities')
    model$confusionMatrix = confusionMatrix(model$y_class, y_val)
    model$y_class = model$y_class %>% as_data_frame()
  }
  
  model$model$method = 'gaussprLinear'
  
  return(model)
}


