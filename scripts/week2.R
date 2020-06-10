setwd("/home/rstudio/r-workshop/data")

#using read.table----
##from disk
lf1 <- read.table("lakefinderdata.csv", sep=",", header=T)

##from a url
url <- "https://raw.githubusercontent.com/eorinc/r-workshop/master/data/lakefinderdata.csv"
lf1 <- read.table(url, sep=",", header=T)

#using read.xlsx----
library(openxlsx)

##from disk
lf2 <- read.xlsx("lakefinderdata.xlsx", sheet=1)

##from a url
url <- "https://raw.githubusercontent.com/eorinc/r-workshop/master/data/lakefinderdata.xlsx"
lf2 <- read.xlsx(url, sheet=1)

#using readRDS----
##from diskurl
lf3 <- readRDS("lakefinderdata.rds")

##from a 
url <- "https://raw.githubusercontent.com/eorinc/r-workshop/master/data/lakefinderdata.rds"
lf3 <- readRDS(gzcon(url(url)))

#using RPostgreSQL----
library(rpostgis) #or library(RPostgreSQL)
pg = dbDriver("PostgreSQL")

username <- "testuser"
password <- rstudioapi::askForPassword("Please enter your password")

con = dbConnect(pg, user=username, password=password,
                host="orthanc.talbot.casa", port=5432, dbname="testdb")
lf4 <- dbReadTable(con, "lakefinderdata")

