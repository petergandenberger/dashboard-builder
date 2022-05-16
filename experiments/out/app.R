library(gridstackeR)
library(shiny)
library(shinydashboard)
library(shinyjs)


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
        h = 10, w = 3, x = 0, y = 0, id = "c_2010746", style = "overflow:hidden",
        box(
          title = "Element2080208", status = "primary", solidHeader = TRUE, width = 12, height = "100%",
          DT::dataTableOutput(outputId = '2010746'))
      ),
    grid_stack_item(
        h = 2, w = 3, x = 3, y = 8, id = "c_5906978", style = "overflow:hidden",
        box(
          title = "Element8737635", status = "primary", solidHeader = TRUE, width = 12, height = "100%",
          textOutput(outputId = "5906978"))
      ),
    grid_stack_item(
        h = 6, w = 3, x = 3, y = 2, id = "c_7062749", style = "overflow:hidden",
        box(
          title = "Element4333057", status = "primary", solidHeader = TRUE, width = 12, height = "100%",
          plotOutput(outputId = "7062749", height = "100%"))
      ),
    grid_stack_item(
        h = 2, w = 1, x = 3, y = 0, id = "c_979166", style = "overflow:hidden",
        box(
          title = "Element808948", status = "primary", solidHeader = TRUE, width = 12, height = "100%",
          bs4Dash::bs4ValueBoxOutput(outputId = '979166', width = 12))
      )
    )
  )
)

server <- function(input, output, session) {
  
    output[["2010746"]] <- DT::renderDataTable({data <- mtcars %>% select(mpg, cyl)
DT::datatable(data, options = list(paging = FALSE, searching = FALSE))
    })
    output[["5906978"]] <- renderText({"Enter some text to display in element"
    })
    output[["7062749"]] <- renderPlot({ggplot(mtcars) +
 aes(x = mpg, y = qsec, colour = cyl) +
 geom_point(shape = "circle", size = 1.5) +
 scale_color_distiller(palette = "Accent", 
 direction = 1) +
 theme_minimal()
    })
    output[["979166"]] <- bs4Dash::renderbs4ValueBox({bs4Dash::bs4ValueBox(
            "Title", 0, icon = icon("credit-card"), width = 12)
    })
}

shinyApp(ui, server)

