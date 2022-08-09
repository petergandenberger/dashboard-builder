
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
    # make sure the content fills the given height
    tags$style(".grid-stack-item-content {height:100%;}"),
    tags$style(".dataTables_scroll {height: calc(100% - 100px);}
                .dataTables_wrapper {height: 100%;}
                .datatables {height: 100%!important; overflow: scroll;}"),
    tags$style(".grid-stack-item-content .col-sm-12 {height: 100%;}"),
    tags$style(".bs4Dash.card {height: calc(100% - 10px);}"),
    tags$style(".small-box {height: calc(100% - 10px);}"),
    tags$style(".small-box .inner {height: calc(100% - 10px);}"),
    tags$style(".grid-stack-item-content {height:100%; overflow:hidden!important;}"),
    grid_stack(
      dynamic_full_window_height = TRUE,
      grid_stack_item(
        h = 3, w = 3, x = 0, y = 0, id = "c_dt_5055526", style = "overflow:hidden", box(
          title = "Element3437655", status = "primary", solidHeader = TRUE, width = 12,
          height = "100%", collapsible = F,
          DT::dataTableOutput(outputId = "dt_5055526")
        )
      )
    )
  )
)

server <- function(input, output, session) {
  dat <- readRDS("data.RDS")

  output$dt_5055526 <- DT::renderDataTable({
    data_selected <- dplyr::select(dat, Ozone, Solar.R)
    DT::datatable(data_selected, options = list(paging = FALSE, searching = FALSE))
  })
}

shinyApp(ui, server)
