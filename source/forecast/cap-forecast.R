
# function to make predictions
# 
# returns: forecast, as well as original data (test data only; last two months)
# from best prediction model 
#
capForecast <- function(dep = "DUE_LEVEL"){
  
  # getting data and preparing for ML algorithms
  lsData <- capGetData()
  lsData <- capCleanData(lsData)
  dt <- capCreatePredictors(lsData)
  dt <- capEliminateHighCorr(dt)
  
  # train different models and choose best one
  lsFc <- capForecastH2o(dt, dep)

  return(lsFc)
}

# function that uses the h2o setup to predict with h2o.automl()
#
# dt: data.table containing the prepared data
# returns: list of data containing predictions (pred) for last two months,
# and the orginal data of dependent variable (origLevelData) for plotting
#
capForecastH2o <- function(dt, dep = "DUE_LEVEL"){
  capLog("Train models.")
  origCol <- names(dt)
  relCol<- c("TIMESTAMP", dep, origCol[grepl("h", origCol)])
  dtRel <- dt[, relCol, with = F]
  
  # add augmented time data
  dtAug <- as.data.table(tk_augment_timeseries_signature(dtRel))
  changeCols<- names(Filter(is.ordered, dtAug))
  dtAug[, (changeCols) := lapply(.SD, as.character), .SDcols = changeCols][
    , (changeCols) := lapply(.SD, as.factor), .SDcols = changeCols]
  # get rid of unnecessary time and diff columns
  kickOutVec <- c("TIMESTAMP", "diff")
  dtAug <- dtAug[, -kickOutVec, with = F]
  
  # initialize H2O JVM
  h2o.init()
  # turn off progress bars
  # h2o.no_progress() 
  # split data into train, validation and test set
  h2oTrain <- as.h2o(dtAug[(year == 2017) | (year == 2018 & month < 7)])
  h2oValidation <- as.h2o(dtAug[year == 2018 & month >= 7 & month < 9])
  h2oTest <- as.h2o(dtAug[year == 2018 & month >= 9])
  
  # test different models; max_runtime_secs is set to ten minutes in order to
  # keep the algorithm reasonable fast, this however leads to a decrease in 
  # prediction power; exclude DRF and GBM models, since they are very heavy
  # in calculation; after a few testings, GLM turned out to be the best model 
  # anyway; stopping_metric can be altered, deviance is appropriate for 
  # regression (could also use RMSE,..)
  mdls <- h2o.automl(y = dep, x = setdiff(names(h2oTrain), dep), 
                     training_frame = h2oTrain, validation_frame = h2oValidation, 
                     leaderboard_frame = h2oTest, max_runtime_secs = 300,
                     exclude_algos = c("DRF", "GBM"), 
                     stopping_metric = "deviance")
  # extract best model and make predictions
  bestMdl <- mdls@leader
  capLog(paste0("Best model: ", bestMdl@algorithm))
  h2oPred <- h2o.predict(bestMdl, newdata = h2oTest)
  
  return(list(pred = h2oPred, 
              origLevelData = dtRel[, c("TIMESTAMP", dep), with = F]))
}
