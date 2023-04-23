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

source("garch.R")

sNpData <- read.csv("all_stocks_5yr.csv")
top_six <- read_csv("selection.csv")
smallRiskData <- readRDS("fundemental.rds")
#conn <- odbcConnect("tcp:qwerty2023.database.windows.net", uid="saring", pwd="QwertyWins!", database="Qwerty_Risk") #, trusted_connection = FALSE)

#con <- dbConnect(odbc::odbc(),
 #                #Driver = "qwerty2023.database.windows.net",
  #               Server = "tcp:qwerty2023.database.windows.net",
   #              Database = "Qwerty_Risk",
    #             UID = "saring",
     #            PWD = "QwertyWins!")

#server <- "tcp:qwerty2023.database.windows.net"
#database <- "Qwerty_Risk"
#user <- "saring"
#password <- "QwertyWins!"

#dbhandle <- odbcDriverConnect('driver={SQL Server};server=qwerty2023.database.windows.net;uid=saring;pwd=QwertyWins!;database=Qwerty_Risk;trusted_connection=true')

# Construct the connection string
#connStr <- paste0("Driver={SQL Server};",
 #                 "Server=", server, ";",
 #                 "Database=", database, ";",
 #                 "Uid=", user, ";",
 #                 "Pwd=", password, ";",
 #                 "Encrypt=yes;TrustServerCertificate=no;Connection Timeout=30;")

# Establish a connection
#conn <- odbcDriverConnect(connStr)

tryCatch({
#  drv <- dbDriver("PostgreSQL")
  print("Connecting to Database…")
  con <- dbConnect(PostgreSQL(),
                   dbname = "qwerty",
                   host = "localhost",
                   port = 5432,
                   user = "postgres",
                   password = "root")
  print("Database Connected!")
})

# write csv into postgresql table
all_companies <- read.csv("all_stocks_5yr.csv")
dbWriteTable(con, "all_companies", all_companies, overwrite = TRUE)

result <- dbGetQuery(con, "SELECT * FROM all_companies")


# write risk csv into postgresql table
#qwerty_risk <- read.csv("companyForecast.csv")
#dbWriteTable(con, "qwerty_risk", qwerty_risk, overwrite = TRUE)

#result <- dbGetQuery(con, "SELECT * FROM qwerty_risk")

# UI
ui <- pageWithSidebar(
  
 # tags$head(
 # tags$style(HTML("*{ background-color: red; }"),
#  ),
  # Page header
  headerPanel('DiscoveryTrust'),
  
  # Input values
  sidebarPanel(
    #HTML("<h3>Input parameters</h3>"),
   # tags$label(h3('Input parameters')),
    radioButtons("Radio.Money", label = "",
                 choices = list("Discovery Points" = 1,
                                "Rands" = 2), 
                 inline = TRUE, selected = 1),
    numericInput("Invest.Amount", 
                 label = "Amount to invest", 
                 value = 1000.00),
    selectInput("Risk.Category", label = "Choose a risk category",
               choices = list("Low Risk" = 1, "Medium Risk" = 2,
                              "High Risk" = 3), selected = 1),
    selectInput("Prediction.Period", label = "Choose a prediction period",
               choices = list("1 year" = 1, "2 years" = 2,
                              "3 years" = 3, "4 years" = 4,
                              "5 years" = 5), selected = 1),
    
    actionButton("submitbutton", "Recommendations", 
                 class = "btn btn-primary")
  ),
  
  mainPanel(
    tags$label(h3('We would recommend...')), # Status/Output Text Box
    verbatimTextOutput('contents'),
    tableOutput('tabledata') # Prediction results table
    
  )
)


####################################
# Server                           #
####################################

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
    
      userRiskSelection(input$Risk.Category)
      prediction(input$Prediction.Period)
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
  
  userRiskSelection <- function(S) {
   # userSelection <- as.numeric(S)
    userSelection = 2
    finalSelection = "Low"
    category2 <- smallRiskData$category1
    final_companies <<- data.frame(name = character(), stringsAsFactors = FALSE)
    
    if (userSelection == 1) {
      finalSelection = "Low"
    } else if (userSelection == 2) {
      finalSelection = "Medium"
    } else if (userSelection == 3) {
      finalSelection = "High"
    }
    
    for (i in 1:length(category2)){
      if (finalSelection == category2[i]){
      # write.csv(smallRiskData$share[i], file = "filtered_company.csv", append = TRUE, row.name = TRUE)  
        final_companies <- rbind(final_companies, smallRiskData$share[i])
      }
    }
    
    dbWriteTable(con, "qwerty_risk", final_companies, overwrite = TRUE)
   # result <- dbGetQuery(con, "SELECT * FROM qwerty_risk")
    
  }
  
  prediction <- function(P) {
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
        if (final_companies[i,] == stock_name) {
          mutate(data = final_companies, Result = c(predictionResult))
        }
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

####################################
# Create the shiny app             #
####################################
shinyApp(ui = ui, server = server)
