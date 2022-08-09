#' dashboard_page UI Function
#'
#' @description A shiny Module.
#'
#' @param id,input,output,session Internal parameters for {shiny}.
#'
#' @noRd
#'
#' @import gridstackeR
#' @importFrom shiny NS tagList
mod_dashboard_page_ui <- function(id){
  ns <- NS(id)
  grid_stack(dynamic_full_window_height = TRUE, height_offset = 50)
}

#' dashboard_page Server Functions
#'
#' @noRd
mod_dashboard_page_server <- function(id){
  moduleServer( id, function(input, output, session){
    ns <- session$ns

  })
}

## To be copied in the UI
# mod_dashboard_page_ui("dashboard_page_1")

## To be copied in the server
# mod_dashboard_page_server("dashboard_page_1")
