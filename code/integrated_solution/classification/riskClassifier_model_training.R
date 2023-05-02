library(tidyverse)
library(caret)
library(doParallel)
library(modelsummary)

#load data
riskData <- read_rds("data/cleaned/riskData.rds")

#filter to 1/10th of dataset to save computing power <2013-08-15>
# riskData <- riskData  %>% 
#   filter(date < "2013-08-15")

#select data
riskData <- riskData %>% 
  select(open, high, low, close, volume, SD, SDVolume, riskClass)
riskData <- riskData[-1]

#setup preprocesses and create partitions
preProcess <- c("center","scale")
i <- createDataPartition(y = riskData$riskClass, p = 0.8, list = FALSE)
training_set <- riskData[i,]
test_set <- riskData[-i,]

#use parallel computing
registerDoParallel(cores = detectCores() - 1)

#train the model
trControl <- trainControl(method = "repeatedcv",number = 3,repeats = 3)
model <- train(riskClass ~ ., method='knn', data = training_set, metric='Accuracy',preProcess = preProcess, trControl=trControl)

#save the model
saveRDS(model, file="data/models/classifier.rds")