#' The application server-side
#'
#' @param input,output,session Internal parameters for {shiny}.
#'     DO NOT REMOVE.
#' @import shiny
#' @noRd
app_server <- function(input, output, session) {
  mod_dashboard_page_server("dashboard_page")
  mod_about_server("about")
  
  guide <- create_guide()$init()
  observeEvent(input$guide, {
    guide$start()
  })
}
