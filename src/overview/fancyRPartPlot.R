fancyRPartPlot = function (model, main = "", sub, palettes, ...) 
{
  if (missing(sub)) 
    sub <- paste("Rattle", format(Sys.time(), "%Y-%b-%d %H:%M:%S"), 
      Sys.info()["user"])
  num.classes <- length(attr(model, "ylevels"))
  default.palettes <- c("Greens", "Blues", "Oranges", "Purples", 
    "Reds", "Greys")
  if (missing(palettes)) 
    palettes <- default.palettes
  missed <- setdiff(1:6, seq(length(palettes)))
  palettes <- c(palettes, default.palettes[missed])
  numpals <- 6
  palsize <- 5
  pals <- c(RColorBrewer::brewer.pal(9, palettes[1])[1:5], 
    RColorBrewer::brewer.pal(9, palettes[2])[1:5], RColorBrewer::brewer.pal(9, 
      palettes[3])[1:5], RColorBrewer::brewer.pal(9, palettes[4])[1:5], 
    RColorBrewer::brewer.pal(9, palettes[5])[1:5], RColorBrewer::brewer.pal(9, 
      palettes[6])[1:5])
  if (model$method == "class") {
    yval2per <- -(1:num.classes) - 1
    per <- apply(model$frame$yval2[, yval2per], 1, function(x) x[1 + 
      x[1]])
  }
  else {
    per <- model$frame$yval/max(model$frame$yval)
  }
  per <- as.numeric(per)
  if (model$method == "class") 
    col.index <- ((palsize * (model$frame$yval - 1) + trunc(pmin(1 + 
      (per * palsize), palsize)))%%(numpals * palsize))
  else col.index <- round(per * (palsize - 1)) + 1
  col.index <- abs(col.index)
  if (model$method == "class") 
    extra <- 104
  else extra <- 101
  rpart.plot::prp(model, type = 2, extra = extra, box.col = pals[col.index], 
    nn = TRUE, varlen = 0, faclen = 0, shadow.col = "grey", 
    fallen.leaves = TRUE, branch.lty = 3, ...)
  title(main = main, sub = sub)
}
