library(dRagon)
library(shiny)
library(shinydashboard)


ui <- dashboardPage(
  dashboardHeader(),
  dashboardSidebar(),
  dashboardBody(
    # make sure the content fills the given height
    tags$style(".grid-stack-item-content .col-sm-12{height:100%;}"),
    grid_stack(
      grid_stack_item(
        h = 4, w = 4, id = "plot_container", style = "overflow:hidden",
        box(
          title = "Histogram", status = "primary", solidHeader = TRUE,  width = 12, height = "100%",
          plotOutput("plot3", height = "auto")
        )
      ),
      grid_stack_item(
        h = 4, w = 4, minH = 4, maxH = 4, style = "overflow:hidden",
        box(
          title = "Inputs", status = "warning", solidHeader = TRUE, width = 12, height = "100%",
          "Box content here", br(), "More box content",
          sliderInput("slider", "Slider input:", 1, 100, 50),
          actionButton("text", "Text input:")
        )
      )
    )
  )
)

server <- function(input, output, session) {

  output$plot3 <- renderPlot({
    x    <- faithful$waiting
    bins <- seq(min(x), max(x), length.out = input$slider + 1)

    hist(x, breaks = bins, col = "#75AADB", border = "white",
         xlab = "Waiting time to next eruption (in mins)",
         main = "Histogram of waiting times")

  }, height = function() {max(input$plot_container_height, 280) - 80}
  )

}

shinyApp(ui, server)
