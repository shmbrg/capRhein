
# function that creates the predictor dataset
#
# lsData: list containing data.tables
# returns: data.table
#
capCreatePredictors <- function(lsData){
  lsData <- capCastData(lsData)
  dt <- capMergeData(lsData)
  dt <- capCreateLags(dt)
  return(dt)
}

# function that creates lags for all features;
# lags used: 3h, 6h, 12h, 24h, 48h
#
# dt: data.table containing all relevant features
#
capCreateLags <- function(dt){
  dim <- dim(dt)
  rowNrs <- dim[1]
  colNrs <- dim[2]
  orgNames <- names(dt)
  
  # matLag produces all lags up until lag 48
  matLag <- embed(as.matrix(dt[,2:colNrs]), dimension = 49)
  dtLag <- as.data.table(matLag)
  dtLag <- cbind(TIMESTAMP = dt[49:rowNrs, TIMESTAMP], dtLag)
  
  colNames <- orgNames
  for(i in 1:48){
    curNames <- orgNames[-1]
    curNames <- paste0(curNames, "_", i, "h")
    colNames <- c(colNames, curNames)
  }
  setnames(dtLag, colNames)
  
  # dtLag contains all lags up to 48 hours; subset only relevant lags
  allCol <- names(dtLag)
  relCol <- allCol[1:colNrs]
  relLags <- c(3,6,12,24,48)
  for(i in relLags){
    relCol <- c(relCol, allCol[grep(paste0("_",i ,"h"), allCol)])
  }
  
  dtLag <- dtLag[, relCol, with = F]
  return(dtLag)
}

# function that merges all features according to timestamp; since temp and rain 
# data have only one year history, data will be merged according to this history
# (therefore, use inner join)
#
# lsData: list containing data.tables
# returns: data.table
#
capMergeData <- function(lsData){
  dtLevel <- lsData$level
  dtFlow <- lsData$flow
  dtTemp <- lsData$temp
  dtRain <- lsData$rain
  
  dt <- merge(dtLevel, dtFlow, by = "TIMESTAMP")
  dt <- merge(dt, dtTemp, by = "TIMESTAMP")
  dt <- merge(dt, dtRain, by = "TIMESTAMP")
  
  return(dt)
}

# function that cast data into wide format
#
# lsData: list containing data.tables
#
capCastData <- function(lsData){
  dtLevel <- lsData$level
  dtFlow <- lsData$flow
  dtTemp <- lsData$temp
  dtRain <- lsData$rain
  
  dtLevel <- dcast(dtLevel, TIMESTAMP + KPI ~ STATION, value.var = "VALUE")
  dtFlow <- dcast(dtFlow, TIMESTAMP + KPI ~ STATION, value.var = "VALUE")
  dtTemp <- dcast(dtTemp, TIMESTAMP + KPI ~ STATION, value.var = "VALUE")
  dtRain <- dcast(dtRain, TIMESTAMP + KPI ~ STATION, value.var = "VALUE")

  dtTemp <- capFixMissingData(dtTemp)
  dtRain <- capFixMissingData(dtRain)
  
  lsData <- list(level = dtLevel, flow = dtFlow, temp = dtTemp, rain = dtRain)
  lsData <- lapply(lsData, capSetColumnNames)
  
  return(lsData)
}

# function that gives casted data right column names
#
# lsData: list containing data.tables
#
capSetColumnNames <- function(dt){
  kpi <- dt[1, KPI]
  sameVar <- c("TIMESTAMP", "KPI")
  oldNames <- names(dt[, -sameVar, with = F])
  newNames <- paste0(substr(oldNames, 1, 3), "_", kpi)
  setnames(dt, oldNames, newNames)
  dt <- dt[, -"KPI"]
  return(dt)
}

# function to fix missing data
#
# different time horizons for stations, therefore first and last day not 
# considered; also MANNHEIM and DUESSELDORF have missing values, since they
# lack certain date entries in the first place - fill with locf; this only 
# occurs in temp and rain data
#
# dt: data.table containing temp or rain data
#
capFixMissingData <- function(dt){
  kpi <- dt[1, KPI]
  max <- as.Date(max(dt[, TIMESTAMP]))
  min <- as.Date(min(dt[, TIMESTAMP]))
  dt <- dt[as.Date(TIMESTAMP) != max & as.Date(TIMESTAMP) != min]
  
  if(kpi == "RAIN"){
    colNames <- colnames(dt)[colSums(is.na(dt)) > 0]
    for(curName in colNames){
      dt[, eval(curName) := na.locf(get(curName))]  
    }
  }
  return(dt)
}

