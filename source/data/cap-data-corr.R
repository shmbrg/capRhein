
# function to eliminate highly correlated features
#
# dt: data.table containing all variables, including all features and originals
# returns: data.table containing all original variables, as well as features, 
# which are not pairwise highly correlated
#
capEliminateHighCorr <- function(dt){
  orgNames <- names(dt)
  orgNames <- orgNames[!grepl("h", orgNames)]
  l <- length(orgNames)
  dtOrig <- dt[, 1:l]
  dtCor <- dt[, (l+1):dim(dt)[2]]
  
  # checking correlation of pairwise features; find highly correlated features and
  # only keep features with higher explanation degree
  dtCor <- cor(dtCor)
  highCorr <- findCorrelation(dtCor, cutoff = .85)
  dtCor <- dtCor[, -highCorr]
  relNames <- colnames(dtCor)
  
  dt <- dt[, c(orgNames, relNames), with = F]
  return(dt)
}