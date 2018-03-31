# mlTeachings


Lesson 0 - Intro Tidyverse [![Binder](http://mybinder.org/badge.svg)](http://beta.mybinder.org/v2/gh/gbonomib/mlTeachings/master?urlpath=lab?filepath=lessons/one/0_intro_tidiverse.ipynb)

Lesson 1 - Datasets [![Binder](http://mybinder.org/badge.svg)](http://beta.mybinder.org/v2/gh/gbonomib/mlTeachings/master?urlpath=lab?filepath=lessons/one/1_datasets.ipynb)

Lesson 2 - KNN [![Binder](http://mybinder.org/badge.svg)](http://beta.mybinder.org/v2/gh/gbonomib/mlTeachings/master?urlpath=lab?filepath=lessons/one/2_knn.ipynb)

Lesson 3 - SVM [![Binder](http://mybinder.org/badge.svg)](http://beta.mybinder.org/v2/gh/gbonomib/mlTeachings/master?urlpath=lab?filepath=lessons/one/3_svm.ipynb)

Lesson 4 - DT & RF [![Binder](http://mybinder.org/badge.svg)](http://beta.mybinder.org/v2/gh/gbonomib/mlTeachings/master?urlpath=lab?filepath=lessons/one/4_dt.ipynb)

Others

Jupyter Notebook -> [![Binder](http://mybinder.org/badge.svg)](http://beta.mybinder.org/v2/gh/gbonomib/mlTeachings/master?urlpath=tree)

RStudio -> [![Binder](http://mybinder.org/badge.svg)](http://beta.mybinder.org/v2/gh/gbonomib/mlTeachings/master?urlpath=rstudio)

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
install.packages('cowsay')

someone_diss_sas <- function() {
    animal <- sample(names(cowsay::animals), 1) 
    cowsay::say(fortune = "SAS", by = animal)  
}

someone_diss_sas()

```

