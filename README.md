# qwerty2023
investment robo-advisor using financial, risk, supervised machine learning and web framework libraries in R for the discovery gradhack 2023.

## team

- sarah ingram : web framework [team leader]
- daniel bockle : forecasting models and web framework
- sean morrison : data acquisition and exploratory data analysis 
- jean marx : github management and machine learning models

## initial time frame
Friday 15:00 - Sunday 11:00
[43 hours]

## secondary time frame
24 April - 5 May
[2 weeks] 

### team notes
- commit to main branch for modifications of readme
- commit to main branch for initial file commits
- branches can be made of all files directly or by editing individual files
- folder creation is fiddly, as git does not support empty folders. so to save a file within a subfolder of "qwerty2023", simply type the folder name into the file name to save the file within that new subfolder. eg. "/subfolder/file.txt"

# game-plan
## final presentation
### phase 1
- problem definitions of overhauls
- datasets acquisition

### phase 2
- risk and forecast overhaul
- UI overhaul 

### phase 3
- front end, back end integration 
- presentation

## discovery gradhack weekend
### phase 1
- data acquisition, cleaning and preprocessing
- risk models
- front end design

### phase 2
- stock forecasting models 
- supervised machine learning models
- front-end, back-end integration and error checking of models

### phase 3
- wrap up front-end, back-end integration 

# data flow

1. [user] requests [recommendations] from [ai]
2. [ai] analyzes [stocks] using [user] criteria
3. [ai] produces [recommendations] for [user]

## user request parameters
- discovery-points/rands
- amount
- risk level
- prediction period

## stock variables
- open
- high
- low
- close
- std deviation (volatility)
- volume
- CURRENT RATIO
- PRICE EARNINGS RATIO
- RETURN ON INVESTED CAPITAL
- TOTAL DEBT TO TOTAL ASSET
- TOTAL DEBT TO TOTAL EQUITY
- RETURN ON ASSET RATIO

## recommendation output
- stock(s)
- company info *
- stock info *
- risk level

# models
- risk classifier using repeated cross-validation (k-nearest neighbours) for fundamental and technical data
- forecast models using the Generalized Autoregressive Conditional Heteroskedasticity (GARGCH) model

# R libraries:
- tidyverse
- lubridate
- ggplot2
- factoextra
- caret
- caretEnsemble
- zoo
- quantmod
- xts
- PerformanceAnalytics
- rugarch
- grid
- scales
- tseries
- caTools
- forecast
- shiny
- data.table
- RPostgresSQL
- DBI
