library(tidyverse)

setwd("/home/rstudio/r-workshop/data")

lf1 <- read.table("lakefinderdata.csv", sep=",", header=T, stringsAsFactors=TRUE)

#intro to dplyr functions----

#some basic subsetting
##by columns
select(lf1, pw_basin_name, date, elev.ft.NAVD88)

lf2 <- lf1 %>%
  select(pw_basin_name, date, elev.ft.NAVD88) #same result as previous line

lf2 <- lf1 %>%
  select(-Lat_DD, -Lon_DD)

lf2 <- lf1 %>%
  select(dowlknum:Lon_DD, -date)

lf2 <- lf1 %>%
  select(dowlknum, pw_basin_name, ends_with("DD"))

lf2 <- lf1 %>%
  select(dowlknum:pw_basin_name, contains("elev"))

lf2 <- lf1 %>%
  select(head(names(.), 2), tail(names(.), 2))

##by rows
lf2 <- lf1 %>%
  filter(pw_basin_name %in% c("Louise", "Silver"))

lf2 <- lf1 %>%
  filter(elev.ft.NAVD88 >= 1000)

#calculate new values
lf2 <- lf1 %>%
  mutate(date = as_date(date)) %>%
  mutate(year = year(date)) %>%
  mutate(datum.shift = (elev.ft.NAVD88-elev.ft.NGVD29))

#some basic aggregation
lf2 <- lf1 %>%
  group_by(dowlknum, pw_basin_name) %>%
  summarize(min.ft=min(elev.ft.NAVD88),
            mean.ft=mean(elev.ft.NAVD88),
            max.ft=mean(elev.ft.NAVD88)) %>%
  arrange(pw_basin_name)

View(lf2)

#pipe many functions together----
lf2 <- lf1 %>%
  select(pw_basin_name, date, elev.ft.NAVD88, elev.ft.NGVD29) %>%
  pivot_longer(c(elev.ft.NAVD88, elev.ft.NGVD29),
               names_to="variable",
               values_to="value") %>%
  filter(pw_basin_name == "Silver") %>%
  mutate(date=as_datetime(date)) %>%
  mutate(year=year(date)) %>%
  group_by(pw_basin_name, year, variable) %>%
  summarize(ann.min=min(value),
            ann.mean=mean(value),
            ann.max=max(value)) %>%
  arrange(year) %>%
  pivot_longer(c(ann.min, ann.mean, ann.max),
               names_to="stat",
               values_to="value") %>%
  pivot_wider(names_from=variable,
              values_from=value)

View(lf2)

#intro to lists and working with multiple files----

#write lake data into separate files after splitting
ls1 <- group_split(lf1, pw_basin_name) #splits dataframe into a list of tibbles
key <- group_keys(lf1, pw_basin_name) #explains the grouping structure

class(ls1)
head(ls1) #returns first six elements - for a list returns first six tibbles
length(ls1)
length(unique(lf1$pw_basin_name))

class(ls1[[1]])
head(ls1[[1]])
length(ls1[[1]])

names(ls1) <- key$pw_basin_name

dir.create("~/lakefindersplit")
setwd("~/lakefindersplit")

for (i in names(ls1)){
  write.table(ls1[[i]], str_glue("LakeFinderData_{i}.csv"), sep=",")
}

#read lake data from separate files and combine----
file.names <- list.files(getwd(), pattern=".csv$")

print(file.names)

ls2 <- lapply(file.names, read.csv)
ls2 <- lapply(file.names, read.table, sep=",", header=T)

head(ls2[[1]])

lf2 <- bind_rows(ls2) #a dplyr function
class(lf2)
head(lf2)
tail(lf2)

#exercises----
#play around with this data some more
covid19 <- readRDS("COVID19_US_States_Data.rds")

#building on last week, see if you can:
# 7. create some new data columns using mutate()
# 8. subset some data using filter() and select() 
# 9. perform some aggregation using group_by() and summarize()
# 10. build a pipeline that, all in one function:
## a. summarizes the data on positive tests from each state by month
## b. pivots the dataset so each value column represents the statistic for one month
covid19.tidy <- covid19 %>%
  select(gb_win00, gb_win04, obama_win08, obama_win12, positive_increase.norm, date, state) %>%
  rename("test.date"="date") %>%
  pivot_longer(cols=c(-test.date, -positive_increase.norm, -state),
               names_to="election.year",
               values_to="election.winner") %>%
  mutate(election.year=as_factor(election.year)) %>%
  mutate(election.year=recode(election.year, 
                     "gb_win00"="2000", 
                     "gb_win04"="2004",
                     "obama_win08"="2008",
                     "obama_win12"="2012")) %>%
  mutate(election.winner=recode(election.winner,
                       "Gore win"="Gore",
                       "Kerry win"="Kerry",
                       "Bush win"="Bush",
                       "McCain win"="McCain",
                       "Obama win"="Obama",
                       "No"="Romney",
                       "Yes"="Obama")) %>%
  mutate(test.month=month.abb[month(test.date)]) %>%
  group_by(state, election.year, election.winner, test.month) %>%
  summarize(mean.pos.inc=mean(positive_increase.norm)) %>%
  filter(!(test.month %in% c("Jan", "Feb"))) %>%
  pivot_wider(names_from=test.month,
              values_from=mean.pos.inc) %>%
  select(state, election.year, election.winner, Mar, Apr, May, Jun, Jul)
