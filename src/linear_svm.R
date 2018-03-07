source('src/make_dataset.R')
require('caret')

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


#### to be continued...

grid = expand.grid(seq(from = -10, to = 10, by = 0.1), seq(from = -10, to = 10, by = 0.1))
toBePlot = svm %>% predict(grid, type = 'prob')

grid %>% ggplot(aes(x = Var1, y = Var2)) + geom_raster(aes(fill = toBePlot$A))+
  geom_contour(aes(z = toBePlot$A, colour = 'black')) +
  theme_minimal() + labs(x = "", y = "", fill = "") +
  theme(legend.position = "none")

res %>% ggplot(aes(x = x, y = y, fill = class), color = "black") + 
  geom_point(shape = 21) + theme_minimal() + labs(x = "", y = "", fill = "") +
  theme(legend.position = "none")

