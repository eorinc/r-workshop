library(tidyverse)
library(lubridate)
library(ggplot2) #not necessary if loading tidyverse first, but for demonstration purposes...

# IMPORTANT SYNTAX NOTE: 
# ggplot2 uses the "+" operator instead of the "%>%" pipe operator used by the rest of the tidyverse.
# This is mostly because ggplot2 predates the tidyverse, but also because "+" works a little differently.
# Some folks would like to see "%>%" supported by ggplot2, but it is a mature package so don't hold your breath.

setwd("/home/rstudio/r-workshop/data")

lf1 <- read_csv("lakefinderdata.csv") %>%
  mutate(pw_basin_name=as_factor(pw_basin_name))

# Intro to dplyr----
# First, for contrast, some plotting with the base R functions
lf1.loon <- subset(lf1, pw_basin_name=="Loon")
plot(lf1.loon$elev.ft.NAVD88~lf1.loon$date, type="p")

plot(lf1.loon$elev.ft.NAVD88~lf1.loon$date, type="l")

plot(lf1.loon$elev.ft.NAVD88~lf1.loon$date, type="b", lty=1, pch=1)
points(lf1.loon$elev.ft.NGVD29~lf1.loon$date, type="b", col="red", lty=2, pch=2)
legend(x="bottomleft", 
       legend=c("elev.ft.NAVD88", "elev.ft.NGVD29"), 
       col=c("black", "red"), 
       lty=c(1,2), 
       pch=c(1,2))

# Now using ggplot2
# qplot ("quick plot") example
qplot(lf1.loon$date, lf1.loon$elev.ft.NAVD88, geom=c("point", "line"))

# first make tidy data
lf2.loon <- lf1.loon %>% 
  select(date, elev.ft.NGVD29, elev.ft.NAVD88) %>%
  pivot_longer(cols=-date, names_to="variable", values_to="values")

View(lf2.loon)

ggplot(lf2.loon, aes(x=date, y=values, color=variable)) +
  geom_line()

# Add points
ggplot(lf2.loon, aes(x=date, y=values, color=variable)) +
  geom_line() +
  geom_point()

# Change scales
ggplot(lf2.loon, aes(x=date, y=values, color=variable)) +
  geom_line() +
  geom_point() +
  scale_x_date(name=NULL, breaks="10 years", date_labels="%Y-%m")

# We can save plots as objects
my.plot <- ggplot(lf2.loon, aes(x=date, y=values, color=variable)) +
  geom_line() +
  geom_point() +
  scale_x_date(name=NULL, breaks="10 years", date_labels="%Y-%m") +
  scale_y_continuous(name="Elevation (ft)") +
  scale_color_discrete(name="Variable Name") +
  ggtitle("My Incredible Plot")

print(my.plot)

# Plots----
# Make some tidy data
lf2 <- lf1 %>%
  select(pw_basin_name, date, elev.ft.NAVD88) %>%
  filter(str_detect(str_to_lower(pw_basin_name), "unnamed", negate=T)) %>%
  separate(date, c("year", "month", "mday")) %>%
  mutate(month=as.numeric(month)) %>%
  mutate(month=factor(month.abb[month], levels=c(month.abb[1:12])))

View(lf2)

# Scatter plot
lf3 <- lf2 %>%
  filter(pw_basin_name %in% c("Loon", "Silver")) %>%
  pivot_wider(names_from=pw_basin_name, values_from=elev.ft.NAVD88)

ggplot(lf3, aes(x=Loon, y=Silver, color=year)) +
  geom_point()

# Line plot with legend
lf3 <- lf2 %>%
  filter(pw_basin_name %in% c("Loon", "Silver")) %>%
  group_by(pw_basin_name, month) %>%
  summarize(elev.ft.NAVD88=mean(elev.ft.NAVD88))

ggplot(lf3, aes(x=month, 
                           y=elev.ft.NAVD88, 
                           group=pw_basin_name, 
                           color=pw_basin_name)) +
  geom_line() +
  scale_x_discrete(name=NULL) +
  scale_y_continuous(name="Elevation (ft, NAVD88)")

# Bar plot with legend
lf3 <- lf2 %>%
  filter(pw_basin_name %in% c("Loon", "Silver")) %>%
  group_by(pw_basin_name, month) %>%
  summarize(range=diff(range(elev.ft.NAVD88)))

ggplot(lf3, aes(x=month, 
                           y=range, 
                           fill=pw_basin_name)) +
  geom_bar(stat="identity", position="dodge") +
  scale_x_discrete(name=NULL) +
  scale_y_continuous(name="Elevation (ft, NAVD88)") +
  scale_fill_discrete(name="Lake")

# Smoothed conditional means
ggplot(subset(lf1, pw_basin_name %in% c("Loon", "Silver")), 
                         aes(x=date, 
                             y=elev.ft.NAVD88, 
                             color=pw_basin_name)) +
  geom_smooth() +
  scale_x_date(name=NULL) +
  scale_y_continuous(name="Elevation (ft, NAVD88)") +
  scale_color_discrete(name="Lake")

# Histogram
lf3 <- lf2 %>%
  filter(pw_basin_name %in% c("Loon") & year >= 2000)

ggplot(lf3, aes(x=elev.ft.NAVD88, fill=year)) +
  geom_histogram()

# Dot plot
ggplot(lf3, aes(x=elev.ft.NAVD88)) +
  geom_dotplot()

# Box plot
lf3 <- lf2 %>%
  filter(pw_basin_name %in% c("Plaisted") & year >= 2000)

