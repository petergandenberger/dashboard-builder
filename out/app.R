
# devtools::install_github("https://github.com/petergandenberger/gridstackeR")

library(gridstackeR)
library(shiny)
library(shinydashboard)
library(shinyjs)
library(ggplot2)
library(bs4Dash)
library(tidyr)
library(dplyr)


ui <- dashboardPage(
  title = "Dashboard-Builder Demo",
  dashboardHeader(),
  dashboardSidebar(disable = TRUE),
  dashboardBody(
    useShinyjs(),
    tags$head(
      tags$link(rel = "stylesheet", type = "text/css", href = "styles.css")
    ),
    grid_stack(
      dynamic_full_window_height = TRUE,
      grid_stack_item(
        h = 3, w = 3, x = 0, y = 0, id = "c_plot_5727106", style = "overflow:hidden",
        box(
          title = "Element3893429", status = "primary", solidHeader = TRUE, width = 12,
          height = "100%", collapsible = F,
          plotOutput(outputId = "plot_5727106", height = "100%")
        )
      )
    )
  )
)

server <- function(input, output, session) {
  dat <- readRDS("data.RDS")

  output$plot_5727106 <- renderPlot({
    ggplot(dat) +
      aes(x = Ozone) +
      geom_histogram(bins = 30L, fill = "#112446") +
      theme_minimal()
  })
}

shinyApp(ui, server)
