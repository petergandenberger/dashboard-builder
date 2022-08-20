#' The application server-side
#'
#' @param input,output,session Internal parameters for {shiny}.
#'     DO NOT REMOVE.
#' @import shiny
#' @noRd
app_server <- function(input, output, session) {
  # Import Data ############################################################
  data <- mod_import_data_server("import_data")

  # Dashboard page ############################################################
  trigger_add_element <- reactiveVal()
  observeEvent(input$element_add, {trigger_add_element(-1)})

  st <- mod_dashboard_page_server("dashboard_page", data, trigger_add_element)


  # EXPORT elements ############################################################
  mod_export_dashboard_server("export_dashboard", st, data)

  # Guide ######################################################################
  guide <- create_guide()$init()
  observeEvent(input$guide_header | input$guide_dashboard, {
    guide$start()
  }, ignoreInit = TRUE)

  # hide help overlay after data was imported
  observe({
    req(data)
    if(!is.null(data$data())){
      shinyjs::hide("help_overlay", anim = FALSE)
    }
  })

  # About ############################################################
  mod_about_server("about")
}