ggplot(lf3, aes(x=year, y=elev.ft.NAVD88)) +
  geom_boxplot() +
  scale_x_discrete(name=NULL) +
  scale_y_continuous(name="Elevation (ft, NAVD88)")

# Violin plot
ggplot(lf3, aes(x=year, y=elev.ft.NAVD88)) +
  geom_violin() +
  scale_x_discrete(name=NULL) +
  scale_y_continuous(name="Elevation (ft, NAVD88)")

# Box plot with facet wrap
lf3 <- lf2 %>%
  filter(pw_basin_name %in% c("Loon", "Silver") & year >= 2000)

ggplot(lf3, aes(x=year, y=elev.ft.NAVD88)) +
  geom_boxplot() +
  facet_wrap(~pw_basin_name, scales="free_y", nrow=2) +
  scale_x_discrete(name=NULL) +
  scale_y_continuous(name="Elevation (ft, NAVD88)")

# Themes----
lf3 <- lf2 %>%
  filter(pw_basin_name %in% c("Loon", "Silver")) %>%
  pivot_wider(names_from=pw_basin_name, values_from=elev.ft.NAVD88)

ggplot(lf3, aes(x=Loon, y=Silver)) +
  geom_point() +
  theme_grey() #default

ggplot(lf3, aes(x=Loon, y=Silver)) +
  geom_point() +
  theme_bw()

ggplot(lf3, aes(x=Loon, y=Silver)) +
  geom_point() +
  theme_light()

ggplot(lf3, aes(x=Loon, y=Silver)) +
  geom_point() +
  theme_dark()

ggplot(lf3, aes(x=Loon, y=Silver)) +
  geom_point() +
  theme_minimal()

ggplot(lf3, aes(x=Loon, y=Silver)) +
  geom_point() +
  theme_classic()

ggplot(lf3, aes(x=Loon, y=Silver)) +
  geom_point() +
  theme_void()

# Teaser: interactive/dynamic charts using plotly
library(plotly)

lf3 <- lf2 %>%
  filter(pw_basin_name %in% c("Loon", "Silver") &
           year %in% c(2000:2019) & 
           month %in% c("May", "Jun", "Jul", "Aug", "Sep", "Oct"))

gg <- ggplot(lf3, aes(x=pw_basin_name, y=elev.ft.NAVD88, fill=pw_basin_name)) +
  geom_boxplot(aes(frame=year)) +
  theme_dark()

ggplotly(gg)

lf4 <- lf3 %>%
  group_by(pw_basin_name, year, month) %>%
  summarize(elev.ft.NAVD88=mean(elev.ft.NAVD88))%>%
  pivot_wider(names_from=pw_basin_name, values_from=elev.ft.NAVD88) %>%
  drop_na()

# compare aes(frame=year) to facet_wrap(~year)
gg1 <- ggplot(lf4, aes(x=Loon, y=Silver, color=month)) +
  geom_point() +
  facet_wrap(~year, nrow=3) +
  theme_grey()

print(gg1)

gg2 <- ggplot(lf4, aes(x=Loon, y=Silver, color=month)) +
  geom_point(aes(frame=year)) +
  theme_grey()

ggplotly(gg2)

# adjust speed (frame) and method (easing) of transition
# frame default: 500 (milliseconds)
# easing default: cubic-in-out
ggplotly(gg2) %>%
  animation_opts(frame=1000,
                 easing="linear")
ggplotly(gg2) %>%
  animation_opts(frame=1000,
                 easing="sin")
ggplotly(gg2) %>%
  animation_opts(frame=1000,
                 easing="exp-in")
ggplotly(gg2) %>%
  animation_opts(frame=1000,
                 easing="exp-out")
ggplotly(gg2) %>%
  animation_opts(frame=1000,
                 easing="elastic")
ggplotly(gg2) %>%
  animation_opts(frame=1000,
                 easing="bounce")
ggplotly(gg2) %>%
  animation_opts(frame=1000,
                 easing="circle-out")

#exercises----
#play around with this data some more
covid19 <- readRDS("COVID19_US_States_Data.rds")

#building on last week, see if you can make a plot to satisfy your curiosity about this dataset

covid19.tidy <- covid19 %>%
  select(obama_win12, positive_increase.norm, date, state) %>%
  rename("test.date"="date") %>%
  pivot_longer(cols=c(obama_win12),
               names_to="election.year",
               values_to="election.winner") %>%
  mutate(election.year=as_factor(election.year)) %>%
  mutate(election.year=recode(election.year,
                              "obama_win12"="2012")) %>%
  filter(election.year=="2012") %>%
  mutate(election.winner=recode(election.winner,
                                "No"="Red States",
                                "Yes"="Blue States")) %>%
  mutate(test.month=month.abb[month(test.date)]) %>%
  filter(!(test.month %in% c("Jan", "Feb"))) %>%
  drop_na() %>%
  mutate(election.winner=as.character(election.winner)) %>%
  group_by(test.date, election.winner) %>%
  summarize(positive_increase.norm=mean(positive_increase.norm))

gg <- ggplot(covid19.tidy, aes(x=test.date, y=positive_increase.norm, color=election.winner)) +
  geom_point() +
  geom_smooth() +
  scale_color_manual(name=NULL, values=c("Blue", "Red")) +
  xlab(NULL) +
  ylab("Daily Increase in Positive Cases per 100,000")

ggp <- ggplotly(gg) %>%
  layout(legend = list(orientation = "h"))

print(ggp)
