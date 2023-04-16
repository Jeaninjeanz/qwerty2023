# qwerty2023
Investment recommendations using financial, risk and machine learning libraries in R for the Discovery Gradhack 2023.

## data flow

1. [user] requests [recommendations]
2. [ai] analyzes [stock] using [user] criteria
3. [ai] produces [recommendations]

### user request parameters
- risk level*
- age*
- required amount and rate of return*
- time period*
- payout preferences (weekly, monthly, yearly, end)*
- user's investment history
- single/portfolio*

### stock variables
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

### recommendation output
- stock(s)
- recommended splits
- recommended industries
- risk level

## financial models
- Relative Evaluation Model : price/earnings (dividend growth rates given)
- Dividend Discount Model : (current dividend amounts given)

## r libraries:
- QuantMod : quantitative trading models. data, charts, indicators  
- PortfolioAnalytics : portfolio optimization wrt specific user criteria
- PortfolioAnalytics's PerformanceAnalytics : portfolio returns
- DerivMkts : volatility 
- PeerPerformance : pairwise analysis of held investments vs peers
- Risk : 26 financial risk measures
