# source('src/lib.R')

n <- 1e2
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

make_linear_separable <- function(n, a = -1, b = 1) {
  x <- matrix(
    c(runif(n,0,1), runif(n,0,1)),
    ncol = 2
  )
  classes <- ifelse(
    a * x[,1] + b < x[,2],
    1,
    2
  )
  
  return(
    list(
      x = x,
      classes = classes
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


get_full_dataset <- function() {
  datasets <- list(
    "normal" = mlbench.2dnormals(n, sd = 0.3),
    "circles" = make_circles(n, 0.3, 0.1),
    "spirals" = mlbench.spirals(n, 0.9, 0.1),
    "linear"  = make_linear_separable(n)
  )
  
  full_df <- lapply(
    names(datasets),
    function(x) {prepare_dataset(datasets[[x]], x)}
  ) %>% bind_rows

  return(full_df)
}

get_partitioned_df = function(get_dataset = get_full_dataset(),
                              validationSplit = 0.8,
                              include_full = F,
                              seed = 1,
                              types = NULL
                              ){
  # browser()
  partitioned_df = list()
  
  if(include_full){partitioned_df$full = get_dataset}
  
  set.seed(seed)
  
  if(is.null(types)){
  types = get_dataset %>% dplyr::select(type) %>% unique %>% unlist
  }
  for(tp in types){
    
    partitioned_df[[tp]]$full = get_dataset %>% filter(type == tp)
    
    partition = partitioned_df[[tp]]$full %>% nrow %>% seq_len %>% createDataPartition(times = 1, p = validationSplit, list = F)
    
    partitioned_df[[tp]]$full_train =  partitioned_df[[tp]]$full %>% slice(partition)
    
    partitioned_df[[tp]]$x_train =  partitioned_df[[tp]]$full %>% dplyr::select(x,y) %>% slice(partition) %>% data.frame
    partitioned_df[[tp]]$y_train =  partitioned_df[[tp]]$full %>% dplyr::select(class) %>% slice(partition)
    
    partitioned_df[[tp]]$full_test =  partitioned_df[[tp]]$full %>% slice(-partition)
    
    partitioned_df[[tp]]$x_test = partitioned_df[[tp]]$full %>% dplyr::select(x,y) %>% slice(-partition)
    partitioned_df[[tp]]$y_test = partitioned_df[[tp]]$full %>% dplyr::select(class) %>% slice(-partition)
    
  }
  
  return(partitioned_df)
  
}


# get_full_dataset() %>% ggplot(aes(x = x, y = y, color = class)) +
#   geom_point() + facet_wrap(~type) + scale_color_fivethirtyeight() + theme_fivethirtyeight() +
#   labs(color = "") + theme(legend.position = "none")
# 
# linear_df <- make_linear_separable(n) %>% prepare_dataset()

### Prepare partition train / test
# df <- linear_df
# train_index <- createDataPartition(1:nrow(df), list = FALSE, p = 0.4)
# df$type <- "test"
# df[train_index,]$type <- "train"
# 
# train_df <- linear_df[train_index,]
# test_df <- linear_df[-train_index,]
# 
# 
# df %>% ggplot(aes(x = x, y = y, fill = class, alpha = type)) + geom_point(color = "black", shape = 21, size = 2) + 
#   scale_alpha_manual(values = c("train" = 0.6, "test" = 1)) + theme_fivethirtyeight()
# 
# 
# train(train_df %>% select(x,y), train_df %>% pull(class), method = "knn", tuneGrid = expand.grid(k = 3))

