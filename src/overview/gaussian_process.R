get_gaussianProcess_model <- function(x_train,
                                      y_train,
                                      x_test = NULL,
                                      y_test = NULL){
  
  
  model = list()
  
  model$model$finalModel = kernlab::gausspr(x = x_train,
                                            y = y_train
  )
  
  if(!is.null(x_test) & !is.null(y_test)){
    
    model$y_class = model$model$finalModel %>% predict(newdata = x_test, type = 'response')
    model$y_prob = model$model$finalModel %>% predict(newdata = x_test, type = 'probabilities')
    model$confusionMatrix = confusionMatrix(model$y_class, y_test)
    model$y_class = model$y_class %>% as_data_frame()
  }
  
  model$model$method = 'gaussprLinear'
  
  return(model)
}


