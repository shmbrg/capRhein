
# log function
#
capLog <- function(text){
  output <- paste0(Sys.time(), "   ", text)
  cat(output)
}