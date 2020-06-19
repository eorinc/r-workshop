#working with strings----
alphabet <- letters #letters a vector that is part of the base R library
length(alphabet)
nchar(alphabet)

ALPHABET <- toupper(alphabet)
alphabet <- tolower(ALPHABET)

abc <- "abc"
length(abc)
nchar(abc)

tebahpla <- rev(alphabet)

#install.packages("stringr")
library(stringr)
#https://evoldyn.gitlab.io/evomics-2018/ref-sheets/R_strings.pdf

#change working directory
setwd("/home/rstudio/r-workshop/data")

#load lake finder data
lf1 <- read.table("lakefinderdata.csv", sep=",", header=T, stringsAsFactors=F)

lakes <- unique(lf1$pw_basin_name)

#concatenation
str_c(lakes, "Lake", sep=" ")

#splitting
str_split(lakes, " ")

#subsetting
str_sub(lakes, 1, 5) 
str_sub(lakes, 1, -5)
str_sub(lakes, -5, -1)
str_subset(lakes, "Twin")

#pattern matching
str_detect(lakes, "Unnamed")
str_count(lakes, "School")

#replacement
str_replace(lakes, "Twin", "Gemini")
str_replace(lakes, "n", "p")
str_replace_all(lakes, "n", "p")

#convert expressions to strings
str_glue("Pi is {pi}")
str_glue("Don't forget about July {2^2}th")

#working with factors----
lf1 <- read.table("lakefinderdata.csv", sep=",", header=T, stringsAsFactors=F)

#examine the unique strings
lakes <- unique(lf1$pw_basin_name)
print(lakes)
levels(lakes)

#convert to factors
lakes <- as.factor(lakes) #aside: converting from one data type to another is called "coercion"
print(lakes)
levels(lakes)

#now try on the non-unique values
lakes <- as.factor(lf1$pw_basin_name)
length(lakes)
levels(lakes)

#changing level values
levels(lakes)[1] <- "Big Mouth Billy Bass"
levels(lakes)
lakes[str_detect(lakes,"Big Mouth")]
levels(lakes)[1] <- "Bass"
levels(lakes)

#see it in action
#install.packages("ggplot2")
library(ggplot2)

lf2 <- lf1
lf2$pw_basin_name <- as.factor(lf2$pw_basin_name)

ggplot(lf2, aes(x=pw_basin_name, y=elev.ft.NGVD29)) +
  geom_boxplot() +
  theme(axis.text.x = element_text(angle = 45, hjust=1))

#add "Lake" to all lake names
#strings
lf1$pw_basin_name <- str_c(lf2$pw_basin_name, "Lake", sep=" ")

#factors
levels(lf2$pw_basin_name) <- str_c(levels(lf2$pw_basin_name), "Lake", sep=" ")  

ggplot(lf2, aes(x=pw_basin_name, y=elev.ft.NGVD29)) +
  geom_boxplot() +
  theme(axis.text.x = element_text(angle = 45, hjust=1))

#change 'Unnamed (Kismet Basin) Lake' to 'Kismet Basin'
#strings
replace.these <- lf1$pw_basin_name=="Unnamed (Kismet Basin) Lake"
lf1$pw_basin_name[replace.these] <- "Kismet Basin"

ggplot(lf1, aes(x=pw_basin_name, y=elev.ft.NGVD29)) +
  geom_boxplot() +
  theme(axis.text.x = element_text(angle = 45, hjust=1))

#factors
replace.these <- levels(lf2$pw_basin_name)=="Unnamed (Kismet Basin) Lake"
levels(lf2$pw_basin_name)[replace.these] <- "Kismet Basin"

ggplot(lf2, aes(x=pw_basin_name, y=elev.ft.NGVD29)) +
  geom_boxplot() +
  theme(axis.text.x = element_text(angle = 45, hjust=1))

#note that the order of the factors doesn't change, but the order of the strings does

#this chunk of code just creates some crappy data
library(lubridate)
lf1 <- subset(lf1, year(date) >= 2016)
lf1a <- subset(lf1, round(lf1$elev.ft.NGVD29*100, 0) %% 2 == 0)
lf1b <- subset(lf1, round(lf1$elev.ft.NGVD29*100, 0) %% 2 == 1)
lf1b$pw_basin_name[lf1b$pw_basin_name == "Bass Lake"] <- "Bsas Lake"

lf3 <- rbind(lf1a, lf1b)
lf3$pw_basin_name <- as.factor(lf3$pw_basin_name)
unique(lf3$pw_basin_name)

ggplot(lf3, aes(x=pw_basin_name, y=elev.ft.NGVD29)) +
  geom_boxplot() +
  theme(axis.text.x = element_text(angle = 45, hjust=1))

levels(lf3$pw_basin_name)

levels(lf3$pw_basin_name)[4] <- "Bass Lake"

ggplot(lf3, aes(x=pw_basin_name, y=elev.ft.NGVD29)) +
  geom_boxplot() +
  theme(axis.text.x = element_text(angle = 45, hjust=1))

#exercises----
#play around with this data that I compiled for you
covid19 <- readRDS("COVID19_US_States_Data.rds")

#sources:
#https://cran.r-project.org/web/packages/poliscidata/poliscidata.pdf
#https://cran.r-project.org/web/packages/covid19us/covid19us.pdf

#try to:
#(a) summarize and inspect it
#(b) subset it
#(c) calculate some statistics for individual variables
#(d) change the levels of some factors (example: change obama_win08 and obama_win12 so they are consistent)
#(e) create a histogram or two
#(f) make a plot and post it in #coding before next Wednesday

#this will get you started (since we haven't covered plotting yet)
library(ggplot2)
ggplot(covid19, aes(x=date, y=positive_increase.norm, color=gay_policy)) +
  geom_smooth() +
  xlab(NULL) +
  ylab("Daily increase in positive tests per 100,000 population (2010)") +
  scale_color_discrete(name="Gay Policy")
