library(shiny)
library(tidyverse)
library(h2o)
h2o.init()

ui <- fluidPage(
  titlePanel("Banking App"),
  sidebarLayout(
    sidebarPanel(
      fileInput("file", "Upload CSV file")
    ),
    mainPanel(
      tableOutput("table")
    )
  )
)

server <- function(input, output) {
  model <-h2o.loadModel("../4-model/my_best_gbmmodel")
  output$table <- renderTable({
    reg(input$file)
    test_data <- h2o.importFile(input$file$datapath)
    predictions <- h2o.predict(model, test_data)
      head(10)
 
       })
}
shinyApp(ui = ui, server = server)
