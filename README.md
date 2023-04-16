# qwerty2023
Investment recommendations using financial, risk and machine learning libraries in R for the Discovery Gradhack 2023.

## data flow

1. [user] requests [recommendations]
2. [ai] analyzes [stock] using [user] criteria
3. [ai] produces [recommendations]

### user request parameters
- risk level
- saving goal
- time period
- investment history
- age
- total time to invest
- single/portfolio

### stock variables
- price/earnings
- beta
- dividend history
- dividend yield
- value
- return on investment
- return on portfolio

### recommendation variables
- stock
- company
- sector
- price
- holding period return


## r libraries:
QuantMod : quantitative trading models. data, charts, indicators  
PortfolioAnalytics : portfolio optimization wrt specific user criteria
PortfolioAnalytics's PerformanceAnalytics : portfolio returns
DerivMkts : volatility 
PeerPerformance : pairwise analysis of held investments vs peers
Risk : 26 financial risk measures
