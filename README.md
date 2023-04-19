# qwerty2023
Investment recommendations using financial, risk and machine learning libraries in R for the Discovery Gradhack 2023.

# PLEASE NOTE
- create individual branches for any modifications to the code and/or file structure (compartmentalization)
- commit to main branch for modifications of readme
- branches can be made of all files directly or editing individual files
- team to review and commit any changes made every 4 (?) hours to main branch 
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
- risk level*
- age*
- required amount and rate of return*
- time period*
- payout preferences (weekly, monthly, yearly, end)*
- user's investment history
- single/portfolio*

## Stock variables
- name *
- type (stocks, bonds, moneymarket instruments)*
- company
- intrinsic value of stock *
- market value of stock *
- intrinsic value of company
- market value of company
- price/earnings
- beta (systematic risk) *
- value
- return on investment
- return on portfolio
- historical divended yields
- historical company pay out ratio
- industry
- industry analysis

## Recommendation output
- stock(s)
- recommended splits
- recommended industries
- risk level

# Financial models
- Relative Evaluation Model : price/earnings (dividend growth rates given)
- Dividend Discount Model : (current dividend amounts given)

# R libraries:
- QuantMod : quantitative trading models. data, charts, indicators  
- PortfolioAnalytics : portfolio optimization wrt specific user criteria
- PortfolioAnalytics's PerformanceAnalytics : portfolio returns
- DerivMkts : volatility 
- PeerPerformance : pairwise analysis of held investments vs peers
- Risk : 26 financial risk measures
