source('src/lib.R')

plot_models = function(model, ...){}

#### rege...

grid = expand.grid(seq(from = -10, to = 10, by = 0.1), seq(from = -10, to = 10, by = 0.1))
toBePlot = svm %>% predict(grid, type = 'prob')

grid %>% ggplot(aes(x = Var1, y = Var2)) + geom_raster(aes(fill = toBePlot$A))+
  geom_contour(aes(z = toBePlot$A, colour = 'black')) +
  theme_minimal() + labs(x = "", y = "", fill = "") +
  theme(legend.position = "none")

res %>% ggplot(aes(x = x, y = y, fill = class), color = "black") + 
  geom_point(shape = 21) + theme_minimal() + labs(x = "", y = "", fill = "") +
  theme(legend.position = "none")
