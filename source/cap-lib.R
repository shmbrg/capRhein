
# install libraries automatically, if not installed yet

# load libraries
library(data.table)
library(GLDEX)
library(lubridate)
library(zoo)
library(xts)

# load all necessary fils
source("source/data/cap-data.R")
source("source/data/cap-data-prepare.R")
source("source/data/cap-data-predictors.R")
