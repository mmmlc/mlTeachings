source('src/lib.R')

n <- 1e3
dim <- 2

make_circles <- function(n, ratio = 0.3, sd = 0.1) {
  rad <- seq(0, 2 * pi, length.out = ceiling(n / 2))
  outer_circle <- matrix(c(cos(rad), sin(rad)),ncol = 2)
  inner_circle <- ratio * outer_circle[1:(n - nrow(outer_circle)), ]
  
  res <- rbind(
    outer_circle,
    inner_circle
  )
  assertthat::are_equal(nrow(res), n)
  
  if (sd != 0) {
    res <- res + matrix( rnorm(2 * nrow(res),sd = sd), ncol = 2)
  }
  
  return(
    list(
      x = res,
      classes = c(rep(1, nrow(outer_circle)), rep(2, nrow(inner_circle)))
    )
  )
}

prepare_dataset <- function(df, type = NULL) {
  range01 <- function(x){(x-min(x))/(max(x)-min(x))}
  res <- data_frame(
    x = df$x[, 1] %>% range01,
    y = df$x[, 2] %>% range01,
    class = str_c("class_", df$classes)
  )
  
  if(!is.null(type)) {
    res$type = type
  }
  
  return(res)
}

datasets <- list(
  "normal" = mlbench.2dnormals(n, sd = 0.3),
  "make_circles" = make_circles(n, 0.3, 0.1)
)

full_df <- lapply(
  names(datasets),
  function(x) {prepare_dataset(datasets[[x]], x)}
) %>% bind_rows


full_df %>% ggplot(aes(x = x, y = y, color = class)) +
  geom_point() + facet_wrap(~type) + scale_color_fivethirtyeight() + theme_fivethirtyeight() +
  labs(color = "") + theme(legend.position = "none")



