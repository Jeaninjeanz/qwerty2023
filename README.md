# qwerty2023
Investment recommendations using financial, risk and machine learning libraries in R for the Discovery Gradhack 2023.

# PLEASE NOTE
- create individual branches for any modifications to the code and/or file structure (compartmentalization)
- commit to main branch for modifications of readme
- commit to main branch for initial file commits
- branches can be made of all files directly or by editing individual files
- folder creation is fiddly, as git does not support empty folders. so to save a file within a subfolder of "qwerty2023", simply type the folder name into the file name to save the file within that new subfolder. eg. "/subfolder/file.txt"

# TO DO
- find applicable data as a starting point

# Workplan
## Phase 1
- front end design through AWS
- data cleaning
- risk analysis models on Azure (?)

## Phase 2
- stock prediction models on Azure (?)
- finalize front end and link to back end
- integration and error checking

## Phase 3
- Additional faf


# Data flow

1. [user] requests [recommendations] from [ai]
2. [ai] analyzes [stock] using [user] criteria
3. [ai] produces [recommendations] for [user]

## User request parameters
- points/rands
- amount
- risk level
- prediction period

## Stock variables
- open
- high
- low
- close
- std deviation (volatility)
- volume
- price/cashflow
- return on invested capital
- quick ratio
- current ratio
- debt/assets + longterm
- debt/equity + longterm

## Recommendation output
- stock(s)
- recommended splits
- company info
- stock info
- risk level

# Financial models
- risk classifier using knn 
- forecast models

# R libraries:
- QuantMod : quantitative trading models. data, charts, indicators  
- PortfolioAnalytics : portfolio optimization wrt specific user criteria
- PortfolioAnalytics's PerformanceAnalytics : portfolio returns
