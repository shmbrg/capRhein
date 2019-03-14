
# function to plot original observations with the predictions of the choosen 
# model
#
# mdl: h2o model object
# newdata: h2o data object with test data from earlier split
#
capPlotPrediction <- function(lsFc){
  dtPred <- as.data.table(lsFc$pred)
  dtOrig <- lsFc$origLevelData
  
  # not done yet ?!
  
  plot(DUE_LEVEL ~ as.Date(TIMESTAMP), dtOrig, type = "l")
}








