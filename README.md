# qwerty2023
Investment robo-advisor using financial, risk, machine learning and web framework libraries in R for the Discovery Gradhack 2023.

## time frame
43 hours

## team

- sarah ingram : web framework [team leader]
- daniel bockle : forecasting models and web framework
- sean morrison : data acquisition and exploratory data analytics 
- jean marx : github managemen and machine learning models

### TEAM NOTES
- create individual branches for any modifications to the code and/or file structure (compartmentalization)
- commit to main branch for modifications of readme
- commit to main branch for initial file commits
- branches can be made of all files directly or by editing individual files
- folder creation is fiddly, as git does not support empty folders. so to save a file within a subfolder of "qwerty2023", simply type the folder name into the file name to save the file within that new subfolder. eg. "/subfolder/file.txt"

# TO DO
- Front end integration, finalizing prototype and presentation slides
- diagrams of data flow revision & update
- github file management 


# Workplan
## Phase 1
- data acquisition, cleaning and preprocessing
- risk models
- front end (shiny) design

## Phase 2
- stock forecasting models 
- supervised machine learning models
- front-end, back-end integration and error checking of models

## Phase 3
- wrap up front-end, back-end integration 

# Data flow

1. [user] requests [recommendations] from [ai]
2. [ai] analyzes [stocks] using [user] criteria
3. [ai] produces [recommendations] for [user]

## User request parameters
- discovery-points/rands
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

# ui
- ???

# models
- risk classifier using supervised machine learning (knn)
- forecast models using the Generalized Autoregressive Conditional Heteroskedasticity model

# R libraries:
- QuantMod : quantitative trading models. data, charts, indicators  
- tidyverse
- caret
- ???
