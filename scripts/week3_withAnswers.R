#change working directory
setwd("/home/rstudio/r-workshop/data") #Linux

#load lake finder data
lf1 <- read.table("lakefinderdata.csv", sep=",", header=T)

#examine the data
head(lf1)
View(lf1)
class(lf1$date)

#let's avoid factors for now (we'll discuss them next week)
lf1 <- read.table("lakefinderdata.csv", sep=",", header=T, stringsAsFactors=F) #string is synonymous with character
head(lf1)
class(lf1$date)

#indexing a data frame
lf1[1,] #first row
head(lf1) #first six rows
lf1[1:6,] #first six rows
lf1[,6] #sixth column
lf1$elev.ft.NGVD29 #sixth column
lf1[,(names(lf1) == "elev.ft.NGVD29")] #sixth column

#these will all return the same data 
#(i.e. the first six elements of the sixth column)
head(lf1[,6])
lf1[c(1,2,3,4,5,6),6]
lf1[1:6,6] 
lf1[1:6,][,6]
lf1[,6][1:6]
lf1$elev.ft.NGVD29[1:6] 
lf1[1:6,]$elev.ft.NGVD29
lf1[,(names(lf1) == "elev.ft.NGVD29")][1:6]
lf1[,which(names(lf1) == "elev.ft.NGVD29")][1:6]

#calculate the difference between NGVD29 and NAVD88 
diff <- lf1$elev.ft.NAVD88 - lf1$elev.ft.NGVD29

#using a loop instead
diff <- vector()
for (i in 1:nrow(lf1)){
  diff[i] <- lf1$elev.ft.NAVD88[i] - lf1$elev.ft.NGVD29[i]
}

#run time comparison----
library(lubridate)

#vectorized
then <- now()
diff <- lf1$elev.ft.NAVD88 - lf1$elev.ft.NGVD29
difftime(now(), then)

#for loop
then <- now()
diff <- vector()
for (i in 1:nrow(lf1)){
  diff[i] <- lf1$elev.ft.NAVD88[i] - lf1$elev.ft.NGVD29[i]
}
difftime(now(), then)

#exercises----
## (a) calculate the difference between NGVD29 and NAVD88 and store it as a new column of lf1
lf1$diff <- lf1$elev.ft.NAVD88 - lf1$elev.ft.NGVD29

## (b) determine the number of rows in the data frame lf1
nrow(lf1)

## (c) remove the data and elevation columns and store unique rows as a new data frame
lf2 <- lf1[,-c(2,6:7)]
lf3 <- unique(lf2)

## (d) examine the new data frame
class(lf3$diff)
nrow(lf3)
head(lf3)

## (e) figure out why there are still duplicate rows and remove them
lf3$dowlknum[1] == lf3$dowlknum[2]
lf3$pw_basin_name[1] == lf3$pw_basin_name[2]
lf3$Lat_DD[1] == lf3$Lat_DD[2]
lf3$Lon_DD[1] == lf3$Lon_DD[2]
lf3$diff[1] == lf3$diff[2]

# (f) remove the duplicate rows
lf3$diff <- round(lf3$diff,3)
lf3 <- unique(lf3)
nrow(lf3)
head(lf3)

## (g) write a for loop to do the same thing as (a)
lf1$diff <- NA #initialize a new column
for (i in 1:nrow(lf1)){
  lf1$diff[i] <- round(lf1$elev.ft.NAVD88[i] - lf1$elev.ft.NGVD29[i], 3)
}

## (h) plot the difference using the pw_basin_name as the x axis variable in a bar chart
barplot(lf3$diff~lf3$pw_basin_name)

## (i) figure out why it didn't work
print(lf3$pw_basin_name) #note the duplicate lake names ("Unnamed")

## (j) use dowlknum instead (since it is unique)
## (hint: first convert dowlknum to a factor)
lf3$dowlknum <- as.factor(as.character(lf3$dowlknum))
barplot(lf3$diff~lf3$dowlknum, col=lf3$dowlknum)
legend("bottom", legend=lf3$dowlknum, fill=lf3$dowlknum, ncol=4)

## (k) plot lat vs lon, lat vs diff, diff vs long...
plot(lf3$Lat_DD~lf3$Lon_DD)
plot(lf3$Lat_DD~lf3$diff)
plot(lf3$diff~lf3$Lon_DD)

