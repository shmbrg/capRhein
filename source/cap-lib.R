
# install libraries automatically, if not installed yet

# load libraries
library(data.table)           # basic data structure
#library(GLDEX)
library(lubridate)            # for hour, minute
library(zoo)                  # for na.locf
#library(xts)
library(caret)                # for findCorrelation
#library(corrplot)            # cor plot; not needed in system
library(h2o)                  # for ML algorithms

# load all necessary fils
source("source/data/cap-data.R")
source("source/data/cap-data-clean.R")
source("source/data/cap-data-predictors.R")
source("source/data/cap-data-corr.R")
