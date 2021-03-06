#cronR job, runs every day
library(covid19us)
library(poliscidata)
library(tidyverse)

#import data----
##import daily data from the covid19us package
covid19.daily <- get_states_daily()
names(covid19.daily)[names(covid19.daily)=="state"] <- "abb"

##import states data from the poliscidata package
states.data <- states
states.data$state <- as.character(states.data$state)
states.data$state <- trimws(states.data$state)

##creating mapping of state names and abbreviations for joining the above datasets
states.abb <- data.frame(state=state.name[1:50], abb=state.abb[1:50])
states.abb$state <- sub(' ', '', states.abb$state)
states.join <- merge(states.data, states.abb, by="state")
states.join <- merge(states.join, covid19.daily, by="abb")
states.join$south <- factor(states.join$south, levels=c("South", "Nonsouth")) #reorder factor levels

##normalize positive tests and increase in positive tests by 2010 state population
states.join$positive.norm <- states.join$positive/states.join$pop2010 * 1E5
states.join$positive_increase.norm <- states.join$positive_increase/states.join$pop2010 * 1E5

saveRDS(states.join, "/home/rstudio/r-workshop/data/COVID19_US_States_Data.rds")