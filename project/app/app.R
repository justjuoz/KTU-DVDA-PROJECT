library(shiny)
library(shinydashboard)
library(tidyverse)
library(h2o)
library(ggplot2)

h2o.init()

# Define UI
ui <- dashboardPage(
  dashboardHeader(title = "Loan Approval Dashboard"),
  dashboardSidebar(
    sidebarMenu(
      menuItem("Input", tabName = "input"),
      menuItem("Results", tabName = "results"),
      menuItem("Model Info", tabName = "model_info")
    )
  ),
  dashboardBody(
    tabItems(
      tabItem(
        tabName = "input",
        fluidPage(
          sidebarLayout(
            sidebarPanel(
              h3("Loan Application Inputs", align = "center", style = "color:#333"),
              br(),
              column(6,
                     numericInput("amount_current_loan", "Current Loan Amount", value = 1000),
                     numericInput("yearly_income", "Yearly Income", value = 30000),
                     numericInput("years_credit_history", "Years of Credit History", value = 5),
                     numericInput("open_accounts", "Open Accounts", value = 1),
                     numericInput("credit_balance", "Credit Balance", value = 5000),
                     numericInput("credit_problems", "Number of Credit Problems", value = 0)
              ),
              column(6,
                     textInput("loan_purpose", "Loan Purpose", value = "buy_house"),
                     numericInput("bankruptcies", "Bankruptcies", value = 0),
                     numericInput("years_current_job", "Years at Current Job", value = 1),
                     numericInput("monthly_debt", "Monthly Debt", value = 100),
                     numericInput("months_since_last_delinquent", "Months Since Last Delinquent", value = 5),
                     numericInput("max_open_credit", "Maximum Open Credit", value = 10000)
              ),
              selectInput("term", "Term", choices = c("short", "long")),
              selectInput("credit_score", "Credit Score", choices = c("fair", "good", "very_good")),
              selectInput("home_ownership", "Home Ownership", choices = c("rent", "mortgage", "own")),
              actionButton("processBtn", "Process Data", class = "btn-primary", style = "width:100%")
            ),
            mainPanel(),
          )
        )
      ),
      tabItem(
        tabName = "results",
        fluidRow(
          box(
            title = "Input Data",
            status = "info",
            solidHeader = TRUE,
            width = 12,
            div(class = "table-responsive", tableOutput("resultsTable"))
          )
        ),
        box(
          title = "Classification Result",
          status = "success",
          solidHeader = TRUE,
          width = 12,
          h3(textOutput("classificationResult", container = span))
        )
      ),
      tabItem(
        tabName = "model_info",
        fluidRow(
          box(
            title = "Variable Importance Plot",
            status = "primary",
            solidHeader = TRUE,
            collapsible = TRUE,
            plotOutput("varImportancePlot")
          )
        )
      )
    )
  )
)

# Define server logic
server <- function(input, output, session) {
  
  model <- h2o.loadModel("../4-model/my_best_gbmmodel")
  
  observeEvent(input$processBtn, {
    # Check for NULL values and provide defaults if necessary
    amount_current_loan <- ifelse(is.numeric(input$amount_current_loan), input$amount_current_loan, 0)
    term <- ifelse(!is.null(input$term), input$term, "default_value")
    credit_score <- ifelse(!is.null(input$credit_score), input$credit_score, "default_value")
    loan_purpose <- ifelse(!is.null(input$loan_purpose), input$loan_purpose, "default_value")
    yearly_income <- ifelse(is.numeric(input$yearly_income), input$yearly_income, 0)
    home_ownership <- ifelse(!is.null(input$home_ownership), input$home_ownership, "default_value")
    bankruptcies <- ifelse(is.numeric(input$bankruptcies), input$bankruptcies, 0)
    years_current_job <- ifelse(is.numeric(input$years_current_job), input$years_current_job, 0)
    monthly_debt <- ifelse(is.numeric(input$monthly_debt), input$monthly_debt, 0)
    years_credit_history <- ifelse(is.numeric(input$years_credit_history), input$years_credit_history, 0)
    months_since_last_delinquent <- ifelse(is.numeric(input$months_since_last_delinquent), input$months_since_last_delinquent, 0)
    open_accounts <- ifelse(is.numeric(input$open_accounts), input$open_accounts, 0)
    credit_problems <- ifelse(is.numeric(input$credit_problems), input$credit_problems, 0)
    credit_balance <- ifelse(is.numeric(input$credit_balance), input$credit_balance, 0)
    max_open_credit <- ifelse(is.numeric(input$max_open_credit), input$max_open_credit, 0)
    
    input_data <- data.frame(
      amount_current_loan = amount_current_loan,
      term = term,
      credit_score = credit_score,
      loan_purpose = loan_purpose,
      yearly_income = yearly_income,
      home_ownership = home_ownership,
      bankruptcies = bankruptcies,
      years_current_job = years_current_job,
      monthly_debt = monthly_debt,
      years_credit_history = years_credit_history,
      months_since_last_delinquent = months_since_last_delinquent,
      open_accounts = open_accounts,
      credit_problems = credit_problems,
      credit_balance = credit_balance,
      max_open_credit = max_open_credit
    )
    
    h2o_input <- as.h2o(input_data)
    prediction <- h2o.predict(model, h2o_input)
    
    # Render the table with input data
    output$resultsTable <- renderTable({
      input_data
    })
    
    # Render the classification result
    output$classificationResult <- renderText({
      result <- ifelse(as.character(as_tibble(prediction)$predict) == "0", "Loan Approved", "Loan Denied")
      return(result)
    })
    
    # Update the tab to show the results
    updateTabItems(session, "sidebar", "results")
  })
  
  output$varImportancePlot <- renderPlot({
    model_info <- h2o.getModel(model@model_id)
    var_imp <- h2o.varimp(model_info)
    var_imp_df <- as.data.frame(var_imp)
    ggplot(var_imp_df, aes(x = reorder(variable, scaled_importance), y = scaled_importance)) +
      geom_bar(stat = "identity") +
      theme_minimal() +
      coord_flip() + 
      labs(title = "Variable Importance", x = "Variables", y = "Importance") +
      theme(panel.grid.major = element_blank(), panel.grid.minor = element_blank(),
            panel.background = element_blank(), axis.line = element_line(colour = "black"))
  })
}

# Run the application
shinyApp(ui, server)