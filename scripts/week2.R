setwd("~/r-workshop/data")

#using read.table
lf1 <- read.table("lakefinderdata.csv", sep=",", header=T)

#using read.xlsx
library(openxlsx)
lf2 <- read.xlsx("lakefinderdata.xlsx", sheet=1)

#using readRDS
lf3 <- readRDS("lakefinderdata.rds")

#using RPostgreSQL
library(rpostgis) #or library(RPostgreSQL)
pg = dbDriver("PostgreSQL")

username <- "testuser"
password <- rstudioapi::askForPassword("Please enter your password")

con = dbConnect(pg, user=username, password=password,
                host="orthanc.talbot.casa", port=5432, dbname="testdb")
lf4 <- dbReadTable(con, "lakefinderdata")


