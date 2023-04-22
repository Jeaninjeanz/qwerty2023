library(ggplot2)
library(zoo)
library(quantmod)
library(xts)
library(PerformanceAnalytics)
library(rugarch)

#source("qwerty.R")

#print(period_predict)
#Getting data

garch_prediction <- function(period_predict, stock_name) {
  #getSymbols(stock_name,from = "2011-01-01",to = "2021-03-31")
  chartSeries(stock_object)
  
  
  
  stockData <- stock_object$stock_object.Close
  
  
  #Calculate Daily returns and remove null
  
  stockData <- na.omit(stockData)
  return <- CalculateReturns(stock_close)
  return <- return[-1]
  return <- na.omit(return)
  
  
  autoplot(return)
  
  
  #find lowest AIC value (Akaike)
  
  s1 <- ugarchspec(variance.model=list(model="sGARCH",garchOrder=c(1,1)),
                   mean.model=list(armaOrder=c(0,0)),distribution.model="norm")
  m1 <- ugarchfit(data = return, spec = s1)
  m1
  
  
  
  s2final <-  ugarchspec(variance.model=list(model="sGARCH",garchOrder=c(1,2)),
                         mean.model=list(armaOrder=c(2,2)),distribution.model="norm")
  m2final <- ugarchfit(data = return, spec = s2final)
  f <- ugarchforecast(fitORspec = m2final, n.ahead = period_predict)
  plot(fitted(f))
  
  
  
  
  sfinal <- s1
  setfixed(sfinal) <- as.list(coef(m1))
  sim <- ugarchpath(spec = sfinal,
                    m.sim = 1,
                    n.sim = 1*period_predict,
                    rseed = 16)
  plot.zoo(fitted(sim))
  
  #Creating predictions:
    
  
  predictionForcast <- 410.10*apply(fitted(sim), 2, 'cumsum') + 410.10
  matplot(predictionForcast, type = "l", lwd = 3)
  
  return(predictionForcast)
}
