plot_models = function(model,
                       df,
                       from = 0, to = 1,
                       by = 0.005,
                       breaks = 7,
                       title = NULL, ...){
  
  grid = expand.grid(x = seq(from, to, by),
                     y = seq(from, to, by)
  ) 
  
  gridProb = model$modelInfo$prob(modelFit = model$finalModel,
                                  newdata = grid)[,1]
  
  gridProb_b = gridProb %>% cut(breaks)
  
  grid = data_frame(x = grid$x, 
                    y = grid$y,
                    z = gridProb_b,
                    contour = gridProb)
  
  if(is.null(title)){title = paste(model$method, df$type %>% unique(), sep = ' | ')}
  
  ggplot() + ggtitle(title) +
    geom_raster(data = grid, aes(x = x, y = y, fill = z), interpolate = T) +
    scale_fill_brewer(palette="RdYlBu") +
    # geom_contour(data = grid, aes(x = x, y = y, z = contour),
    #              bins = (breaks -1),
    #              colour = 'gray',
    #              size = 1) +
    geom_point(data = df, aes(x = x, y = y),
               color = 'black',
               fill = ifelse(df$class == 'class_1', 'blue', 'red'),
               shape = 21) +
    theme_fivethirtyeight() + labs(x = "", y = "", fill = "") +
    theme(legend.position = "none")
  
  
}
