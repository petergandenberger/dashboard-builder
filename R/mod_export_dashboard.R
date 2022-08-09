#' export_dashboard UI Function
#'
#' @description A shiny Module.
#'
#' @param id,input,output,session Internal parameters for {shiny}.
#'
#' @noRd
#'
#' @importFrom shiny NS tagList
mod_export_dashboard_ui <- function(id){
  ns <- NS(id)
  div(
    actionButton(ns("export"), "Export"),
    downloadButton(ns("downloadDashboard"), "Download", style = "visibility: hidden;")
  )
}

#' export_dashboard Server Functions
#'
#' @import shinyjs
#'
#' @noRd
mod_export_dashboard_server <- function(id, st, trigger, data){
  moduleServer(id, function(input, output, session){
    ns <- session$ns
    observeEvent(input$export, {
      js$save_grid_stack_layout()
    })

    observe({
      req(trigger())
      if(trigger() != "[]"){
        export_dashboard(input, st, trigger(), data())
      }
      shinyjs::click("downloadDashboard")
    })

    output$downloadDashboard <- downloadHandler(
      filename = function() {
        "dashboard.zip"
      },
      content = function(file) {
        file.copy("out/dashboard.zip", file)
      }
    )
  })
}

## To be copied in the UI
# mod_export_dashboard_ui("export_dashboard_1")

## To be copied in the server
# mod_export_dashboard_server("export_dashboard_1")
