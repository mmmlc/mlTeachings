source('src/lib.R')

train = read_csv('data/titanic_train.csv', col_types = cols())
test = read_csv('data/titanic_test.csv', col_types = cols())

model <- readRDS('data/titanic_model.R')

test_response_df = model %>%
  predict(newdata = test %>% select(-one_of('survived')) %>% filter(sex == 2, age > 18, age < 40),
          type = 'raw')  %>%
  data_frame('Response' = .) %>%
  mutate(Response = as.numeric(Response) -1,  Response = ifelse(Response > 0.1, 1 , 0) )


#%>% ifelse(. >= 0.1, 1, 0) %>% data_frame('Response' = .)

test_response_df %>% head

test_response_probabilities_df = model %>%
  predict(newdata = test %>% select(-one_of('survived')) %>% filter(sex == 2, age > 18, age < 40),
          type = 'prob') %>% pull('1') %>% data_frame('Probabilities' = .)

df = data_frame()
df_tmp = data_frame()

for(threshold in seq(min(test_response_probabilities_df$Probabilities),
                     max(test_response_probabilities_df$Probabilities),
                     by = 0.01)){
  
  
  test_response_df = test_response_probabilities_df %>%
    mutate(Response = if_else(Probabilities > threshold, 1, 0) %>% factor(., levels = 0:1))
  
  df_tmp = bind_cols(test_response_df %>% mutate(Response = factor(Response, levels = 0:1)),
                     test %>% filter(sex == 2, age > 18, age < 40) %>% select(survived) %>% mutate(survived = as.factor(survived))) %>% 
    mutate(Threshold = threshold,
           Accuracy = confusionMatrix(Response, survived)[['overall']]['Accuracy'],
           Sensitivity = confusionMatrix(Response, survived)[['byClass']]['Sensitivity'],
           Specificity = confusionMatrix(Response, survived)[['byClass']]['Specificity'],
           Precision = confusionMatrix(Response, survived)[['byClass']]['Precision'],
           Recall = confusionMatrix(Response, survived)[['byClass']]['Recall'],
           Balanced = confusionMatrix(Response, survived)[['byClass']]['Balanced Accuracy'],
           ROC = roc(Response, survived) %>% auc)
  
  df = bind_rows(df, df_tmp)
  
  
}


df = df %>% mutate(Response = as.numeric(Response)-1)

p = ggplot(df) +
  geom_line(aes(x = Probabilities, y = Accuracy, frame = Threshold), color = 'red') +
  geom_line(aes(x = Probabilities, y = Balanced, frame = Threshold), color = 'green') +
  geom_line(aes(x = Probabilities, y = Sensitivity, frame = Threshold), color = 'orange') +
  geom_line(aes(x = Probabilities, y = Specificity, frame = Threshold), color = 'blue') +
  scale_color_manual(values = c("red", "green")) +
  theme_minimal() + ggtitle('Response Plot') +
  geom_point(aes(x = Probabilities, y = as.numeric(Response)-1, color = survived, frame = Threshold)) +
  theme(legend.position="none")
  # scale_fill_continuous(breaks = 0:1)
  # scale_fill_discrete(breaks = Response, labels = c('a','b'))

plotly::ggplotly(p)

df %>% filter(Roc == max(Roc)) %>% select(Threshold) %>% unique 
df %>% filter(Accuracy == max(Accuracy)) %>% select(Threshold) %>% unique 



threshold = 0.5
AUC::roc(df_tmp$Response, df_tmp$survived) %>% auc

acc = confusionMatrix(df_tmp$Response, df_tmp$survived)
acc$byClass

#### TO BE FIXED


test_response_df = model %>%
  predict(newdata = test %>% select(-one_of('survived')),
         type = 'raw')  %>%
  data_frame('Response' = .) %>% mutate(Response = as.numeric(Response) -1),  Response = ifelse(Response > 0.1, 1 , 0) )

#%>% ifelse(. >= 0.1, 1, 0) %>% data_frame('Response' = .)
                                                                 
test_response_df %>% head

test_response_probabilities_df = model %>%
  predict(newdata = test %>% select(-one_of('survived')),
         type = 'prob') %>% pull('1') %>% data_frame('Probabilities' = .)
         
df = bind_cols(test_response_df %>% as.factor,
               test_response_probabilities_df,
               test %>% select(survived) %>% mutate(survived = as.factor(survived)))

options(repr.plot.width=6, repr.plot.height=3)

ggplot(df, aes(x = Probabilities, y = Response, color = survived)) +
        geom_point() +
        scale_color_manual(values = c("red", "green")) +
        theme_minimal() + ggtitle('Response Plot')

# + geom_vline(xintercept=0.5, linetype="dashed", color = 'blue')
