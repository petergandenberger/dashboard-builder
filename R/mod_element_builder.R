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
mod_element_builder_server <- function(id, elementBuilder_list, trigger, st){
  moduleServer( id, function(input, output, session){
    ns <- session$ns

    observe({
      req(trigger())

      if(is.null(elementBuilder_list())) {
        shinyalert("No Dataset available", "Please add some data first!", type = "error")
      } else {
        if(trigger() == -1) {
          elementBuilder_list_new <- elementBuilder_list
        } else {
          current_element <- st$get(trigger())
            elementBuilder_list_edited <- function(){NULL}
            for(elementBuilder in elementBuilder_list()) {
             if(class(elementBuilder)[1] == current_element$builder_class) {
               elementBuilder$load_element(current_element, session)
               elementBuilder_list_new <- function(){list(elementBuilder)}
               break
             }
           }
        }

        showModal(element_builder_modal(elementBuilder_list_new, ns))
        # select the first tab
        updateTabsetPanel(session, inputId = "tabset1", elementBuilder_list_new()[[1]]$elementBuilder_name)
        current_element <- elementBuilder_list_new()[[1]]$dashboardBuilderElement
        if(!is.null(current_element)) {
          updateTextInput(session, "element_name", "Element Name", current_element$display_name)
        }
      }
      trigger(NULL)
    })


    element <- eventReactive(input$edit_element_ok, {
      #find active tab
      element <- NULL
      for(elementBuilder in elementBuilder_list()) {
        if(elementBuilder$elementBuilder_name == input$tabset1) {
          element <- elementBuilder$build_element(input, ns)
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
