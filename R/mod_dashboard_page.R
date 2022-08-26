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
    grid_stack(id = ns("grid-dashboard"),
               dynamic_full_window_height = TRUE, height_offset = 50)
  )
}

#' dashboard_page Server Functions
#'
#' @noRd
mod_dashboard_page_server <- function(id, data, triggers_dashboard_page){
  moduleServer(id, function(input, output, session){
    ns <- session$ns
    st <- storr::storr_rds(tempfile("storr_"))

    ##############################################################################
    # LOAD DATA ##################################################################
    ##############################################################################
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
    observeEvent(input$element_edit, {triggers_dashboard_page$add_element <- input$element_edit})

    element_new <- mod_element_builder_server("element_builder", elementBuilder_list,
                                              triggers_dashboard_page, st, ns)

    observe({
      req(element_new)
      # check if element already exists
      if(!st$exists(element_new()$element_name)) {
        element_render_ui(element_new(), ns)
      } else {
        # change the box title if available
        shinydashboardPlus::updateBox(
          id = paste0("box_", element_new()$element_name),
          action = "update",
          options = list(
            title = element_new()$display_name
          )
        )
      }
      element_render_server(input, output, element_new(), isolate(data$data()), ns)
      st$set(element_new()$element_name, element_new())
    })

    ##############################################################################
    # CREATE Filter ###################################################
    ##############################################################################
    observeEvent(triggers_dashboard_page$add_filter, {
      shinyalert("TODO - sorry!", "This function is not implemented (yet)!", type = "error")
    })

    ##############################################################################
    # Load dashboard ###################################################
    ##############################################################################
    observeEvent(triggers_dashboard_page$loaded_dashboard, {
      loaded_dashboard <- triggers_dashboard_page$loaded_dashboard
      loaded_st <- triggers_dashboard_page$st

      grid_stack_items <- jsonify::from_json(loaded_dashboard$layout)
      elements <- loaded_dashboard$elements
      for(element in elements) {
        item <- grid_stack_items[grid_stack_items$id == paste0("c_", element$element_name), ]

        element_render_ui(element, ns, w = item$w, h = item$h, x = item$x, y = item$y)
        element_render_server(input, output, element, isolate(data$data()), ns)

        st$set(element$element_name, element)
      }
      triggers_dashboard_page$loaded_dashboard <- NULL
    })

    ##############################################################################
    # DELETE elements ############################################################
    ##############################################################################
    observeEvent(input$element_delete, {
      element_delete(input$element_delete, ns("grid-dashboard"), st)
    })

    st
  })
}

## To be copied in the UI
# mod_dashboard_page_ui("dashboard_page_1")

## To be copied in the server
# mod_dashboard_page_server("dashboard_page_1")
