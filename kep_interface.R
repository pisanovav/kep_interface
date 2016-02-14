# Purpose: access interface to Rosstat KEP database by Evgeny Pogrebnyak to retrieve 'zoo' class time-series.
# Database URL: https://github.com/epogrebnyak/rosstat-kep-data.
# Code URL: https://github.com/pisanovav/kep_interface.
# Author(s): Evgeny Pogrebnyak, Alexander Pisanov.
#
# Entry points:
#   id = 'CPI_rog', frequency = 'a'
#   get.zoo.kep(id,frequency)
#   write.csv.kep(id,frequency)
#
# Todo: function tests.

############################
# KEP CONNECTION INTERFACE #
############################

library(zoo) # 'zoo' library is required.

get.data.url.kep <- function(frequency)
  #' Returns an URL string. Syntax: get.data.url.kep("a").
  #' frequency (required) - time series frequency. Input: "a", "q", "m".  
{
  if (!(frequency %in% c("a","q","m"))) stop("Incorrect frequency parameter. Use 'a', 'q' or 'm' in double quotes.")
  
  data.folder <- "https://raw.githubusercontent.com/epogrebnyak/rosstat-kep-data/master/output/"
  data.filename <- c(a="data_annual.txt",q="data_quarter.txt",m="data_monthly.txt")
  data.url <- paste0(data.folder,data.filename[frequency])
  
  return(data.url)
}

get.data.frame.kep <- function(id,frequency)
  #' Returns an object of class 'data.frame' with data of a selected frequency. Syntax: get.data.frame.kep("a").
  #' id(required) - time series id (see full list here: https://raw.githubusercontent.com/epogrebnyak/rosstat-kep-data/master/output/varnames.md), frequency(required) - time series frequency.
{
  data.table <- read.table(get.data.url.kep(frequency),sep = ",",header=TRUE,row.names=1)[id]
  
  return(data.table)
}

get.zoo.kep <- function(id,frequency,start.date=NULL,end.date=NULL)
  #' Returns an object of class 'zoo' with a time series of a selected id, frequency and date range. Syntax: get.zoo.kep("CPI_rog","q","1999-01-01","2000-01-01").
  #' id(required) - time series id (see full list here: https://raw.githubusercontent.com/epogrebnyak/rosstat-kep-data/master/output/varnames.md), frequency(required) - time series frequency, start/end.date(optional) - date range.
{
  data.table <- get.data.frame.kep(id,frequency)
  data.zoo <- zoo(data.table,row.names(data.table))
  output <- window(data.zoo,start=start.date,end=end.date)
  
  return(output)
}

write.csv.kep <- function(id,frequency,start.date=NULL,end.date=NULL)
  #' Writes a .csv file to current working directory. Syntax: write.csv.kep("CPI_rog","q","1999-01-01","2000-01-01").
  #' id(required) - time series id (see full list here: https://raw.githubusercontent.com/epogrebnyak/rosstat-kep-data/master/output/varnames.md), frequency(required) - time series frequency, start/end.date(optional) - date range.
{
  data.filename <- paste0(id,".csv")
  write.csv(get.zoo.kep(id,frequency,start.date,end.date),file=data.filename,row.names=TRUE,dec=",")
  
  warning(paste("Wrote ",data.filename," to current working directory: ",getwd()))
  
  return(file.path(getwd(),data.filename)) 
}

#############
# YOUR CODE #
#############

source("kep_interface.R") # File with the interface code should be saved in your current working directory.

# ...
