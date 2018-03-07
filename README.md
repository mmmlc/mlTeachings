# mlTeachings

## Caret Cheatsheet
https://github.com/rstudio/cheatsheets/raw/master/caret.pdf

## Keras Cheatsheet
https://github.com/rstudio/cheatsheets/raw/master/keras.pdf

## NNets in R
https://tensorflow.rstudio.com/
https://keras.rstudio.com/

## Random
install.packages('cowsay)
cowsay::say(fortune = 10)

someone_say_hello <- function() {
    animal <- sample(names(cowsay::animals), 1)
    cowsay::say(paste("Hello, I'm a ", animal, ".", collapse = ""), by = animal)
}
someone_say_hello()
