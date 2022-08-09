#' The application server-side
#'
#' @param input,output,session Internal parameters for {shiny}.
#'     DO NOT REMOVE.
#' @import shiny
#' @noRd
app_server <- function(input, output, session) {
  st <- storr::storr_rds(tempfile("storr_"))

  ##############################################################################
  # LOAD DATA ##################################################################
  ##############################################################################
  data <- mod_import_data_server("import_data")
  elementBuilder_list <- reactive({
    if(is.null(data$data())) {
      return(NULL)
    } else {
      dat <- data.frame(data$data())
      elementBuilder_list <- list(TextElementBuilder$new(dat),
                                  ValueboxElementBuilder$new(dat),
                                  DataTableElementBuilder$new(dat),
                                  GGPlotElementBuilder$new(dat)
      )
      return(elementBuilder_list)
    }
  })
  
  
  ##############################################################################
  # CREATE and EDIT elements ###################################################
  ##############################################################################
  trigger_element <- reactiveVal()
  observeEvent(input$add_element, {trigger_element(-1)})
  observeEvent(input$open_modal, {trigger_element(input$open_modal)})
  
  element_new <- mod_element_builder_server("element_builder", elementBuilder_list, 
                                            trigger_element, st)
  
  observe({
    req(element_new())
    # check if element already exists
    if(!st$exists(element_new()$element_name)) {
      element_render_ui(element_new())
    }
    element_render_server(input, output, element_new(), data$data())
    st$set(element_new()$element_name, element_new())
  })
  
  
  ##############################################################################
  # EXPORT elements ############################################################
  ##############################################################################
  trigger_export <- reactiveVal()
  observeEvent(input$saved_layout, {trigger_export(input$saved_layout)})
  mod_export_dashboard_server("export_dashboard", st, trigger_export, data)
  
  
  ##############################################################################
  # DELETE elements ############################################################
  ##############################################################################
  observeEvent(input$deleteElement, {
    element_delete(input$deleteElement, st)
  })
}
