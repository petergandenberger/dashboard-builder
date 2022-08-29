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
#'
#' @importFrom shinyalert shinyalert
mod_element_builder_server <- function(id, elementBuilder_list, trigger, st, ns_dashboard_page){
  moduleServer( id, function(input, output, session){
    ns <- session$ns

    observe({
      req(trigger$add_element)
      if(is.null(elementBuilder_list())) {
        shinyalert("No Dataset available", "Please add some data first!", type = "error")
      } else {
        if(trigger$add_element == -1) {
          elementBuilder_list_new <- elementBuilder_list()
          for(elementBuilder in elementBuilder_list_new) {
            elementBuilder$load_element(NULL, session)
          }
          elementBuilder_list_new <- elementBuilder_list_new
        } else {
          current_element <- st$get(trigger$add_element)
            for(elementBuilder in elementBuilder_list()) {
             if(class(elementBuilder)[1] == current_element$builder_class) {
               elementBuilder$load_element(current_element, session)
               elementBuilder_list_new <- list(elementBuilder)
               break
             }
           }
        }

        showModal(element_builder_modal(elementBuilder_list_new, ns))
        # select the first tab
        updateTabsetPanel(session, inputId = "tabset1", elementBuilder_list_new[[1]]$elementBuilder_name)
        current_element <- elementBuilder_list_new[[1]]$dashboardBuilderElement
        if(!is.null(current_element)) {
          updateTextInput(session, "element_name", "Element Name", current_element$display_name)
        }
      }
      trigger$add_element <- NULL
    })


    element <- eventReactive(input$edit_element_ok, {
      #find active tab
      element <- NULL
      for(elementBuilder in elementBuilder_list()) {
        if(elementBuilder$elementBuilder_name == input$tabset1) {
          element <- elementBuilder$build_element(input, ns_dashboard_page)
          element$display_name <- input$element_name
          break
        }
      }
      removeModal()
      return(element)
    })

    return(element)
  })
}

## To be copied in the UI
# mod_element_builder_ui("element_builder_1")

## To be copied in the server
# mod_element_builder_server("element_builder_1")
