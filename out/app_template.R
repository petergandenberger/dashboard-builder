#devtools::install_github("https://github.com/petergandenberger/gridstackeR")

library(gridstackeR)
library(shiny)
library(shinydashboard)
library(shinyjs)
library(ggplot2)
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
      %s
    )
  )
)

server <- function(input, output, session) {
  dat <- readRDS("data.RDS")
  %s
}

shinyApp(ui, server)
