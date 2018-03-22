source('src/lib.R')

df = get_partitioned_df()

info = getModelInfo()
info %>% names %>% head
info %>% names %>% length

data_name = 'spirals'


get_full_dataset() %>% filter(type == data_name) %>% ggplot(aes(x = x, y = y, color = class)) +
  scale_fill_discrete() + geom_point(size = 2) + theme_bw() + ggtitle(data_name %>% toupper)

algorithm = 'rpart2'

info[[algorithm]]$parameters

maxdepth = 1:10

hyperparameters = data.frame('maxdepth' = maxdepth)

model = train(y = df$spirals$y_train$class,
           x = df$spirals$x_train,
           method = algorithm,
           tuneGrid = hyperparameters,
           trControl = trainControl(method = 'boot')
           )

plot(model)

# library(rpart.plot)
library(rattle)
rattle::fancyRpartPlot(model$finalModel, palettes = c('Reds', 'Blues'), sub = "")


plot(model$finalModel, uniform=TRUE,margin=0.2)
text(model$finalModel, use.n=TRUE, all=TRUE, cex=0.8)


  ### prepare prediction

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
    theme_bw() + ggtitle(model$method %>% toupper) +
    theme(legend.position = "none")
  
######## rforest
  

  algorithm = 'rf'
  
  info[[algorithm]]$parameters
  
  mtry = 1:10
  
  hyperparameters = data.frame('mtry' = mtry)
  
  model = train(y = df$spirals$y_train$class,
                x = df$spirals$x_train,
                method = algorithm,
                tuneGrid = hyperparameters,
                trControl = trainControl(method = 'boot')
  )
  
  model$method
  
  model$bestTune
  
  model$control$method
  
  model$results
  
  plot(model$finalModel)
  fancyRpartPlot(model$finalModel, palettes = c('Reds', 'Blues'), sub = "")
  
  plot(model$finalModel, uniform=TRUE,margin=0.2)
  text(model$finalModel, use.n=TRUE, all=TRUE, cex=0.8)
  
  
  ### prepare prediction
  
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
    theme_bw() + ggtitle(model$method %>% toupper) +
    theme(legend.position = "none")
  
  

  