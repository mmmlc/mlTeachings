plot_models = function(model, res, from = -1.5, to = 1.5, by = 0.05, breaks = 7, ...){
  
  grid = expand.grid(x = seq(from, to, by),
                     y = seq(from, to, by)
  ) 
  
  gridProb = model$modelInfo$prob(modelFit = model$finalModel,
                                  newdata = grid)[,1]
  
  gridProb = gridProb %>% cut(breaks)
  
  grid = data_frame(x = grid$x, 
                    y = grid$y,
                    z = gridProb)
  

  ggplot() + ggtitle(model$method) +
    geom_raster(data = grid, aes(x = x, y = y, fill = z)) +
    scale_fill_brewer(palette="Spectral") +
    geom_point(data = res, aes(x = x, y = y, color = class),  shape = 16) + # to be fixed using shape 21!!!
    # scale_color_manual(values = c('black','black')) +
    scale_fill_brewer(palette="Spectral", direction = -1) +
    theme_minimal() + labs(x = "", y = "", fill = "") +
    theme(legend.position = "none") 
  
}

# plot_models(svm, res)

