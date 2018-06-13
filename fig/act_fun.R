library(ggplot2)
library(sigmoid)

linear = function(x) x
binary_step = function(x) 0.5 + sign(x)/2
sigmoid = function(x) (1/(1+exp(-x)))
#tanh = function(x) tanh(x)
#relu = function(x) if (x < 0) {0} else {x}
#leaky_relu = function(x) if (x < 0) {0.01*x} else {x}

plottami <- function(funzione, numero, limitex) {
  ggplot(data = data.frame(x = 0), mapping = aes(x = x)) +
    stat_function(fun = funzione, n=numero, colour = "red", size = 1.5) +
    theme(panel.border = element_rect(colour = "black", fill=NA),
          panel.background = element_blank(),
          axis.title = element_blank()) +
    #theme_classic() +
    xlim(-10,10) +
    #ylim(-1,1) +
    coord_cartesian(xlim = c(-limitex, limitex), ylim = c(-1, 1)) +
    geom_hline(aes(yintercept=0), size=0.5)+geom_vline(aes(xintercept=0))
}

plottami(funzione='linear', 100, limitex = 1)
plottami(funzione='binary_step', 10000, limitex = 1)
plottami(funzione='sigmoid', 100, limitex = 5)
plottami(funzione='relu', 1000, limitex = 1)


