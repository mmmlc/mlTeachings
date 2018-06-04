titanic_data_processing = function(df){
  df %>%
    select(survived, # select features
           pclass,
           sex,
           age,
           sibsp,
           parch,
           fare,
           cabin,
           embarked
    ) %>% 
    mutate_if(is.character, fct_explicit_na) %>% # assign levels to missings
    mutate_all(as.numeric) %>% mutate_all(funs(replace(., is.na(.), 0))) # %>% # set missings to 0
    # mutate_all(scale) # normalize data
}

get_titanic_df <- function(filter = F) {
    # import the data
    titanic_df = read_csv('data/titanic.csv', col_types = cols())
    
    set.seed(123) # set seed for reproducibility of createDataPartition

    partition = titanic_df %>% nrow %>% seq_len %>% createDataPartition(times = 1, p = 0.7, list = F)

    train = titanic_df %>% slice(partition) %>% titanic_data_processing
    test = titanic_df %>% slice(-partition) %>% titanic_data_processing

    if(filter){
    train = train %>% filter(sex == 2, age > 18, age < 40)
    test = test %>% filter(sex == 2, age > 18, age < 40)
    }
    
    list(
        x_train = train %>% select(-one_of('survived')),
        y_train = train %>% mutate(class = factor(ifelse(survived == 1, "Yes", "Not"))) %>% select(class),
        x_test = test %>% select(-one_of('survived')),
        y_test = test %>% mutate(class = factor(ifelse(survived == 1, "Yes", "Not"))) %>% select(class)
    )
}


