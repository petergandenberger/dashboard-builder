library(dRagon)
library(shiny)
library(shinydashboard)


ui <- dashboardPage(
  dashboardHeader(),
  dashboardSidebar(),
  dashboardBody(
    # make sure the content fills the given height
    tags$style(".grid-stack-item-content .col-sm-12{height:100%;}"),
    #grid layout
    grid_stack(
      grid_stack_item(
        h = 2, w = 2, noResize = T,
        sliderInput(inputId = "bins", label = "Number of bins:", min = 1, max = 50,value = 30)
      ),
      grid_stack_item(
        id = "distPlotContainer", h = 6, w = 4,
        plotOutput(outputId = "distPlot")
      )
    )
  )
)

server <- function(input, output) {
  output$distPlot <- renderPlot({
    x    <- faithful$waiting
    bins <- seq(min(x), max(x), length.out = input$bins + 1)

    hist(x, breaks = bins, col = "#75AADB", border = "white",
         xlab = "Waiting time to next eruption (in mins)",
         main = "Histogram of waiting times")
  }, height = function() {max(input$distPlotContainer_height, 420) - 50})

}

shinyApp(ui, server)

