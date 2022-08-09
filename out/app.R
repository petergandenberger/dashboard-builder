
# devtools::install_github("https://github.com/petergandenberger/gridstackeR")

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
      grid_stack_item(
        h = 10, w = 7, x = 0, y = 0, id = "c_dt_8401911", style = "overflow:hidden",
        box(
          title = "Element7968057", status = "primary", solidHeader = TRUE, width = 12,
          height = "100%", collapsible = F,
          DT::dataTableOutput(outputId = "dt_8401911")
        )
      ),
      grid_stack_item(
        h = 3, w = 5, x = 7, y = 0, id = "c_plot_513183", style = "overflow:hidden",
        box(
          title = "Element3149868", status = "primary", solidHeader = TRUE, width = 12,
          height = "100%", collapsible = F,
          plotOutput(outputId = "plot_513183", height = "100%")
        )
      )
    )
  )
)

server <- function(input, output, session) {
  dat <- readRDS("data.RDS")

  output$dt_8401911 <- DT::renderDataTable({
    data_selected <- dplyr::select(dat, Ozone, Solar.R)
    DT::datatable(data_selected, options = list(paging = FALSE, searching = FALSE))
  })
  output$plot_513183 <- renderPlot({
    ggplot(dat) +
      aes(x = Ozone) +
      geom_histogram(bins = 30L, fill = "#112446") +
      theme_minimal()
  })
}

shinyApp(ui, server)
