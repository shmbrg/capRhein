

# getting and preparing data for ML algorithms
lsData <- capGetData()
lsData <- capCleanData(lsData)
dt <- capCreatePredictors(lsData)
dt <- capEliminateHighCorr(dt)

# next step, choose your y (only DUE_LEVEL), define your X (exclude original variables)
# and use ML algorithm to train and evaluate model performance

