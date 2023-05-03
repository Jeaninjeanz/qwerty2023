library(shiny)
library(shiny.fluent)
library(imola)
library(stringr)
library(dplyr)
library(readr)
library(leaflet)
library(glue)
library(purrr)
library(data.table)
#library(RODBC)
#library(RMySQL)
library(RPostgreSQL)
library(DBI)
library(ggplot2)
library(zoo)
library(quantmod)
library(xts)
library(PerformanceAnalytics)
library(rugarch)
library(dplyr)
library(readr)

#############################################################################################
# not really needed

#quakes_data <- read_csv("data/quakes_may_2022.csv")
sNpData <- read.csv("all_stocks_5yr.csv")
top_six <- read.csv("selection.csv")
smallRiskData <- readRDS("fundemental.rds")
hard <- read.csv("hard.csv")

#############################################################################################
# Connect to DB

tryCatch({
  
  print("Connecting to Database…")
  con <- dbConnect(PostgreSQL(),
                   dbname = "qwerty",
                   host = "localhost",
                   port = 5432,
                   user = "postgres",
                   password = "root")
  print("Database Connected!")
  
})

#############################################################################################
# Load pre-processing into DB

# risk
#risk_data <- readRDS('FinalRisk.rds')
#risk_data <- as.data.frame(risk_data)

#dbWriteTable(con, "qwerty_risk", risk_data, overwrite = TRUE)

# prediction
#prediction_data <- readRDS('Complete_Data.rds')
#prediction_data <- as.data.frame(prediction_data) 

#dbWriteTable(con, "qwerty_prediction", prediction_data, overwrite = TRUE)

#############################################################################################
# Load DB into data frames

risky <- dbGetQuery(con, "SELECT * FROM qwerty_risk")

work <- dbGetQuery(con, "SELECT * FROM qwerty_prediction")

#dbDisconnect(con)

#############################################################################################
# UI

header_commandbar_list <- list(
  list(
    key = 'zoom_out', 
    iconProps = list(iconName = "Search")
  ),
  list(
    key = 'download',  
    iconProps = list(iconName = "Phone")
  )
)

