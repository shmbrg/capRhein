# main file to run the forecast system for the level of the Rhein at Duesseldorf;
# this includes preperation of the data, creating appropriate predictors, 
# training different ML algorithms and extracting the best model to predict
# the last two months of the data; 
#
# capForecast() will return a list with two plots; the first one will show the
# predictions against the actual observations in line plot; the second one is
# a variable imortance plot of the choosen model (here the best model was GLM)

# source all required functions and libraries
source("source/cap-lib.R")

# run forecast system
capForecast()