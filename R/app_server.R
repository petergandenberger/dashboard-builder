#' The application server-side
#'
#' @param input,output,session Internal parameters for {shiny}.
#'     DO NOT REMOVE.
#' @import shiny
#' @noRd
app_server <- function(input, output, session) {
  # Import Data ############################################################
  data <- mod_import_data_server("import_data")
  output$txt_current_dataset <- renderText({
    if(is.null(data$name())) {
      return("No dataset loaded...")
    } else {
      data$name()
    }
  })

  # Dashboard page ############################################################
  trigger_add_element <- reactiveVal()
  observeEvent(input$element_add, {trigger_add_element(-1)})

  dashboard_page_id = "dashboard_page"
  st <- mod_dashboard_page_server(dashboard_page_id, data, trigger_add_element)

  # Code page ##################################################################
  trigger_code_page <- reactiveVal()
  observeEvent(input$tabs, {if(input$tabs == "tab_code") {trigger_code_page(-1)}})
  mod_code_page_server("code_page", st, ns_dashboard_page = dashboard_page_id, trigger_code_page)

  # EXPORT elements ############################################################
  mod_export_dashboard_server("export_dashboard", st, data, ns_dashboard_page = dashboard_page_id)

  # Guide ######################################################################
  guide <- create_guide()$init()
  observeEvent(input$guide_header | input$guide_dashboard, {
    guide$start()
  }, ignoreInit = TRUE)

  # hide help overlay after data was imported
  observe({
    req(data)
    if(!is.null(data$data()) || input$tabs != "tab_dashboard"){
      shinyjs::hide("help_overlay", anim = FALSE)
    } else if(input$tabs == "tab_dashboard") {
      shinyjs::show("help_overlay", anim = FALSE)
    }
  })

  # About ############################################################
  mod_about_server("about")
}
