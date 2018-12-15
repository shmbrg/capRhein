

# function to retrieve data for one location
capGetSingleData <- function(location){
  

}

# function to retrieve single temperature data
capGetSingleTempData <- function(location){

  # get temperature data
  fileName <- grep(paste0(location, "_produkt_tu"), dir("data/Wetter"), value = T)
  if(length(fileName) == 0) return(data.table())
  dtTemp <- fread(paste0("data/Wetter/", fileName), sep = ";", dec = ".")
  
  # filter relevant columns
  dtTemp <- dtTemp[, c(2,4)]
  setnames(dtTemp, c("Date", "Temp"))
  
  # bring date into right format
  dtTemp <- dtTemp[, Date := as.POSIXct(as.character(Date), format = "%Y%m%d%H")]
  
  # remove missing date entries
  dtTemp <- dtTemp[!is.na(Date)]
  
  # set column name according to location
  setnames(dtTemp, "Temp", paste0("Temp_", substr(location, 1, 3)))
  
  return(dtTemp)
}

# function to retrieve single rain data
capGetSingleRainData <- function(location){
  
  # get rain data
  fileName <- grep(paste0(location, "_produkt_rr"), dir("data/Wetter"), value = T)
  dtRain <- fread(paste0("data/Wetter/", fileName), sep = ";", dec = ".")
  
  # filter relevant columns
  dtRain <- dtRain[, c(2,4)]
  setnames(dtRain, c("Date", "Rain"))
  
  # bring date into right format
  dtRain <- dtRain[, Date := as.POSIXct(as.character(Date), format = "%Y%m%d%H")]
  
  # set negative rain fall to 0
  dtRain[Rain < 0, Rain := 0]
  
  # remove missing date entries
  dtRain <- dtRain[!is.na(Date)]
  
  # set column name according to location
  setnames(dtRain, "Rain", paste0("Rain_", substr(location, 1, 3)))
  
  return(dtRain)
}