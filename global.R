#global script to load and create the tree data
#load the tree csv that sits in data folder

library(dplyr)
library(lubridate)
library(DT)
library(htmltools)

allTrees <- read.csv("data/byzbomen.csv",stringsAsFactors = FALSE)
allTrees$latitude <- jitter(allTrees$latitude)    #use jitter to make the coordinates not too close together
allTrees$longitude <- jitter(allTrees$longitude)
row.names(allTrees) <- allTrees$ID  

#create categories of year planted for plotting purposes
allTrees$planted_category[allTrees$JAAR_VAN_AANPLANT>1850 & allTrees$JAAR_VAN_AANPLANT <= 1900] <- "1850-1900"
allTrees$planted_category[allTrees$JAAR_VAN_AANPLANT>1900 & allTrees$JAAR_VAN_AANPLANT <= 1950] <- "1901-1950"
allTrees$planted_category[allTrees$JAAR_VAN_AANPLANT>1950 & allTrees$JAAR_VAN_AANPLANT <= 2000] <- "1951-2000"
allTrees$planted_category[allTrees$JAAR_VAN_AANPLANT>2000] <-"2000-now"




#create a nice looking table for the table tap in the app
cleantable <- allTrees %>%
  select(
    ID = ID,
    Species = SORTIMENT,
    Type = TYPERING,
    Year = JAAR_VAN_AANPLANT,
    Street = STRAATNAAM,
    Town = WOONPLAATS,
    RD_Xcoord = RD_XCOORD,
    RD_Ycoord = RD_YCOORD,
    longitude = longitude,
    latitude = latitude
    
  )