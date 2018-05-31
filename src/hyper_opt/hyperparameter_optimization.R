options(warn=-1)
working_dir <- 'E:/dataScienceProjects/mlTeachings' ## If runing locally, replace with the path to the folder in which you saved the notebooks (e.g. 'C:/Documents/mlTeachings') 
setwd(working_dir)

source('src/lib.R')

train = read_csv('data/titanic_train.csv')
test = read_csv('data/titanic_test.csv')

info = getModelInfo('kknn')
info$kknn$parameters

info$kknn$library

info$kknn$parameters

model = train(x = train %>% select(-one_of('survived')),
              y = train %>% select(one_of('survived')) %>% pull %>% factor,
              method = 'kknn',
              trControl = trainControl(search = 'grid', method = 'none'),
              tuneGrid = data.frame(kmax = 20,
                                    kernel = c("triangular"),
                                    distance = 0.5)
)

tune_grid = data.frame(kmax = 5,
                       kernel = c('rectangular' %>% rep(5),
                                  'triangular' %>% rep(5)
                       ),
                       distance = c(0.1,
                                    0.5,
                                    1,
                                    2,
                                    10
                       )
)

model = train(x = train %>% select(-one_of('survived')),
              y = train %>% select(one_of('survived')) %>% pull %>% factor,
              method = 'kknn'
)

model = train(x = train %>% select(-one_of('survived')),
              y = train %>% select(one_of('survived')) %>% pull %>% factor,
              method = 'kknn',
              tuneGrid = tune_grid
)

model_grid_search$bestTune

model_grid_search$results$Accuracy %>% plot(type = 'l')
model_grid_search$results$Kappa %>% plot(type = 'l')

library(tidyverse)


model_grid_search$results %>%
  as_data_frame %>%
  rownames_to_column(var = 'id') %>% mutate(id = as.numeric(id)) %>% 
  ggplot() + geom_line(aes(x = id, y = Accuracy)) + ggtitle('Training Accuracy')

model_grid_search$results %>%
  as_data_frame %>%
  rownames_to_column(var = 'id') %>% mutate(id = as.numeric(id)) %>% 
  ggplot() + geom_line(aes(x = id, y = Kappa)) + ggtitle('Training Kohen\'s K')

model_grid_search$results %>% as_data_frame %>% top_n(1, Accuracy)
model_grid_search$results %>% as_data_frame %>% top_n(1, Kappa)

# saveRDS(model_grid_search, 'data/model_grid_search.R')

model_grid_search = readRDS('data/model_grid_search.R')

gtools::combinations(20, kernel, distance)

train(x, y, method = "rf", preProcess = NULL, ...,
      weights = NULL, metric = ifelse(is.factor(y), "Accuracy", "RMSE"),
      maximize = ifelse(metric %in% c("RMSE", "logLoss", "MAE"), FALSE, TRUE),
      trControl = trainControl(), tuneGrid = NULL,
      tuneLength = ifelse(trControl$method == "none", 1, 3))

kknn %>% methods

library('kknn')

kknn::kknn()


#####

((tune_grid_large = expand.grid(kmax = 5, 
                                kernel = c('rectangular',
                                           'triangular',
                                           'epanechnikov',
                                           'biweight',
                                           'triweight',
                                           'cos',
                                           'inv',
                                           'gaussian',
                                           'rank',
                                           'optimal'),
                                distance = c(0.1, 0.5, 1, 2, 10)
)
)
) %>% nrow %>% paste('This tune grid has ', ., ' rows!')

(long_tune_grid = data.frame(kmax = seq_len(20) %>% rep(each = 50),
                        kernel = c('rectangular' %>% rep(5),
                                   'triangular' %>% rep(5),
                                   'epanechnikov' %>% rep(5),
                                   'biweight' %>% rep(5),
                                   'triweight' %>% rep(5),
                                   'cos' %>% rep(5),
                                   'inv' %>% rep(5),
                                   'gaussian' %>% rep(5),
                                   'rank' %>% rep(5),
                                   'optimal' %>% rep(5)                                  
                        ),
                        distance = c(0.1,
                                     0.5,
                                     1,
                                     2,
                                     10
                        )
)) %>% nrow

(random_tune_grid = long_tune_grid %>% sample_frac(size = 0.05)) %>% nrow

model = train(x = train %>% select(-one_of('survived')),
              y = train %>% select(one_of('survived')) %>% pull %>% factor,
              method = 'kknn',
              tuneGrid = tune_grid_large,
              tuneLenght = 12,
              trControl = trainControl(search = 'random', verboseIter = T)
)

