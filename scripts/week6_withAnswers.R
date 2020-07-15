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
covid19.wi <- subset(covid19, state=="Wisconsin")[,c("gb_win00", "gb_win04", "obama_win08", "obama_win12", "positive_increase.norm", "date")]

# 2. use pivot_longer() to tidy up the subsetted data. 
covid19.wi <- covid19.wi %>%
  pivot_longer(cols=c(-positive_increase.norm, -date),
               names_to="election.year",
               values_to="election.winner")

covid19.wi$election.year <- factor(covid19.wi$election.year)
levels(covid19.wi$election.year) <- c("2000", "2004", "2008", "2012")

covid19.wi$election.winner <- factor(covid19.wi$election.winner)
levels(covid19.wi$election.winner) <- c("Gore", "Kerry", "Obama", "Obama")

# 3. use pivot_wider() to revert the data
covid19.wi <- covid19.wi %>%
  pivot_wider(id_cols=c(date, positive_increase.norm), 
              names_from=election.year,
              values_from=election.winner)

# 4. use unite() to combine two or more columns
# 5. use separate() to revert the data
covid19.wi <- covid19.wi %>%
  separate(date, c("year", "month", "mday"), sep="-")

covid19.wi <- covid19.wi %>%
  unite("date", c(year, month, mday), sep="-")

# 6. try using these functions with and without the pipe operator (%>%)
pivot_longer(covid19.wi, 
             cols=c(-date, -positive_increase.norm), 
             names_to="election.year",
             values_to="election.winner")
