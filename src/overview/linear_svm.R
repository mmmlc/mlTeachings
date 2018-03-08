source('src/lib.R')
source('src/overview/make_dataset.R')
source('src/overview/plot_models.R')

levels(res$class) = c("A","B")

partition = res %>% nrow %>% seq_len %>% createDataPartition(times = 1, p = 0.8, list = F)

x_train = res %>% select(x,y) %>% slice(partition)
y_train = res %>% select(class) %>% slice(partition)


x_val = res %>% select(x,y) %>% slice(-partition)
y_val = res %>% select(class) %>% slice(-partition)

svm = train(x = x_train, y = y_train$class,
            method = 'svmLinear',
            trControl = trainControl(classProbs =  TRUE))

y_pred = svm %>% predict(newdata = x_val, type = 'raw')


confusionMatrix(y_pred, y_val$class)

plot_models(svm, res)

