library(gridstackeR)
library(shiny)
library(shinydashboard)
library(shinyjs)
library(ggplot2)
library(bs4Dash)
library(tidyr)
library(dplyr)


ui <- dashboardPage(
  title = "gridstackeR Demo",
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
        h = 11, w = 2, x = 0, y = 0, id = "c_dt_5479636", style = "overflow:hidden",
        box(
          title = "Table", status = "primary", solidHeader = TRUE, width = 12, height = "100%",
          DT::dataTableOutput(outputId = 'dt_5479636'))
      ),
    grid_stack_item(
        h = 8, w = 3, x = 2, y = 2, id = "c_plot_2159901", style = "overflow:hidden",
        box(
          title = "mpg cyl", status = "primary", solidHeader = TRUE, width = 12, height = "100%",
          plotOutput(outputId = "plot_2159901", height = "100%"))
      ),
    grid_stack_item(
        h = 2, w = 2, x = 2, y = 0, id = "c_vb_6030750", style = "overflow:hidden",
        box(
          title = "Element2597269", status = "primary", solidHeader = TRUE, width = 12, height = "100%",
          bs4Dash::bs4ValueBoxOutput(outputId = 'vb_6030750', width = 12))
      )
    )
  )
)

server <- function(input, output, session) {
  
    output$dt_5479636 <- DT::renderDataTable({data <- mtcars %>% select(mpg, cyl)
DT::datatable(data, options = list(paging = FALSE, searching = FALSE))
    })
    output$plot_2159901 <- renderPlot({ggplot(mtcars) +
 aes(x = mpg, y = cyl) +
 geom_point(shape = "circle", size = 1.5, colour = "#112446") +
 theme_minimal()
    })
    output$vb_6030750 <- bs4Dash::renderbs4ValueBox({bs4Dash::bs4ValueBox(
            "Title", 0, icon = icon("credit-card"), width = 12)
    })
}

shinyApp(ui, server)

