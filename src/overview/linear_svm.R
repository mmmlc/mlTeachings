get_linearSvm_model <- function(x_train,
                                y_train,
                                x_test = NULL,
                                y_test = NULL){


  model = list()
  
  model$model = train(x = x_train,
                      y = y_train,
                      method = 'svmLinear',
                      trControl = trainControl(classProbs =  TRUE))
  
  if(!is.null(x_test) & !is.null(y_test)){
  
  model$y_class = model$model %>% predict(newdata = x_test, type = 'raw')
  model$y_prob = model$model %>% predict(newdata = x_test, type = 'prob')
  model$confusionMatrix = confusionMatrix(model$y_class, y_test)
  model$y_class = model$y_class %>% as_data_frame()
  }
  
  return(model)
}

# source('src/lib.R')
# source('src/overview/make_dataset.R')
# source('src/overview/plot_models.R')
# data = get_partitioned_df()
# 
# model = get_linearSvm_model(data$normal$x_train,
#                             data$normal$y_train$class,
#                             data$normal$x_test,
#                             data$normal$y_test$class)