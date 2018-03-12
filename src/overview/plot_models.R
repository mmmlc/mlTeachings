plot_models = function(model, res, from = 0, to = 1, by = 0.005, breaks = 7, ...){
  
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
  

  ggplot() + ggtitle(model$method) +
    geom_contour(data = grid, aes(x = x, y = y, z = contour)) +
    geom_raster(data = grid, aes(x = x, y = y, fill = z)) +
    scale_fill_brewer(palette="Spectral") +
    geom_point(data = res, aes(x = x, y = y),
               color = 'black',
               fill = ifelse(res$class == 'class_1', 'blue', 'red'),
               shape = 21) +
    # scale_color_manual(values = c('black','black')) +
    theme_minimal() + labs(x = "", y = "", fill = "") +
    theme(legend.position = "none") 
  
}

plot_models(svm, res)

