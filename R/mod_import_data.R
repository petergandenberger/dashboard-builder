#' import_data UI Function
#'
#' @description Allows the user to import datasets into the dashboard-builder.
#'
#' @param id,input,output,session Internal parameters for {shiny}.
#'
#' @noRd
#'
#' @importFrom shiny NS tagList
mod_import_data_ui <- function(id){
  ns <- NS(id)
  tagList(
    actionButton(ns("import_data"), "Import Data")
  )
}

#' import_data Server Functions
#'
#' @import datamods
#'
#' @noRd
mod_import_data_server <- function(id){
  moduleServer( id, function(input, output, session){
    ns <- session$ns

    observeEvent(input$import_data, {
      import_modal(
        id = ns("import_mod"),
        from = c("env", "file", "googlesheets"),
        title = "Import a dataset you want to use in the dashboard-builder"
      )
    })

    data_imported <- import_server("import_mod", return_class = "tbl_df")

    return(data_imported)
  })
}

## To be copied in the UI
# mod_import_data_ui("import_data_1")

## To be copied in the server
# mod_import_data_server("import_data_1")
