#introduction----
#minimal examples
my.date <- "7/7/1977"
my.date <- as.Date(my.date, format="%m/%d/%Y")
class(my.date)
print(my.date)
unclass(my.date)

my.datetime <- "7/7/1977 7:07:07"
my.datetime <- as.POSIXct(my.datetime, format="%m/%d/%Y %H:%M:%S", tz="America/Chicago") 
class(my.datetime)
print(my.datetime)
unclass(my.datetime)

#R uses tz database time zones: https://en.wikipedia.org/wiki/List_of_tz_database_time_zones
OlsonNames()
my.summertime <- as.POSIXct("1977-07-01 12:00:00", tz="US/Central")
print(my.summertime)

my.wintertime <- as.POSIXct("1977-01-01 12:00:00", tz="America/Chicago")
print(my.wintertime)

#if your data has am/pm
my.datetime <- "7/7/1977 7:07:07 pm"
my.datetime <- as.POSIXct(my.datetime, format="%m/%d/%Y %I:%M:%S %p", tz="UTC") 
class(my.datetime)
print(my.datetime)

#difftime
my.datetime2 <- as.POSIXct("8/7/1977 7:07:07 pm", format="%m/%d/%Y %I:%M:%S %p", tz="UTC")

my.diff <- my.datetime2 - my.datetime
class(my.diff)
print(my.diff)

#enter lubridate----
#https://rawgit.com/rstudio/cheatsheets/master/lubridate.pdf
#part of tidyverse now, apparently!
library(lubridate) #though not a core part, so must be loaded separately

my.datetime <- "7/7/1977 7:07:07 pm" #using American date formats is a bad idea in general
my.datetime <- as_datetime(my.datetime)

my.datetime <- "1977-07-07 19:07:07" #instead, get used to formatting your dates and times like a Canadian
my.datetime <- as_datetime(my.datetime)
class(my.datetime)
print(my.datetime)

my.diff <- as_date("1977-07-07 11:59:59 pm") - as_date("1977-07-07 00:00:00 am")
class(my.diff)
print(my.diff)

my.datetime <- mdy_hm("7/7/1977 07:07 pm")
class(my.datetime)
print(my.datetime)

#getting date components
print(my.datetime)
date(my.datetime)

year(my.datetime)
month(my.datetime)
mday(my.datetime)
hour(my.datetime)
minute(my.datetime)
second(my.datetime)

week(my.datetime)
yday(my.datetime)

weekdays(my.datetime) #base function
months(my.datetime) #base function

#creating date sequences
my.days <- seq(my.datetime, length=365, by="day")
class(my.days)
print(my.days)
yday(my.days)

my.weeks <- seq(my.date, length=52, by="week")
class(my.weeks)
print(my.weeks)
week(my.weeks)

my.hours <- seq(my.datetime, length=52, by=3600) #since POSIXct is supplied, units are seconds
class(my.hours)
print(my.hours)

my.dates <- seq(my.date, length=52, by=30) #since Date is supplied, units are days
class(my.dates)
print(my.dates)

my.minutes <- seq(now(), length=1440, by=60) #since Date is supplied, units are days
class(my.minutes)
head(my.minutes)
length(my.minutes)
range(my.minutes)
difftime(range(my.minutes)[2], range(my.minutes)[1])

#working with a dataframe----
#change working directory
setwd("/home/rstudio/r-workshop/data")

lf1 <- read.table("lakefinderdata.csv", sep=",", header=T, stringsAsFactors=FALSE)
head(lf1)
class(lf1$date)
lf1$date[2] - lf1$date[1]

#converting to Date
lf1$date <- as_date(lf1$date, format="%Y-%m-%d")
head(lf1)
class(lf1$date)

lf1$difftime <- lf1$date - as_date("1970-01-01")
head(lf1)
class(lf1$difftime)

#what about factor to Date? (instead of character to Date)
lf1 <- read.table("lakefinderdata.csv", sep=",", header=T, stringsAsFactors=TRUE)
class(lf1$date)
lf1$date <- as_date(lf1$date)
class(lf1$date)

#reordering dates (or any data type)
head(lf1)
lf1 <- lf1[order(lf1$date),]
head(lf1)
lf1 <- lf1[order(lf1$pw_basin_name, lf1$date),]
head(lf1)

#filling missing dates
loon <- subset(lf1, pw_basin_name=="Loon")
head(loon)
range(loon$date)
plot(loon$elev.ft.NAVD88~loon$date)

fill.dates <- seq(min(loon$date), max(loon$date), by="day")
fill.dates <- seq(range(loon$date)[1], range(loon$date)[2], by="day")

fill.dates <- data.frame(date=fill.dates, elev.ft.NGVD29=NA, elev.ft.NAVD88=NA)

loon <- merge(loon, fill.dates, by="date", all=T)
head(loon)

#exercises----
#play around with this data some more
covid19 <- readRDS("COVID19_US_States_Data.rds")

#see if you can:
# 1. check the class of the date column
# 2. subset just the Minnesota or Wisconsin data
# 3. separate out the date parts and store them as new columns
# 4. find a way to aggregate some of the daily data by week and/or month
# 5. what is causing the peaks and valleys in positive_increase?

