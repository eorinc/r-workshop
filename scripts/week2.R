#change working directory
setwd("/home/rstudio/r-workshop/data") #Linux
#setwd("V:/Talbot/13_Code/R/r-workshop/data") #Windows

#1 - using read.table----
##from disk
lf1 <- read.table("lakefinderdata.csv", sep=",", header=T)

##from a url
url <- "https://raw.githubusercontent.com/eorinc/r-workshop/master/data/lakefinderdata.csv"
lf1 <- read.table(url, sep=",", header=T)

#2 - using read.xlsx----
library(openxlsx)

##from disk
lf2 <- read.xlsx("lakefinderdata.xlsx", sheet=1)

##from a url
url <- "https://raw.githubusercontent.com/eorinc/r-workshop/master/data/lakefinderdata.xlsx"
lf2 <- read.xlsx(url, sheet=1)

#3 - using readRDS----
##from disk
lf3 <- readRDS("lakefinderdata.rds")

##from a url
url <- "https://raw.githubusercontent.com/eorinc/r-workshop/master/data/lakefinderdata.rds"
lf3 <- readRDS(gzcon(url(url)))

#4 - using RPostgreSQL----
library(rpostgis) #or library(RPostgreSQL)

pg = dbDriver("PostgreSQL")

#save credentials as variables
username <- "testuser"
password <- rstudioapi::askForPassword("Please enter your password")

#create connection to database "testdb"
con = dbConnect(pg, user=username, password=password,
                host="post.talbot.casa", port=5432, dbname="testdb")

#list all tables in database "testdb"
dbListTables(con)

#read table "lakefinderdata"
lf4 <- dbReadTable(con, "lakefinderdata")

