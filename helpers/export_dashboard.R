export_dashboard <- function(input, st, saved_layout, data) {
  dir.create("out")
  
  saveRDS(data, "out/data.RDS")
  load_data <- 'dat <- readRDS("data.RDS")'
  
  grid_stack_items <- jsonify::from_json(saved_layout)
  elements <- st$list()
  
  elements_ui <- ''
  for(e in elements) {
    element <- st$get(e)
    item <- grid_stack_items[grid_stack_items$id == paste0("c_", element$element_name), ]
    
    
    if(element$add_bounding_box) {
      content <- paste0('box(
          title = "', element$display_name, '", status = "primary", solidHeader = TRUE, width = 12, 
          height = "100%", collapsible = F,
          ', element$uiOutput_name, ')')
    } else {
      content <- element$uiOutput_name
    }
    
    elements_ui <- paste0(elements_ui, '
    grid_stack_item(
        h = ', item$h, ', w = ', item$w, ', x = ', item$x, ', y = ', item$y, 
        ', id = "c_', element$element_name, '", style = "overflow:hidden",',
        content, '),'
    )
  }
  # remove last comma
  elements_ui <- substr(elements_ui,1,nchar(elements_ui)-1)
  
  elements_server <- ''
  for(e in elements) {
    element <- st$get(e)
    
    code <- element$code_element
    if(!is.null(element$code_preprocessing)) {
      code <- paste0(element$code_preprocessing, "\n", code)
    }
    
    elements_server <- paste0(elements_server, '
    output$', element$element_name, ' <- ', element$renderFunction_name, '({', 
    code, '
    })'
    )
  }
  
  
  file <- paste0('library(gridstackeR)
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
      ', elements_ui, '
    )
  )
)

server <- function(input, output, session) {
  ', load_data, '
  ', elements_server, '
}

shinyApp(ui, server)
')
write(file, file = "out/app.R")
styler::style_file("out/app.R")
files <- c("out/app.R", "out/dashboard.Rproj")
files <- c(files, 'out/data.RDS')
zip(zipfile = 'out/dashboard', files)
print("done")
}