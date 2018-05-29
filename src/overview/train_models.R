train_models = function(methods,
                        data = get_partitioned_df()){

  model = list()
  # df_types = data$full %>% dplyr::select(type) %>% unique %>% unlist %>% drop
  
  # browser()
  
  if(names(data)[1] == 'full'){df_types = names(data)[-1]} else {df_types = names(data)}
  
  
  
  for(type in df_types){
    
    for(method in names(methods)){
      
      model[[method]][[type]] = methods[[method]](data[[type]]$x_train,
                                                  data[[type]]$y_train$class %>% factor,
                                                  data[[type]]$x_test,
                                                  data[[type]]$y_test$class %>% factor)
      
    }
  }
  
  return(model)
  
}