app_header <- flexPanel(
  id = "header",
  align_items = "center",
  flex = c(0, 1, 0),
  style = "width: 95%;",
 # style = "border-bottom-style: solid; border-color: #F5F5F5; border-width: 1.5px; width: 90%;",
  img(src = "discover-logo1.png", style = "width: 150px; height: 100%; margin-left: 7%;"),
  div(
    Text(variant = "xLarge", "| Trust", style="color: #292b2c;"), 
    style = "margin-bottom: 10px; margin-top: 10px;"),
  CommandBar(items = header_commandbar_list),
 tags$hr(style = "width: 100%; position: absolute; top: 9%;"),

  div(
    Text(variant = "small", "HOME",
         style = "color: #292b2c; font-size: 2vh; position: absolute; right: 74.5vw; top: 14vh;"),
    Text(variant = "small", "BANK",
         style = "color: #292b2c; font-size: 2vh; position: absolute; right: 70vw; top: 14vh;"),
    Text(variant = "small", "MEDICAL AID",
         style = "color: #292b2c; font-size: 2vh; position: absolute; right: 62vw; top: 14vh;"),
    Text(variant = "small", "TRUST",
         style = "color: #292b2c; font-size: 2vh; position: absolute; right: 57.5vw; top: 14vh;
         border-bottom-style: solid; border-color: #004b8d; border-width: 1.5px;"),
    Text(variant = "small", "MORE HEALTH COVER",
         style = "color: #292b2c; font-size: 2vh; position: absolute; right: 46vw; top: 14vh;"),
    Text(variant = "small", "LIFE INSURANCE",
         style = "color: #292b2c; font-size: 2vh; position: absolute; right: 37vw; top: 14vh;"),
    Text(variant = "small", "INVESTMENTS",
         style = "color: #292b2c; font-size: 2vh; position: absolute; right: 29vw; top: 14vh;"),
    Text(variant = "small", "CAR AND HOME INSURANCE",
         style = "color: #292b2c; font-size: 2vh; position: absolute; right: 15vw; top: 14vh;"),
    Text(variant = "small", "VITALITY",
         style = "color: #292b2c; font-size: 2vh; position: absolute; right: 10vw; top: 14vh;"),
    Text(variant = "small", "TRAVEL",
         style = "color: #292b2c; font-size: 2vh; position: absolute; right: 5vw; top: 14vh;"),
  ),
 
  tags$hr(style = "width: 100%; position: absolute; top: 16%;"),
  img(src = "family3.png", style = "height: 65%; margin-top: 43.7%; right: 150px; width: 100vw;
      position: absolute; left: -10px"),
  div(
    Text(variant = "xLarge", "Trust your future to Discovery", style="color: white; font-size: 5vh;"), 
            style = "position: absolute; top: -23%; left: 33%; font-size: 70vh;"),
  div(
    Text(variant = "medium", "Prepare for your and your loved ones' future by investing today", 
         style = "color: #292b2c; position: absolute; left: 21%; top: 92%; font-size: 4vh;"),
    Text(variant = "small", "Use your Vitality points or Discovery Bank account to invest in personalised portfolios created by Discovery's Artificial Intelligence Investment Model.", 
         style = "position: absolute; left: 7%; top: 100%; font-size: 2.6vh;")
  )
)

app_sidebar <- flexPanel( #flexPanel
  id = "sidebar",
  align_items = "center",
  style = "background-color: white; justify-content: center; width: 100vw; height: 200vh;",
  div(style = "background-color: #f5f5f5; position: absolute; height: 110vh; width: 100vw;
      top: 120vh; left: 0; z-index: 900;"),
  div(
    Text(variant = "xLarge", "Welcome back,", 
         style = "color: #004b8d; position: absolute; left: 2vw; top: 130vh; z-index: 900; font-size: 3vh"),
    Text(variant = "xxLarge", "qwertywins@gmail.com", 
         style = "color: black; position: absolute; left: 5vw; top: 135vh; z-index: 900; font-size: 4vh"),
    div(
      Text(variant = "small", "1345 points", 
           style = "color: #004b8d; position: absolute; left: 13vw; top: 157vh; z-index: 900; font-size: 2.3vh"),
      Text(variant = "small", "R2768", 
           style = "color: #004b8d; position: absolute; left: 22vw; top: 157vh; z-index: 900; font-size: 2.3vh")
    )
    ),
  div(
    style = "z-index: 950; border-top-style: solid; border-color: #292b2c; border-width: 1.5px;
    left: 5vw; position: absolute; top: 161vh;",
    radioButtons("Radio.Money", label = "",
                 choices = list("Stocks" = 1, "Vitality Points" = 2, "Rands" = 3), 
                 inline = TRUE, selected = 1),
    numericInput("Invest.Amount", 
                 label = "How much would you like to invest?", 
                 value = 0),
    selectInput("Risk.Category", label = "Choose a risk category",
                choices = list("Low Risk" = 1, "Medium Risk" = 2,
                               "High Risk" = 3), selected = 1),
    selectInput("Prediction.Period", label = "Choose a prediction period",
                choices = list("1 year" = 1, "2 years" = 2,
                               "3 years" = 3, "4 years" = 4,
                               "5 years" = 5), selected = 1),
    
    actionButton("submitbutton", "Recommendations", 
                 class = "btn btn-primary",
                 style = "background-color: #004b8d;")
  )
)

app_content <- flexPanel(
  id = "content",
  style = "height: 200vh;",
  div(
    style = "position: absolute; top: 140vh; right: 5vw; background-color: white; z-index: 950; height: 65vh; width: 55vw;",
    verbatimTextOutput('contents'),
    tableOutput('tabledata'), # Prediction results table
    
  )
)

app_footer <- flexPanel(
  id = "footer",
  style = "border-top-style: solid; border-color: #F5F5F5; border-width: 1.5px; margin-left: 40px"
)

#############################################################################################

ui <- pageWithSidebar( 
  flexPanel(app_header),
  flexPanel(app_sidebar),
  flexPanel(app_content)
)

#############################################################################################

server<- function(input, output, session) {
  # Input Data
  datasetInput <- reactive({  
    
    df <- data.frame(
      Name = c("Currency",
               "Amount",
               "Risk",
               "Period"),
      Value = as.character(c(input$Radio.Money,
                             input$Invest.Amount,
                             input$Risk.Category,
                             input$Prediction.Period)),
      stringsAsFactors = FALSE)
    
    wa <<- input$Invest.Amount
    radioMoney <<- input$Radio.Money
    amount <<- input$Invest.Amount
    years <<- input$Prediction.Period
    
    if (input$Radio.Money == 2) {
      amount = as.integer(input$Invest.Amount) / 20;
    }
  
      finalfinal <- userRiskSelection(input$Risk.Category)
  })
  
  userRiskSelection <- function(S) {
    #finalSelection <- "Medium"
    userSelection <- as.numeric(S)
    final_companies <<- data.frame(name = character(), stringsAsFactors = FALSE)
    
    if (userSelection == 1) {
      finalSelection = "Low"
    } else if (userSelection == 2) {
      finalSelection = "Medium"
    } else if (userSelection == 3) {
      finalSelection = "High"
    }
    
    risky <- risky[1:6,]
    
    risky <- risky %>% 
      filter(categoryLevel == finalSelection) %>% 
      select(Name, categoryLevel)
    
    work <- work[, -1]
    
    ww <- data.frame()
    
    print(1234)
    for(i in 1:nrow(risky)) {       # for-loop over rows
      for (j in 1:nrow(work)) {
        if (work[j, 1] == risky[i, 1]) {
          ww <- rbind(ww, work[j,])
        } 
      }
    }
    
    work <- ww
    print(12345)
 
    if (radioMoney == 1) {  #stocks
      if (years == 1) {
        work <- work %>% 
          select(Name, Buy.in.Price, "1") %>% 
          mutate(AmountDue = Buy.in.Price * amount) 
        
        work$Difference <- (as.integer(work$"1") * amount)
        
        work <- work %>% 
          mutate(Difference = Difference - AmountDue)
        
      } else if (years == 2) {
        work <- work %>% 
          select(Name, Buy.in.Price, "2") %>% 
          mutate(AmountDue = Buy.in.Price * amount) 
        
        work$Difference <- (as.integer(work$"2") * amount)
        
        work <- work %>% 
          mutate(Difference = Difference - AmountDue)
        
      } else if (years == 3) {
        work <- work %>% 
          select(Name, Buy.in.Price, "3") %>% 
          mutate(AmountDue = Buy.in.Price * amount) 
        
        work$Difference <- (as.integer(work$"3") * amount)
        
        work <- work %>% 
          mutate(Difference = Difference - AmountDue)
        
      } else if (years == 4) {
        work <- work %>% 
          select(Name, Buy.in.Price, "4") %>% 
          mutate(AmountDue = Buy.in.Price * amount) 
        
        work$Difference <- (as.integer(work$"4") * amount)
        
        work <- work %>% 
          mutate(Difference = Difference - AmountDue)
        
      } else if (years == 5) {
        work <- work %>% 
          select(Name, Buy.in.Price, "5") %>% 
          mutate(AmountDue = Buy.in.Price * amount) 
        
        work$Difference <- (as.integer(work$"5") * amount)
        
        work <- work %>% 
          mutate(Difference = Difference - AmountDue)
        
      }
      colnames(work)[5] <- "Profit"
      
    } else if (radioMoney == 2) {  #points
      if (years == 1) {
        work <- work %>% 
          select(Name, Buy.in.Price, "1") %>% 
          mutate(Number.of.Stocks = floor(amount / Buy.in.Price)) %>% 
          mutate(AmountDue = Buy.in.Price * Number.of.Stocks)
        
        work$Difference <- as.integer(work$"1") * work$Number.of.Stocks
        
        work <- work %>% 
          mutate(Difference = Difference - AmountDue)
        
      } else if (years == 2) {
        work <- work %>% 
          select(Name, Buy.in.Price, "2") %>% 
          mutate(Number.of.Stocks = floor(amount / Buy.in.Price)) %>% 
          mutate(AmountDue = Buy.in.Price * Number.of.Stocks)
        
        work$Difference <- as.integer(work$"2") * work$Number.of.Stocks
        
        work <- work %>% 
          mutate(Difference = Difference - AmountDue)
        
      } else if (years == 3) {
        work <- work %>% 
          select(Name, Buy.in.Price, "3") %>% 
          mutate(Number.of.Stocks = floor(amount / Buy.in.Price)) %>% 
          mutate(AmountDue = Buy.in.Price * Number.of.Stocks)
        
        work$Difference <- as.integer(work$"3") * work$Number.of.Stocks
        
        work <- work %>% 
          mutate(Difference = Difference - AmountDue)
        
      } else if (years == 4) {
        work <- work %>% 
          select(Name, Buy.in.Price, "4") %>% 
          mutate(Number.of.Stocks = floor(amount / Buy.in.Price)) %>% 
          mutate(AmountDue = Buy.in.Price * Number.of.Stocks)
        
        work$Difference <- as.integer(work$"4") * work$Number.of.Stocks
        
        work <- work %>% 
          mutate(Difference = Difference - AmountDue)
        
      } else if (years == 5) {
        work <- work %>% 
          select(Name, Buy.in.Price, "5") %>% 
          mutate(Number.of.Stocks = floor(amount / Buy.in.Price))  %>% 
          mutate(AmountDue = Buy.in.Price * Number.of.Stocks)
        
        work$Difference <- as.integer(work$"5") * work$Number.of.Stocks
        
        work <- work %>% 
          mutate(Difference = Difference - AmountDue)
        
      }
      colnames(work)[6] <- "Profit"
      
    } else if (radioMoney == 3) {   #rands
      if (years == 1) {
        work <- work %>% 
          select(Name, Buy.in.Price, "1") %>% 
          mutate(Number.of.Stocks = floor(amount / Buy.in.Price))  %>% 
          mutate(AmountDue = Buy.in.Price * Number.of.Stocks)
        
        work$Difference <- as.integer(work$"1") * work$Number.of.Stocks
        
        work <- work %>% 
          mutate(Difference = Difference - AmountDue)
        
      } else if (years == 2) {
        work <- work %>% 
          select(Name, Buy.in.Price, "2") %>% 
          mutate(Number.of.Stocks = floor(amount / Buy.in.Price))  %>% 
          mutate(AmountDue = Buy.in.Price * Number.of.Stocks)
        
        work$Difference <- as.integer(work$"2") * work$Number.of.Stocks
        
        work <- work %>% 
          mutate(Difference = Difference - AmountDue)
        
      } else if (years == 3) {
        work <- work %>% 
          select(Name, Buy.in.Price, "3") %>% 
          mutate(Number.of.Stocks = floor(amount / Buy.in.Price))  %>% 
          mutate(AmountDue = Buy.in.Price * Number.of.Stocks)
        
        work$Difference <- as.integer(work$"3") * work$Number.of.Stocks
        
        work <- work %>% 
          mutate(Difference = Difference - AmountDue)
        
      } else if (years == 4) {
        work <- work %>% 
          select(Name, Buy.in.Price, "4") %>% 
          mutate(Number.of.Stocks = floor(amount / Buy.in.Price)) %>% 
        mutate(AmountDue = Buy.in.Price * Number.of.Stocks)
        
        work$Difference <- as.integer(work$"4") * work$Number.of.Stocks
        
        work <- work %>% 
          mutate(Difference = Difference - AmountDue) 
        
      } else if (years == 5) {
        work <- work %>% 
          select(Name, Buy.in.Price, "5") %>% 
          mutate(Number.of.Stocks = floor(amount / Buy.in.Price)) %>% 
          mutate(AmountDue = Buy.in.Price * Number.of.Stocks)
        
        work$Difference <- as.integer(work$"5") * work$Number.of.Stocks
        
        work <- work %>% 
          mutate(Difference = Difference - AmountDue) 
      }
        
      colnames(work)[6] <- "Profit"
    }
      
    hard <- work
    hard <- work[order(work$Profit, decreasing = TRUE),]
    
    return(hard)
  }

###############################################################################################
# Not used
    
  prediction <- function(P, final_companies) {
    period_predict <<- as.numeric(1) * 365 # !!!!
    
    for (i in 1:length(final_companies$X.AAPL.)) {
      first <- final_companies[i,]
      stock_name <<- as.character(first)
      stock_object <<- getSymbols(stock_name,from = "2011-01-01",to = "2021-03-31", auto.assign = FALSE)
      
      stock_close <<- stock_object[,4]
      garch_prediction(period_predict, stock_name)
      predictionResult <- predictionDifference
      
      final_companies <- final_companies %>% 
        filter(final_companies[i,] == stock_name) %>% 
        mutate(Result = predictionResult)
      
      rm(stock_object)
      rm(stock_name)
    }
  }
  
  # Status/Output Text Box
  output$contents <- renderPrint({
    if (input$submitbutton>0) { 
      isolate("Calculation complete.") 
    } else {
      return("Processing")
    }
  })
  
  # Prediction results table
  output$tabledata <- renderTable({
    if (input$submitbutton>0) { 
      isolate(datasetInput()) 
    } 
  })
  
  }


shinyApp(ui = ui, server = server)
#runApp(ui, server)

#dbDisconnect(con)
