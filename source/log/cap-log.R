
# log function
#
capLog <- function(text){
  output <- paste0(Sys.time(), "   ", text, " \n")
  cat(output)
}