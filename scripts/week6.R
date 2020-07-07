library(tidyverse)

setwd("/home/rstudio/r-workshop/data")

lf1 <- read.table("lakefinderdata_untidy.csv", sep=",", header=T, stringsAsFactors=TRUE)

class(lf1)
head(lf1)
View(lf1)

#tidyr----
#gather() is now pivot_longer()
#spread() is now pivot_wider()

lf1.tidy <- lf1 %>%
  pivot_longer(-date,
               names_to="pw_basin_name",
               values_to="elev.ft.NGVD29",
               values_drop_na=T)

#note on piping: this function would be exactly the same:
lf1.tidy <- pivot_longer(lf1, -date,
                         names_to="pw_basin_name",
                         values_to="elev.ft.NGVD29",
                         values_drop_na=T)

class(lf1.tidy)
head(lf1.tidy)
View(lf1.tidy)

lf1.untidy <- lf1.tidy %>%
  pivot_wider(id_cols=date, 
              names_from=pw_basin_name, 
              values_from=elev.ft.NGVD29)

View(lf1.untidy)

#lets tidy up the lake finder data
lf1 <- read.table("lakefinderdata.csv", sep=",", header=T, stringsAsFactors=TRUE)

lf1.tidy <- lf1 %>%
  pivot_longer(c("Lat_DD", "Lon_DD", "elev.ft.NGVD29", "elev.ft.NAVD88"),
               names_to="variable",
               values_to="value")

print(lf1.tidy)

lf1.tidy <- lf1 %>%
  pivot_longer(c(Lat_DD, Lon_DD, elev.ft.NGVD29, elev.ft.NAVD88),
               names_to="variable",
               values_to="value")

print(lf1.tidy)

lf1.tidy <- lf1 %>%
  pivot_longer(c(-dowlknum, -pw_basin_name, -date),
               names_to="variable",
               values_to="value")

print(lf1.tidy)

#separate time-dependent observations
lf1.tidy.tdep <- subset(lf1.tidy, (variable %in% c("elev.ft.NGVD29", "elev.ft.NAVD88")))  

print(lf1.tidy.tdep)

#separate time-independent observations
lf1.tidy.tind <- subset(lf1.tidy, !(variable %in% c("elev.ft.NGVD29", "elev.ft.NAVD88")))
lf1.tidy.tind <- lf1.tidy.tind[,names(lf1.tidy.tind) != "date"]
lf1.tidy.tind <- unique(lf1.tidy.tind)

#or combined into one line:
lf1.tidy.tind <- unique(subset(lf1.tidy, variable %in% c("Lat_DD", "Lon_DD"))[,names(lf1.tidy) != "date"])

print(lf1.tidy.tind)

#for a GIS friendly table, we can pivot wider:
lf1.tidy.tind <- lf1.tidy.tind %>%
  pivot_wider(names_from=variable, values_from=value)

print(lf1.tidy.tind)

#unite() and separate() are two other functions that are occasionally useful
lf1.tidy.tdep <- lf1.tidy.tdep %>%
  separate(col=date, c("year", "month", "mday"), sep="-")

head(lf1.tidy.tdep)

lf1.tidy.tdep <- lf1.tidy.tdep %>%
  unite("date", c(year, month, mday), sep="-")

head(lf1.tidy.tdep)

#exercises----
#play around with this data some more
covid19 <- readRDS("COVID19_US_States_Data.rds")

#see if you can:
# 1. subset just the Minnesota or Wisconsin data along with a few key observations (i.e. columns)
# 2. use pivot_longer() to tidy up the subsetted data. 
##   Example: try combining "bush00", "bush04", "obama_win08", and "obama_win12" and creating a "year" column so that it is 
##   easier to interpret who won the presidential race in each state in each year. Use factor releveling to make it consistent.
# 3. use pivot_wider() to revert the data
# 4. use unite() to combine two or more columns
# 5. use separate() to revert the data
# 6. try using these functions with and without the pipe operator (%>%)
