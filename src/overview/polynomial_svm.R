get_polySvm_model <- function(x_train,
                                y_train,
                                x_test = NULL,
                                y_test = NULL){
  
  
  model = list()

  degree = 3
  scale = 0.33
  cost = 3
  
  hyperparameters = data.frame('degree' = degree,
                               'scale' = scale,
                               'C' = cost)
  
  model$model = train(x = x_train,
                      y = y_train,
                      method = 'svmPoly',
                      tuneGrid = hyperparameters,
                      trControl = trainControl(classProbs =  TRUE))
  
  if(!is.null(x_test) & !is.null(y_test)){
    
    model$y_class = model$model %>% predict(newdata = x_test, type = 'raw')
    model$y_prob = model$model %>% predict(newdata = x_test, type = 'prob')
    model$confusionMatrix = confusionMatrix(model$y_class, y_test)
    model$y_class = model$y_class %>% as_data_frame()
  }
  
  return(model)
}
