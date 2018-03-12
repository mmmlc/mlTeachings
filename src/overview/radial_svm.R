source('src/lib.R')
source('src/overview/make_dataset.R')
source('src/overview/plot_models.R')

res <- get_full_dataset() %>% filter(type == "circles")

partition = res %>% nrow %>% seq_len %>% createDataPartition(times = 1, p = 0.8, list = F)

data = get_partitioned_df()

model = list()

assign(method, method)
tp = 'circles'
methods = c('svmRadial', 'svmLinear', 'qda')



model = list()
types = get_full_dataset() %>% select(type) %>% unique %>% unlist

for(tp in types){
  for(method in methods){
    model[[method]][[tp]]$model = train(x = data[[tp]]$x_train,
                                  y = data[[tp]]$y_train$class,
                                  method = method,
                                  trControl = trainControl(classProbs =  TRUE))
    
    model[[method]][[tp]]$model$y_class = svm %>% predict(newdata = data[[tp]]$x_val, type = 'raw')
    model[[method]][[tp]]$model$y_prob = svm %>% predict(newdata = data[[tp]]$x_val, type = 'prob')
    
    model[[method]][[tp]]$confusion_matrix = confusionMatrix(model[[method]][[tp]]$model$y_class,
                                                       data[[tp]]$y_val$class %>% factor)
    
  }
}

model$svmRadial$linear$confusion_matrix
model$svmRadial$confusion_matrix

model[[method]]$model = train(x = data[[tp]]$x_train,
                              y = data[[tp]]$y_train$class,
                              method = method,
                              trControl = trainControl(classProbs =  TRUE))

model[[method]]$model$y_class = svm %>% predict(newdata = data[[tp]]$x_val, type = 'raw')
model[[method]]$model$y_prob = svm %>% predict(newdata = data[[tp]]$x_val, type = 'prob')

model[[method]]$confusion_matrix = confusionMatrix(model[[method]]$model$y_class,
                                                   data[[tp]]$y_val$class)

model$svmRadial$linear$confusion_matrix

plot_models(model$svmLinear$linear$model, data$linear$full)

model$svmRadial$linear

data$normal$y_val$class %>% class
res$class %>% class
