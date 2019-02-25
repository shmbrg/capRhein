# function to import level, flow, temperature and rainfall data for different
# stations; level and flow data is listed every 15 minutes, temperature and
# rainfall data is listed every 60 minutes
#
capGetData <- function(){
  # load data
  dtLevel <- fread("/Users/seb/Git Projects/capRhein/data/level.csv")
  dtFlow <- fread("/Users/seb/Git Projects/capRhein/data/flow.csv")
  dtTemp <- fread("/Users/seb/Git Projects/capRhein/data/temp.csv")
  dtRain <- fread("/Users/seb/Git Projects/capRhein/data/rain.csv")
  
  # fix timestamps and kpis to factors
  dtLevel[, `:=` (TIMESTAMP = as_datetime(TIMESTAMP), STATION = as.factor(STATION))]
  dtFlow[, `:=` (TIMESTAMP = as_datetime(TIMESTAMP), STATION = as.factor(STATION))]
  dtTemp[, `:=` (TIMESTAMP = as_datetime(TIMESTAMP), STATION = as.factor(STATION))]
  dtRain[, `:=` (TIMESTAMP = as_datetime(TIMESTAMP), STATION = as.factor(STATION))]
  
  return(list(level = dtLevel, flow = dtFlow, temp = dtTemp, rain = dtRain))
}


