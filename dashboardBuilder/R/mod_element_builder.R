#' element_builder UI Function
#'
#' @description A shiny Module.
#'
#' @param id,input,output,session Internal parameters for {shiny}.
#'
#' @noRd
#'
#' @importFrom shiny NS tagList
mod_element_builder_ui <- function(id){
  ns <- NS(id)
}

#' element_builder Server Functions
#'
#' @noRd
mod_element_builder_server <- function(id, elementBuilder_list, open_modal_trigger, st){
  moduleServer( id, function(input, output, session){
    ns <- session$ns

    observe({
      req(open_modal_trigger())
      showModal(element_builder_modal(elementBuilder_list, ns))
    })


    observeEvent(input$edit_element_ok, {
      #find active tab
      for(elementBuilder in elementBuilder_list()) {
        if(elementBuilder$elementBuilder_name == input$tabset1) {
          element <- elementBuilder$build_element(input, ns)
          element$display_name <- input$element_name
          # check if element already exists
          ###########################
          if(!st$exists(element$element_name)) {
            element_render_ui(element)
          }
          element_render_server(input, output, element)
          st$set(element$element_name, element)
          #######################
          break
        }
      }
      removeModal()
    })

  })
}

## To be copied in the UI
# mod_element_builder_ui("element_builder_1")

## To be copied in the server
# mod_element_builder_server("element_builder_1")
