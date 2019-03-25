
# function to plot original observations with the predictions of the choosen 
# model
#
# mdl: h2o model object
# newdata: h2o data object with test data from earlier split
#
capPlotPrediction <- function(lsFc){
  mdl <- lsFc$mdlUsed
  dtPred <- as.data.table(lsFc$pred)
  dtOrig <- lsFc$origLevelData
  
  dtPred[, TIMESTAMP := tail(dtOrig$TIMESTAMP, length(predict))]
  dtMerge <- merge(dtOrig, dtPred, by = "TIMESTAMP", all.x = T)
  
  p <- plot_ly(dtMerge, x = ~TIMESTAMP, y = ~DUE_LEVEL, 
               type = 'scatter', mode = 'lines', name = "Original level") %>%
    add_trace(y = ~predict, mode = 'lines', name = "Predicted level") %>%
    layout(xaxis = list(title = "Date"),
           yaxis = list(title = "Rhein level"),
           title = paste0("(Predicted) Rhein level at Duesseldorf \n using a '",
                          mdl, "' model"),
           margin = list(t = 50))
  
  return(p)
}








