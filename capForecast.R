# main file to run the forecast system for the level of the Rhein at Duesseldorf;
# this includes preperation of the data, creating appropriate predictors, 
# training different ML algorithms and extracting the best model to predict
# the last two months of the data; 
#
# capForecast() will return a list with the predictions, and the original level
# data of the dependent variable (here level of Duesseldorf)

# source all required functions and libraries
source("source/cap-lib.R")

# run forecast system
p <- capForecast()
