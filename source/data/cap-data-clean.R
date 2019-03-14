# function to clean datasets
#
# lsData: list of all four datasets; datasets being data.table
#
capCleanData <- function(lsData){
  capLog("Clean data.")
  
  dtLevel <- lsData$level
  dtFlow <- lsData$flow
  dtTemp <- lsData$temp
  dtRain <- lsData$rain
  
  # correct for outliers
  dtLevel <- capOutlierCorrection(dtLevel)
  dtFlow <- capOutlierCorrection(dtFlow)
  dtTemp <- capOutlierCorrection(dtTemp)
  dtRain <- capOutlierCorrection(dtRain)
  
  # aggregate level and flow data, since rain and temp data is only hourly
  dtLevel <- capAggregateHourly(dtLevel)
  dtFlow <- capAggregateHourly(dtFlow)
  
  return(list(level = dtLevel, flow = dtFlow, temp = dtTemp, rain = dtRain))
}

# function to fix negatives and outliers with locf
#
# dt: data.table containing temp, rain, flow or level info
#
capOutlierCorrection <- function(dt){
  kpi <- dt[1, KPI]
  
  dt[, `:=` (qLow = quantile(VALUE, 0.025),
             qHigh = quantile(VALUE, 0.975)),
     by = "STATION"]
  
  if(kpi == "LEVEL")
    dt[2 * VALUE < qLow | VALUE > 2 * qHigh | VALUE < 0, VALUE := NA]
  if(kpi == "FLOW")
    dt[3 * VALUE < qLow | VALUE > 3 * qHigh | VALUE < 0, VALUE := NA]
  if(kpi == "TEMPERATURE")
    dt[VALUE < -20, VALUE := NA]
  if(kpi == "RAIN")
    dt[VALUE < 0, VALUE := NA]
  
  dt[, VALUE := na.locf(VALUE), by = "STATION"]
  dt[, `:=` (qLow = NULL, qHigh = NULL)]
  return(dt)
}

# function to aggregate quaterly observations into hourly, using the mean
#
# dt: data.table containing flow or level info
#
capAggregateHourly <- function(dt){
  aggrVec <- c("STATION", "Date", "Hour")
  dt[, `:=` (Date = as.Date(TIMESTAMP), Hour = lubridate::hour(TIMESTAMP), 
             Min = lubridate::minute(TIMESTAMP))]
  dt[, meanVALUE := mean(VALUE), by = aggrVec]
  dt <- dt[Min == 0]
  dt[, `:=` (VALUE = meanVALUE, Date = NULL, Hour = NULL, Min = NULL,
             meanVALUE = NULL)]
  
  return(dt)
}

