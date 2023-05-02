library(tidyverse)
library(dplyr)
library(readr)
library(lubridate)
library(ggplot2)
library(factoextra)
library(caret)

#load s&p data
sNpData <- read_csv("data/raw/all_stocks_5yrs.csv")

#cleaning
sNpData <- na.omit(sNpData)
sNpData$date <- ymd(sNpData$date)
fData <- drop_na(sNpData) 

#prepocessing
#finding the average price and creating a column
fData <- fData %>% mutate(averagePrice = (open+close)/2)

#count number of years in the dataset to make code neater + automation
fData <- fData %>% 
  group_by(Name) %>% 
  mutate(yearAvg = (sum(averagePrice))/(365.25*5)) %>% 
  mutate(yearVolumeAvg = (sum(volume))/(365.25*5))

#calculate the diff in average price, square the diff then sum the values
fData <- fData %>% 
  group_by(Name) %>% 
  mutate(averagePrice = sum(((averagePrice - yearAvg)^2))) %>% 
  mutate(averageVolume = sum(((volume - yearVolumeAvg)^2)))

#varience in price and volume
fData <- fData %>% 
  group_by(Name) %>% 
  mutate(varience = (averagePrice/(365.25*5))) %>% 
  mutate(volumeVarience = (averageVolume/(365.25*5)))

#standard deviation of price and volume
fData <- fData %>% 
  group_by(Name) %>% 
  mutate(SD = sqrt(varience)) %>% 
  mutate(SDvolume = sqrt(volumeVarience))

#statistical ranges
price_SD_Q1 <- summary(fData$SD)[2]
price_SD_mean <- summary(fData$SD)[4]
volume_SD_Q1 <- summary(fData$SDvolume)[2]
volume_SD_mean <- summary(fData$SDvolume)[4]

#manual classification
riskData <- fData %>% 
  mutate(riskClass = case_when(SD < price_SD_Q1  ~ "Low",
                               SD >= price_SD_Q1 && SD <= price_SD_mean ~ "Medium",
                               SD > price_SD_mean ~ "High")) %>% 
  mutate(riskClass = as.factor(riskClass)) %>% 
  mutate(Name = as.factor(Name))

riskData <- riskData %>%
  mutate(riskClasssd = case_when(SDvolume < volume_SD_Q1 ~ "Low",
                                 SDvolume > volume_SD_Q1 && SDvolume < volume_SD_mean ~ "Medium",
                                 SDvolume > volume_SD_mean  ~ "High")) %>%
  mutate(riskClasssd = as.factor(riskClasssd))

saveRDS(riskData,"data/cleaned/riskData.rds")

#historical company risk
riskData2 <- riskData %>% 
  mutate(riskClass = case_when(riskClass == "Low" ~ 1,
                               riskClass == "Medium" ~ 2,
                               riskClass == "High" ~ 3,
                               riskClasssd == "Low" ~ 1,
                               riskClasssd == "Medium" ~ 2,
                               riskClasssd == "High" ~ 3)) %>% 
  summarise(meancat = mean(riskClass), .groups = 'drop') %>% 
  mutate(category1 = case_when(meancat <= 1.5 ~ "Low", meancat < 2.5 ~ "Medium", meancat >= 2.5 ~ "High")) %>% 
  select(,-meancat)
riskData2

saveRDS(riskData2,"data/cleaned/CompaniesRisk.rds")
