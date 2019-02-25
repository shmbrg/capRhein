

capCreatePredictors <- function(lsData){
  lsData <- capCastData(lsData)
  
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
  
  # different time horizons for stations, therefore first and last day not 
  # considered; also MANNHEIM and DUESSELDORF have missing values, since they
  # lack certain date entries in the first place - fill with locf; this only 
  # occurs in temp and rain data
  
  
  
  return(list(level = dtLevel, flow = dtFlow, temp = dtTemp, rain = dtRain))
}