
# install libraries automatically, if not installed yet

# load libraries
library(data.table)           # basic data structure
library(lubridate)            # for hour, minute
library(zoo)                  # for na.locf
library(caret)                # for findCorrelation
library(h2o)                  # for ML algorithms
library(timetk)               # for augmented time series signature

# load all necessary files
source("source/data/cap-data.R")
source("source/data/cap-data-clean.R")
source("source/data/cap-data-predictors.R")
source("source/data/cap-data-corr.R")
source("source/forecast/cap-forecast.R")
source("source/forecast/cap-forecast-plot.R")
source("source/log/cap-log.R")
