#' add_element UI Function
#'
#' @description A shiny Module.
#'
#' @param id,input,output,session Internal parameters for {shiny}.
#'
#' @noRd
#'
#' @importFrom shiny NS tagList
mod_add_element_ui <- function(id){
  ns <- NS(id)

  actionButton(ns("add_element"), "Add Element")
}

#' add_element Server Functions
#'
#' @importFrom shinyalert shinyalert
#'
#' @noRd
mod_add_element_server <- function(id, data_imported, st){
  moduleServer(id, function(input, output, session){
    ns <- session$ns

    elementBuilder_list <- reactive({
      if(is.null(data_imported$data())) {
        return(NULL)
      } else {
        dat <- data.frame(data_imported$data())
        elementBuilder_list <- list(TextElementBuilder$new(dat),
                                     ValueboxElementBuilder$new(dat),
                                     DataTableElementBuilder$new(dat)#,
                                     #GGPlotElementBuilder$new(dat)
                                    )
        return(elementBuilder_list)
      }
    })

    open_modal_trigger <- eventReactive(input$add_element, {
      if(is.null(elementBuilder_list())) {
        shinyalert("No Dataset available", "Please add some data first!", type = "error")
        return(NULL)
      } else {
        return(runif(1))
      }
    })


    mod_element_builder_server("element_builder_1", elementBuilder_list, open_modal_trigger, st)

  })
}

## To be copied in the UI
# mod_add_element_ui("add_element_1")

## To be copied in the server
# mod_add_element_server("add_element_1")
