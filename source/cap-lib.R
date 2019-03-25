
# install libraries automatically, if not installed yet
relLib <- c("data.table", "lubridate", "zoo", "caret", "h2o", "timetk", "plotly")
installLib <- relLib[!(relLib %in% installed.packages())]
if(length(installLib) != 0)
  l <- lapply(installLib, install.packages)

# load libraries
library(data.table)           # basic data structure
library(lubridate)            # for hour, minute
library(zoo)                  # for na.locf
library(caret)                # for findCorrelation
library(h2o)                  # for ML algorithms; package requires installation
                              # of Java JDK (development kit)
library(timetk)               # for augmented time series signature
library(plotly)               # for plots

# load all necessary files
source("source/data/cap-data.R")
source("source/data/cap-data-clean.R")
source("source/data/cap-data-predictors.R")
source("source/data/cap-data-corr.R")
source("source/forecast/cap-forecast.R")
source("source/forecast/cap-forecast-plot.R")
source("source/log/cap-log.R")
