library(shiny)
library(shiny.fluent)
library(imola)
library(stringr)
library(dplyr)
library(readr)
library(leaflet)
library(glue)
library(purrr)
library(shiny)
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

#quakes_data <- read_csv("data/quakes_may_2022.csv")
sNpData <- read.csv("all_stocks_5yr.csv")
top_six <- read.csv("selection.csv")
smallRiskData <- readRDS("fundemental.rds")
hard <- read.csv("hard.csv")

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
  div(
  #  selectInput("Fake-Select", label = "",
  #             choices = list("Trust" = 1), selected = 1),
             #  style = "width: 10%;"),
    actionButton("submitbutton", "LOG OUT", 
                class = "btn btn-primary",
                style = "border-radius: 2px; background-color: #004b8d; display: inline-bloack"),
    style = ""
  ),
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
  img(src = "family3.png", style = "height: 65%; margin-top: 44.7%; right: 150px; width: 100vw;
      position: absolute; left: -10px"),
  div(
    Text(variant = "xLarge", "Trust your future to Discovery", style="color: white; font-size: 5vh;"), 
            style = "position: absolute; top: -23%; left: 33%; font-size: 70vh;"),
  div(
    Text(variant = "medium", "Prepare for your and your loved ones' future by investing today", 
         style = "color: #292b2c; position: absolute; left: 21%; top: 90%; font-size: 4vh;"),
    Text(variant = "small", "Use your Vitality points or Discovery Bank account to invest in personalised portfolios created by Discovery's Artificial Intelligence Investment Model.", 
         style = "position: absolute; left: 7%; top: 98%; font-size: 2.6vh;")
  )
)

