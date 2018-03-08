source('lib/lib.R')

n <- 1e3
dim <- 2
df <- mlbench::mlbench.circle(n, dim)
df <- mlbench.spirals(300,1.5,0.05)

res <- data_frame(
  x = df$x[,1],
  y = df$x[,2],
  class = df$classes
)

res %>% ggplot(aes(x = x, y = y, fill = class), color = "black") + 
  geom_point(shape = 21) + theme_minimal() + labs(x = "", y = "", fill = "") +
  theme(legend.position = "none")
