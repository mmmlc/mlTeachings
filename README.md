# mlTeachings

Jupyter+R: [![Binder](http://mybinder.org/badge.svg)](http://beta.mybinder.org/v2/gh/binder-examples/r/master?filepath=index.ipynb)

RStudio: [![Binder](http://mybinder.org/badge.svg)](http://beta.mybinder.org/v2/gh/binder-examples/r/master?urlpath=rstudio)

## ML
* ### In R
    * #### Caret Cheatsheet
        https://github.com/rstudio/cheatsheets/raw/master/caret.pdf
    * #### Caret Manual
         https://topepo.github.io/caret/index.html
* ### References
    http://www-bcf.usc.edu/~gareth/ISL/ISLR%20Seventh%20Printing.pdf

## NNets
* ### In R
    https://tensorflow.rstudio.com/
    https://keras.rstudio.com/
    * #### Keras Cheatsheet
        https://github.com/rstudio/cheatsheets/raw/master/keras.pdf
*   ### References
    http://www.deeplearningbook.org/

## Random

```r
install.packages('cowsay)

cowsay::say(fortune = 10)

someone_say_hello <- function() {
    animal <- sample(names(cowsay::animals), 1) 
    cowsay::say(paste("Hello, I'm a ", animal, ".", collapse = ""), by = animal)  
}

someone_say_hello()

```

