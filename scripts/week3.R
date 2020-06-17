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

#exercises----
## (a) calculate the difference between NGVD29 and NAVD88 and store it as a new column of lf1


## (b) determine the number of rows in the data frame lf1


## (c) remove the data and elevation columns and store unique rows as a new data frame


## (d) examine the new data frame


## (e) figure out why there are still duplicate rows and remove them


# (f) remove the duplicate rows


## (g) write a for loop to do the same thing as (a)


## (h) plot the difference using the pw_basin_name as the x axis variable in a bar chart


## (i) figure out why it didn't work


## (j) use dowlknum instead (since it is unique)
## (hint: first convert dowlknum to a factor)


## (k) plot lat vs lon, lat vs diff, diff vs long...