app_sidebar <- flexPanel( #flexPanel
  id = "sidebar",
  align_items = "center",
  style = "background-color: white; justify-content: center; width: 100vw; height: 200vh;",
  div(style = "background-color: #f5f5f5; position: absolute; height: 100vh; width: 100vw;
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
  #  style = "justify-content: center; margin-left: 40px; margin-top: 150vh; z-index: 950;
   #   border-top-style: solid; border-color: #292b2c; border-width: 1.5px;",
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
  #tags$label(h3('We would recommend...')) # Status/Output Text Box
  div(
    style = "position: absolute; top: 140vh; left: 2vw; background-color: white; z-index: 950; height: 65vh; width: 55vw;",
    verbatimTextOutput('contents'),
    tableOutput('tabledata') # Prediction results table
  )
)

app_footer <- flexPanel(
  id = "footer",
  style = "border-top-style: solid; border-color: #F5F5F5; border-width: 1.5px; margin-left: 40px"
)

# Updating ui content
#ui <- gridPage(
#  tags$head(tags$link(rel="stylesheet", href = "styles.css")),
#  template = "grail-left-sidebar",
  #grail-left-sidebar
 # gap = "10px",
#  rows = list(
#    default = "70px 1fr 30px"
#  ),
  
#  header = app_header,
 

  #sidebar = div("This is the sidebar", style = "background-color: blue;"),
  #content = div("This is the content", style = "background-color: green; float:right"),
#  content = app_content,
#  sidebar = app_sidebar,
#  footer = app_footer
  #footer = div("This is the footer", style = "background-color: yellow;")
#)

ui <- pageWithSidebar(
  
  # tags$head(
  # tags$style(HTML("*{ background-color: red; }"),
  #  ),
  # Page header
  headerPanel('DiscoveryTrust'),
  #headerPanel <- app_header,
 # headerPanel(app_header),
  
  
  # Input values
  #sidebarPanel(
    #HTML("<h3>Input parameters</h3>"),
    # tags$label(h3('Input parameters')),
   # radioButtons("Radio.Money", label = "",
   #              choices = list("Stocks" = 1), 
   #              inline = TRUE, selected = 1),
   # numericInput("Invest.Amount", 
   #              label = "How many stocks would you like to buy?", 
   #              value = 0),
   # selectInput("Risk.Category", label = "Choose a risk category",
   #             choices = list("Low Risk" = 1, "Medium Risk" = 2,
   #                            "High Risk" = 3), selected = 1),
   # selectInput("Prediction.Period", label = "Choose a prediction period",
   #             choices = list("1 year" = 1, "2 years" = 2,
   #                            "3 years" = 3, "4 years" = 4,
   #                            "5 years" = 5), selected = 1),
    
    #actionButton("submitbutton", "Recommendations", 
   #              class = "btn btn-primary")
  #),
 
 sidebarPanel(app_sidebar),
  
#  mainPanel(
#    tags$label(h3('We would recommend...')), # Status/Output Text Box
#    verbatimTextOutput('contents'),
#    tableOutput('tabledata') # Prediction results table
    
#  )
  mainPanel(app_content)
)

#############################################################################################

server<- function(input, output, session) {
  print("1boo")
  # Input Data
  datasetInput <- reactive({  
    print("hi")
    
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
    
    wa <- input$Invest.Amount
    print(2)
    #observeEvent(input$submitbutton) { doesnt work
      
   # print(input$Radio.Money)
    #validate(need(try(input$Radio.Money == 1 && input$Invest.Amount > 1345),
    #              "Error: value more than possessed points"))
   # validate(need(try(input$Invest.Amount > 1345), # | input$Radio.Money == 3 && input$Invest.Amount > 2768),
    #              "Error: value more than possessed waaa"))
            # need(try(as.integer(input$Radio.Money) == 3 && input$Invest.Amount > 2768),
             #                   "Error: value more than possessed Rands"))
    #validate(need(try(as.integer(input$Radio.Money) == 3 && input$Invest.Amount > 2768),
    #              "Error: value more than possessed Rands"))
    
   # validate(
   #   need(try(as.integer(input$Radio.Money) == 2 && as.integer(input$Invest.Amount > 1345)), "Error")
   # )
    
     # userPaymentSelection(input$Radio.Money, input$Invest.Amount)
      finalfinal <- userRiskSelection(input$Risk.Category)
      #userPaymentSelection(input$Radio.Money, input$Invest.Amount)
   # }
    # prediction(input$Prediction.Period, finalfinal)
    
    #finalfinal <- userRiskSelection(2)
    #prediction(1, finalfinal)
    #})
    #x <- "hello"
    # company_name <- "GOOG.GOOG"
    
    
    #period_predict <<- as.numeric(input$Prediction.Period) * 365
    #  print(period_predict)
    
    # Species <- 0
    # df <- rbind(df, Species)
    # input <- transpose(df)
    # write.table(input,"input.csv", sep=",", quote = FALSE, row.names = FALSE, col.names = FALSE)
    
    # test <- read.csv(paste("input", ".csv", sep=""), header = TRUE)
    
    # Output <- data.frame(Prediction=predict(model,test), round(predict(model,test,type="prob"), 3))
    # print(Output)
    
  })
  
  #userPaymentSelection <- function(P, V) {
 # }
#    print("ba")
#    if (P == 1) {
#     # print(11)
#    } else if (P == 2) {
#      print(22)
#      if (V > 1345) {
#        print(22222)
#        validate(need(try()))
#      }
#    } else if (P == 3) {
     # print(33)
#    }
#  }
  
  userRiskSelection <- function(S) {
    print("RISK")
    userSelection <- as.numeric(S)
    #userSelection = 2
    #finalSelection = "Medium"
    category2 <- smallRiskData$category1
    final_companies <<- data.frame(name = character(), stringsAsFactors = FALSE)
    
    if (userSelection == 1) {
      finalSelection = "Low"
    } else if (userSelection == 2) {
      finalSelection = "Medium"
    } else if (userSelection == 3) {
      finalSelection = "High"
    }
    
    
    # for (i in 1:length(hard)){
    
    #  if (finalSelection == category2[i]){
    # write.csv(smallRiskData$share[i], file = "filtered_company.csv", append = TRUE, row.name = TRUE)  
    # final_companies <- rbind(final_companies, smallRiskData$share[i])
    #  }
    # }

    
  #  test <- hard %>% 
   # df2 <- hard[order(hard$difference, decreasing = TRUE),]
    
    hard <- read.csv("hard.csv")
    
    hard <- hard %>% 
      filter(hard$risk == finalSelection)  
      
    hard <- hard[order(hard$difference, decreasing = TRUE),]
    
    #differenceHard <- summary(hard)[6,3]
    
    hard <- hard %>% 
      mutate(maxDiff = max(hard$difference)) %>% 
      #filter(hard$difference == maxDiff) %>% 
      #head(hard, 1) %>% 
      mutate(AmountDue = closing * 5) %>% 
      mutate(AmountMade = (difference * 5) - AmountDue) %>% 
      select(name, closing, risk, AmountDue, AmountMade)
    
    hard <- hard[1:3,]
    print(hard)
    #dbWriteTable(con, "qwerty_risk", final_companies, overwrite = TRUE)
    # result <- dbGetQuery(con, "SELECT * FROM qwerty_risk")
    return(hard)
    #companies
    #print(length(dim(hard)))
  }
  
  # DOUG CODE
  #test_object <<- getSymbols("GOOG",from = "2011-01-01",to = "2021-03-31", auto.assign = FALSE)
  
  #test_object <- as.data.frame(test_object)
  
  #test_object <- test_object %>% 
  #  dplyr::rename_with(.cols = 4, ~ "close") %>% 
  #  select(close)
  
 # test_object$date <- row.names(test_object)
  #test_xts <- xts(test_object$close, 
  #                order.by = as.POSIXct(test_object$date))
 # test_xts
  
  
  prediction <- function(P, final_companies) {
    print("PREDICT")
    period_predict <<- as.numeric(1) * 365 # !!!!
    
    for (i in 1:length(final_companies$X.AAPL.)) {
      # first <- top_six[2,]
      first <- final_companies[i,]
      stock_name <<- as.character(first)
      #  stock_name <<- "GOOG"
      stock_object <<- getSymbols(stock_name,from = "2011-01-01",to = "2021-03-31", auto.assign = FALSE)
      
      #stock_object <<- as.xts(first)
      # temp1 <- as.data.frame(stock_object)
      # stock_close <<- temp1 %>% select(4)
      stock_close <<- stock_object[,4]
      # concat <- ".Close"
      # concat_string <<- paste(stock_name, concat)
      # predictionResult <- garch_prediction(period_predict, stock_name)
      garch_prediction(period_predict, stock_name)
      predictionResult <- predictionDifference
      
      final_companies <- final_companies %>% 
        filter(final_companies[i,] == stock_name) %>% 
        mutate(Result = predictionResult)
      #if (as.character(final_companies[i,]) == stock_name) {
      print("hi")
      # mutate(data = final_companies, Result = predictionResult)
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
