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
  tagList(
    tagList(
      mod_import_data_ui(ns("import_data")),
      actionButton(ns("element_add"), "Add Element"),
      mod_export_dashboard_ui(ns("export_dashboard"))
    ),
    grid_stack(id = ns("grid-dashboard"),
               dynamic_full_window_height = TRUE, height_offset = 50)
  )
}

#' dashboard_page Server Functions
#'
#' @noRd
mod_dashboard_page_server <- function(id){
  moduleServer(id, function(input, output, session){
    ns <- session$ns
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
    observeEvent(input$element_add, {trigger_element(-1)})
    observeEvent(input$element_edit, {trigger_element(input$element_edit)})

    element_new <- mod_element_builder_server("element_builder", elementBuilder_list,
                                              trigger_element, st, ns)

    observe({
      req(element_new())
      # check if element already exists
      if(!st$exists(element_new()$element_name)) {
        element_render_ui(element_new(), ns)
      }
      element_render_server(input, output, element_new(), data$data(), ns)
      st$set(element_new()$element_name, element_new())
    })


    ##############################################################################
    # EXPORT elements ############################################################
    ##############################################################################
    mod_export_dashboard_server("export_dashboard", st, data)


    ##############################################################################
    # DELETE elements ############################################################
    ##############################################################################
    observeEvent(input$element_delete, {
      element_delete(input$element_delete, st)
    })
  })
}

## To be copied in the UI
# mod_dashboard_page_ui("dashboard_page_1")

## To be copied in the server
# mod_dashboard_page_server("dashboard_page_1")