# model = train(x = train %>% select(-one_of('survived')),
#               y = train %>% select(one_of('survived')) %>% pull %>% factor,
#               method = 'kknn',
#               tuneGrid = random_tune_grid
# )

# model_random_search = model

model_random_search$bestTune

model_random_search$results %>% as_data_frame %>% top_n(1, Accuracy)
model_random_search$results %>% as_data_frame %>% top_n(1, Kappa)

# saveRDS(model_random_search, 'data/model_random_search.R')
model_random_search = readRDS('data/model_random_search.R')

test_response_probabilities = model %>%
  predict(newdata = test %>% select(-one_of('survived')), type = 'prob') %>% pull('1')

test_response = model %>%
  predict(newdata = test %>% select(-one_of('survived'))) %>% factor

confusionMatrix(test_response, test$survived %>% factor)

roc(test_response_probabilities, test$survived %>% factor) %>% auc %>% round(4) %>% list('AUC' = .) %>% unlist

2*0.8137-1
2*0.8355-1

install.packages('rBayesianOptimization')
library(rBayesianOptimization)

rBayesianOptimization::BayesianOptimization()

willBeOptimized = function(KMAX, KERNEL, DIST){
  
  partition = train %>% nrow %>% seq_len %>% createDataPartition(p = 0.5, list= FALSE)
  
  train_train = train %>% slice(partition)
  
  val = train %>% slice(-partition)
  
  kernel = c('rectangular',
             'triangular',
             'epanechnikov',
             'biweight',
             'triweight',
             'cos',
             'inv',
             'gaussian',
             'rank',
             'optimal'                                  
  )
  
  kernel = kernel[KERNEL]
  
  model = train(x = train_train %>% select(-one_of('survived')),
                y = train_train %>% select(one_of('survived')) %>% pull %>% factor,
                method = 'kknn',
                trControl = trainControl(search = 'grid', method = 'none'),
                tuneGrid = data.frame(kmax = KMAX,
                                      kernel = kernel,
                                      distance = DIST)
  )
  
  
  test_response = model %>%
    predict(newdata = val %>% select(-one_of('survived'))) %>% factor
  
  acc = confusionMatrix(val %>% select(one_of('survived')) %>% pull %>% factor,
                        test_response)

  test_response_probabilities = model %>%
    predict(newdata = val %>% select(-one_of('survived')),  type = 'prob') %>% pull('1')
  
  roc = roc(test_response_probabilities, val$survived %>% factor) %>% auc
  
  return(list('Score' = roc,#acc$overall[1],
              'Pred' = test_response))  
}


xx = BayesianOptimization(willBeOptimized,
                          bounds = list(KMAX = c(1L, 20L),
                                        KERNEL = c(1L, 10L),
                                        DIST = c(0.1, 10)),
                          init_points = 20,
                          n_iter = 40,
                          acq = 'ei')

xx$Best_Par
xx$Best_Value

xx$History %>% class

xx$History %>% ggplot() +
  geom_line(aes(x = DIST, y = Value), color = 'red')

xx$History %>% ggplot() +
  geom_line(aes(x = KMAX, y = Value), color = 'blue')

xx$History %>% ggplot() +
  geom_line(aes(x = KERNEL, y = Value), color = 'blue')

xx$History %>% as_data_frame %>% ggplot(aes(x = KMAX, y = DIST)) +
  stat_density_2d() + geom_point(aes(size = Round, colour = -Value)) #+
  geom_path(aes(colour = as.numeric(-Round)))

xx$History %>% summary

model = train(x = train_train %>% select(-one_of('survived')),
              y = train_train %>% select(one_of('survived')) %>% pull %>% factor,
              method = 'kknn',
              trControl = trainControl(search = 'grid', method = 'none'),
              tuneGrid = data.frame(kmax = xx$Best_Par[1],
                                    kernel = c("triangular"),
                                    distance = xx$Best_Par[2])
)

test_response_probabilities = model %>%
  predict(newdata = test %>% select(-one_of('survived')), type = 'prob') %>% pull('1')

test_response = model %>%
  predict(newdata = test %>% select(-one_of('survived'))) %>% factor

confusionMatrix(test_response, test$survived %>% factor)

roc(test_response_probabilities, test$survived %>% factor) %>% auc %>% round(4) %>% list('AUC' = .) %>% unlist
