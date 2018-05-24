source('src/lib.R')

df = read_csv('data/titanic.csv')

df %>% glimpse

df %>% filter(sex == 'male', age > 18, age < 40) %>% 
  select(survived) %>% mutate(survived = ifelse(survived == 1, 'oh yes', 'nope sorry')) %>% 
  ggplot(aes(survived, fill = survived)) + geom_bar() + ggtitle('Survived?') + theme(legend.position = "none")

partition = df %>% nrow %>% seq_len %>% createDataPartition(times = 1, p = 0.7, list = F)

train_raw = df %>% slice(partition)
test_raw = df %>% slice(-partition)

train_raw %>% glimpse

train_raw %>% dim
test_raw %>% dim

# data_processing = function(df){
#   df %>%
#     select(survived,
#            pclass,
#            sex,
#            age,
#            sibsp,
#            parch,
#            fare,
#            # cabin,
#            embarked
#     ) %>% 
#     mutate_if(is.character, fct_explicit_na) %>% 
#     mutate_if(is.numeric, funs(replace(., is.na(.), 0))) 
# }

data_processing = function(df){
  df %>% filter(sex == 'male', age > 18, age < 40) %>% 
    select(survived,
           pclass,
           # sex,
           age,
           sibsp,
           parch,
           fare,
           cabin,
           embarked
    ) %>% 
    mutate_if(is.character, fct_explicit_na) %>% 
    mutate_all(as.numeric) %>% mutate_all(funs(replace(., is.na(.), 0))) %>% 
    mutate_all(scale)
}

train = data_processing(train_raw)
test = data_processing(test_raw)

train %>% glimpse
test %>% glimpse

train %>% dim
test %>% dim


model_naive = train(x = train %>% select(-one_of('survived')),
                    y = train %>% select(one_of('survived')) %>% pull %>% factor,
                    method = 'kknn'
              )

model = train(x = train %>% select(-one_of('survived')),
              y = train %>% select(one_of('survived')) %>% pull %>% factor,
              method = 'kknn',
              tuneGrid = data.frame(kmax = 20,
                                    kernel = c("triangular"),
                                    distance = 0.5)
)

model$finalModel$best.parameters

info = getModelInfo(model = 'kknn')


# model_rf = model
# model_svm
# model_knn
# model_logistic
# model_nnet
# model_dt

test_naive_response = model_naive %>%
  predict(newdata = test %>% select(-one_of('survived'))) %>% factor(labels = 0:1)

train_naive_response = model_naive %>%
  predict(newdata = train %>% select(-one_of('survived'))) %>% factor(labels = 0:1)

test_response = model %>%
  predict(newdata = test %>% select(-one_of('survived'))) %>% factor(labels = 0:1)

train_response = model %>%
  predict(newdata = train %>% select(-one_of('survived'))) %>% factor(labels = 0:1)


## interesting examples of overfitting

Metrics::auc(test_naive_response, test$survived %>% factor(labels = 0:1))
confusionMatrix(test_naive_response, test$survived %>% factor(labels = 0:1))
Metrics::auc(train_naive_response, train$survived %>% factor(labels = 0:1))
confusionMatrix(train_naive_response, train$survived %>% factor(labels = 0:1))

Metrics::auc(test_response, test$survived %>% factor(labels = 0:1))
confusionMatrix(test_response, test$survived %>% factor(labels = 0:1))
Metrics::auc(train_response, train$survived %>% factor(labels = 0:1))
confusionMatrix(train_response, train$survived %>% factor(labels = 0:1))

###

info = getModelInfo(model = 'svmPoly')

info$svmPoly$parameters

tuningGrid = data.frame(degree = 10, scale = 1, C = 1)

model = train(x = train %>% select(-one_of('survived')),
              y = train %>% select(one_of('survived')) %>% pull %>% factor,
              method = 'svmPoly',
              tuneGrid = tuningGrid
)

test_response = model %>%
  predict(newdata = test %>% select(-one_of('survived'))) %>% factor

xx = test_raw %>% bind_cols(data_frame('guess_survived' = test_response)) %>%
  filter(sex == 'male') %>% select(name, sex, age, guess_survived, survived)

xx %>% dim

xx$guess_survived
xx$survived

xx = confusionMatrix(xx$guess_survived, xx$survived %>% factor)
xx$overall[1]

## others

model_dt = train(x = train %>% select(-one_of('survived')),
                 y = train %>% select(one_of('survived')) %>% pull %>% factor,
                 method = 'rpart2',
                 tuneGrid = data.frame(maxdepth = 10)
)

info = getModelInfo('rpart')
info$rpart2$parameters

test_dt_response = model_dt %>% predict(newdata = test %>% select(-one_of('survived'))) %>% factor
train_dt_response = model_dt %>% predict(newdata = train %>% select(-one_of('survived'))) %>% factor

Metrics::auc(test_dt_response, test$survived %>% factor)
Metrics::auc(train_dt_response, train$survived %>% factor)

# fairly interesting breakdown of the condition for survinig to the titanic

fancyRPartPlot(model_dt$finalModel)
plot(model_dt$finalModel, type = "simple")

###