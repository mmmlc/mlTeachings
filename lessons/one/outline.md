# Outline

0. A modern approach to the R programming language
	* pipe operator
	* tidyverse

1. What is ML about
	* supervised **we focus on this**
	* unsupervised
	* reinforcement
	
2. About supervised learning
	* regression (everybody knows)
		* e.g. linear regression
	* classification (hei credit guys)
		* e.g. logistic regression

Our focus is on classification

3. How to do it? No need for theory if you have the right R packages
	* plot dataset
		* each problem can be tackled with different techniques
	* Helicopter view on 4 selected models.
		* KNN
		* other of Fabio's choiche
		* SVM
		* Random forest
	* For each of the selected model
		* raster plot
		* Hyperparameter Tuning: lay out the R code so that is possible to trigger a fer parameters to see how stuffs changes
			* KNN = number of neighbors
			* ...
			* SVM ...
			* Random Forest: num of decision trees
	* there are many other techniques
		* plot all the rasters together

3.1. **bonus** Theme of higher dimensionality:
	* even the simplest problem has more than two dimensions
	* titanic dataset example
		
4. Machine learning is nothing new:
	* Evolution of algorithms

5. ML is greedy
	* we don't care about p-values, stepwise variable selection. AIC BIC and similar bullshits, rather we want the best model for the task
	* what does "best model" actually mean?
	* How to find the best among many? Visualization can give some qualitative suggestions but...
	* what about overfitting
	* See you next time!
	
6) others (?)
