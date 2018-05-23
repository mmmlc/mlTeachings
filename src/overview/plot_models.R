plot_models <- function(data, model){
  
  # browser()
  
  ## Prepare plot dataset
  data_df <- lapply(
    names(data),
    function(data_name) {
      df <- data[[data_name]] 
      rbind(
        df$full_train %>% mutate(partition = "train"),
        df$full_val %>% mutate(partition = "val")
      )
    }
  ) %>% bind_rows
  
  ## expand data_df for each model
  model_df <- data_frame(
    model = names(model),
    tmp = 1
  )
  
  data_df <- data_df %>% mutate(tmp = 1) %>% left_join(model_df) %>% select(-tmp)
  
  ### prepare prediction
  from <- 0
  to <- 1
  n <- 100
  grid_df <- expand.grid(
    x = seq(from, to, length.out = n),
    y = seq(from, to, length.out = n),
    type = data_df$type %>% unique,
    model = data_df$model %>% unique
  )
  
  grid_df$prob <- 0
  for(model_name in names(model)) {    
    for(data_name in names(data)) {      
      new_data_df <- grid_df[grid_df$model == model_name & grid_df$type == data_name,] %>% select(x,y)
      predict_type <- "probabilities"
      if(model[[model_name]][[data_name]]$model$method %in% c("kknn", "rf", "rpart")) {
        predict_type <- "prob"
      }
      if(model[[model_name]][[data_name]]$model$method %in% c('glm')) {
        predict_type <- "response"
      }
      if(model[[model_name]][[data_name]]$model$method %in% c('nnet')) {
        predict_type <- "raw"
      }
      prob <- predict(model[[model_name]][[data_name]]$model$finalModel, newdata = new_data_df, type = predict_type)
      if(is.numeric(prob)){
        if(model[[model_name]][[data_name]]$model$method %in% c('glm', 'nnet')){prob = 1 - prob}else{prob}
      } else if(is.matrix(prob)) {
        prob <- prob[,1]
      } else {
        prob <- prob$posterior[,1]
      }
      grid_df[grid_df$model == model_name & grid_df$type == data_name,]$prob <- prob
    }
  }
  
  ## set ordering on models & data
  grid_df$model <- factor(grid_df$model, levels = names(model))
  data_df$model <- factor(data_df$model, levels = names(model))
  grid_df$type <- factor(grid_df$type, levels = names(data))
  data_df$type <- factor(data_df$type, levels = names(data))
  
  ## plot data
  ggplot() + 
    geom_raster(data = grid_df, aes(x = x, y = y, fill = prob), interpolate = T, alpha = 0.7) +
    scale_fill_gradient2(low = "blue", mid = "white",
                         high = "red", midpoint = 0.5, space = "rgb",
                         na.value = "grey50", guide = "colourbar") +
    geom_point(data = data_df, aes(x = x, y = y, fill = 1- (as.numeric(factor(class)) - 1), alpha = partition), shape = 21) + 
    scale_alpha_manual(values = c("train" = 0.6, "test" = 1)) +
    facet_grid(type ~ model) + 
    theme(legend.position = "none", panel.grid.minor = element_blank(),
          panel.background = element_blank(), axis.line = element_blank(),
          axis.title=element_blank(),
          axis.text=element_blank(),
          axis.ticks=element_blank()) + 
    labs(x = "", y = "")
}


plot_model = function(df, data_name, model){
## prepare prediction

from <- 0
to <- 1
n <- 100
grid_df <- expand.grid(
  x = seq(from, to, length.out = n),
  y = seq(from, to, length.out = n)
)

grid_df$prob = model %>% predict(grid_df %>% select(x,y), type = 'prob') %>% select(prob = class_1)

## Prepare plot dataset

data_df <- lapply(
  data_name,
  function(data_name) {
    df <- df[[data_name]] 
    rbind(
      df$full_train %>% mutate(partition = "train"),
      df$full_val %>% mutate(partition = "val")
    )
  }
) %>% bind_rows

## plot data
ggplot() + 
  geom_raster(data = grid_df, aes(x = x, y = y, fill = prob), interpolate = T, alpha = 0.7) +
  scale_fill_gradient2(low = "blue", mid = "white",
                       high = "red", midpoint = 0.5, space = "rgb",
                       na.value = "grey50", guide = "colourbar") +
  geom_point(data = data_df, aes(x = x, y = y, fill = 1- (as.numeric(factor(class)) - 1), alpha = partition), shape = 21) +
  scale_alpha_manual(values = c("train" = 0.6, "test" = 1)) +
  theme_void() + ggtitle(model$method %>% toupper) +
  theme(legend.position = "none")

}
