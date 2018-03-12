train_models = function(methods,
                        data = get_partitioned_df()){
  
  # browser()
  
  model = list()
  types = data$full %>% dplyr::select(type) %>% unique %>% unlist %>% drop

  for(tp in types){
    
    for(method in methods){
      model[[method]][[tp]]$model = train(x = data[[tp]]$x_train,
                                          y = data[[tp]]$y_train$class,
                                          method = method,
                                          trControl = trainControl(classProbs =  TRUE))
      
      model[[method]][[tp]]$model$y_class = model[[method]][[tp]]$model %>% predict(newdata = data[[tp]]$x_val, type = 'raw')
      model[[method]][[tp]]$model$y_prob = model[[method]][[tp]]$model %>% predict(newdata = data[[tp]]$x_val, type = 'prob')
      
      model[[method]][[tp]]$confusion_matrix = confusionMatrix(model[[method]][[tp]]$model$y_class,
                                                               data[[tp]]$y_val$class %>% factor)
      
    }
  }
  
  return(model)
  
}
