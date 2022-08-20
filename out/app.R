
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
        h = 12, w = 2, x = 0, y = 0, id = "c_dt_4698135", style = "overflow:hidden",
        box(
          title = "Element2349933", status = "primary", solidHeader = TRUE, width = 12,
          height = "100%", collapsible = F,
          DT::dataTableOutput(outputId = "dt_4698135")
        )
      ),
      grid_stack_item(
        h = 3, w = 10, x = 2, y = 9, id = "c_plot_3607168", style = "overflow:hidden",
        box(
          title = "Element6163308", status = "primary", solidHeader = TRUE, width = 12,
          height = "100%", collapsible = F,
          plotOutput(outputId = "plot_3607168", height = "100%")
        )
      ),
      grid_stack_item(
        h = 7, w = 4, x = 2, y = 2, id = "c_plot_4258645", style = "overflow:hidden",
        box(
          title = "Element7591947", status = "primary", solidHeader = TRUE, width = 12,
          height = "100%", collapsible = F,
          plotOutput(outputId = "plot_4258645", height = "100%")
        )
      ),
      grid_stack_item(
        h = 9, w = 6, x = 6, y = 0, id = "c_plot_8900460", style = "overflow:hidden",
        box(
          title = "Element7589420", status = "primary", solidHeader = TRUE, width = 12,
          height = "100%", collapsible = F,
          plotOutput(outputId = "plot_8900460", height = "100%")
        )
      ),
      grid_stack_item(
        h = 2, w = 2, x = 2, y = 0, id = "c_vb_3276446", style = "overflow:hidden", bs4Dash::bs4ValueBoxOutput(outputId = "vb_3276446", width = 12)
      ),
      grid_stack_item(
        h = 2, w = 2, x = 4, y = 0, id = "c_vb_4364029", style = "overflow:hidden", bs4Dash::bs4ValueBoxOutput(outputId = "vb_4364029", width = 12)
      )
    )
  )
)

server <- function(input, output, session) {
  dat <- readRDS("data.RDS")

  output$dt_4698135 <- DT::renderDataTable({
    data_selected <- dplyr::select(dat, date_short, result)
    DT::datatable(data_selected, options = list(paging = FALSE, searching = FALSE))
  })
  output$plot_3607168 <- renderPlot({
    ggplot(dat) +
      aes(x = date, y = rating) +
      geom_line(size = 0.5, colour = "#112446") +
      theme_minimal()
  })
  output$plot_4258645 <- renderPlot({
    ggplot(dat) +
      aes(x = result_short, fill = color) +
      geom_bar() +
      scale_fill_hue(direction = 1) +
      coord_flip() +
      theme_minimal()
  })
  output$plot_8900460 <- renderPlot({
    ggplot(dat) +
      aes(x = rating, y = rating_opponent, colour = result_short) +
      geom_point(
        shape = "circle",
        size = 1.5
      ) +
      scale_color_hue(direction = 1) +
      theme_minimal()
  })
  output$vb_3276446 <- bs4Dash::renderbs4ValueBox({
    bs4Dash::bs4ValueBox(
      "Title", 0,
      icon = icon("credit-card"), width = 12
    )
  })
  output$vb_4364029 <- bs4Dash::renderbs4ValueBox({
    bs4Dash::bs4ValueBox(
      "Title", 0,
      icon = icon("credit-card"), width = 12
    )
  })
}

shinyApp(ui, server)
