get_nnet_model <- function(x_train,
                                y_train,
                                x_test = NULL,
                                y_test = NULL){
  
  
  model = list()
  
  model$model = train(x = x_train,
                      y = y_train,
                      method = 'nnet',
                      maxit = 500,
                      trControl = trainControl(classProbs =  TRUE))

  if(!is.null(x_test) & !is.null(y_test)){

    model$y_class = model$model %>% predict(newdata = x_test, type = 'raw')
    model$y_prob = model$model %>% predict(newdata = x_test, type = 'prob')
    # model$confusionMatrix = confusionMatrix(model$y_class, y_test)
    model$y_class = model$y_class %>% as_data_frame()
  }
  
  return(model)
}
