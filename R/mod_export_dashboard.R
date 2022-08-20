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
  tagList(
    actionButton(ns("export"), "Export", icon = icon("download")),
    downloadButton(ns("downloadDashboard"), "Download", style = "visibility: hidden;")
  )
}

#' export_dashboard Server Functions
#'
#' @import shinyjs
#'
#' @noRd
mod_export_dashboard_server <- function(id, st, data){
  moduleServer(id, function(input, output, session){
    ns <- session$ns
    observeEvent(input$export, {
      js$save_grid_stack_layout_ns(ns(""))
    })

    observeEvent(input$saved_layout, {
      if(input$saved_layout != "[]"){
        export_dashboard(input, st, input$saved_layout, data$data())
        shinyjs::click("downloadDashboard")
      } else {
        shinyalert("No Dashboard found", "Please create a Dashboard before exporting!", type = "error")
      }
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
