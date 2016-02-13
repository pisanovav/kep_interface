# Author(s): Evgeny Pogrebnyak, Alexander Pisanov.

#################
# KEP INTERFACE #
#################

get.data.url.kep <- function(frequency)
#' Returns an URL string. Syntax: get.kep.data.url("a").
#' frequency (required) - time series frequency. Input: "a", "q", "m".  
{
  if (!(frequency %in% c("a","q","m"))) stop("Incorrect frequency.")
  
  data.folder <- "https://raw.githubusercontent.com/epogrebnyak/rosstat-kep-data/master/output/"
  data.filename <- c(a="data_annual.txt",q="data_quarter.txt",m="data_monthly.txt")
  data.url <- paste0(data.folder,data.filename[frequency])
  
  return(data.url)
}

get.data.frame.kep <- function(id,frequency)
#' Returns an object of class 'data.frame' with data of a selected frequency. Syntax: get.kep.data.frame("a").
#' frequency (required, "a", "q", "m") - time series frequency.
{
  data.table <- read.table(get.data.url.kep(frequency),sep = ",",header=TRUE,row.names=1)[id]
  
  return(data.table)
}

get.zoo.kep <- function(id,frequency,start.date=NULL,end.date=NULL)
#' Returns an object of class 'zoo' with a time series of a selected id, frequency and date range. Syntax: get.kep.zoo("CPI_rog","q","1999-01-01","2000-01-01").
#' id(required) - time series id (see full list here: https://raw.githubusercontent.com/epogrebnyak/rosstat-kep-data/master/output/varnames.md), frequency(required, "a", "q", "m") - time series frequency, start/end.date(optional) - date range.
{
  data.table <- get.data.frame.kep(id,frequency)
  data.zoo <- zoo(data.table,row.names(data.table))
  output <- window(data.zoo,start=start.date,end=end.date)
  
  return(output)
}

write.csv.kep <- function(id,frequency,start.date=NULL,end.date=NULL)
#' Writes a .csv file to current working directory. Syntax: get.kep.zoo("CPI_rog","q","1999-01-01","2000-01-01").
#' id(required) - time series id (see full list here: https://raw.githubusercontent.com/epogrebnyak/rosstat-kep-data/master/output/varnames.md), frequency(required, "a", "q", "m") - time series frequency, start/end.date(optional) - date range.
{
  data.filename <- paste0(id,".csv")
  write.csv(get.zoo.kep(id,frequency,start.date,end.date),file=data.filename,row.names=TRUE,dec=",")
  
  warning(paste("Wrote ",data.filename," to current working directory: ",getwd()))
  
  return(file.path(getwd(),data.filename)) 
}
