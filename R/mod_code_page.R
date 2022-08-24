#' code_page UI Function
#'
#' @description A shiny Module.
#'
#' @param id,input,output,session Internal parameters for {shiny}.
#'
#' @noRd
#'
#' @importFrom shiny NS tagList
mod_code_page_ui <- function(id){
  ns <- NS(id)
  tagList(
    div(id=ns("codeEditor"), style="height:80vh"),
    tags$script(paste0("var editor = ace.edit('", ns("codeEditor"), "');
                editor.session.setMode('ace/mode/r');
                editor.session.setUseWorker(false);
                editor.setShowPrintMargin(false);")
    )
  )
}

#' code_page Server Functions
#'
#' @noRd
mod_code_page_server <- function(id, st, ns_dashboard_page, trigger_code_page){
  moduleServer(id, function(input, output, session){
    ns <- session$ns

    grid_id <- paste0(ns_dashboard_page, "-grid-dashboard")

    observeEvent(trigger_code_page(), {
      trigger_code_page(NULL)
      shinyjs::js$save_grid_layout(grid_id = grid_id, ns = ns(""))
    })


    observeEvent(input[[paste0(grid_id, "_saved_layout")]], {
      saved_layout <- input[[paste0(grid_id, "_saved_layout")]]
      if(saved_layout != "[]") {
        code <- create_appR_file(st, saved_layout)
        code <- gsub('\\"', '\\\\"', code)
        code <- gsub("\\'", "\\\\'", code)
        code <- gsub("\\n", "\\\\n", code)
        shinyjs::runjs(paste0("editor.getSession().setValue('", code, "')"))
      } else {
        shinyalert("No Dashboard found", "Please create a Dashboard before exporting!", type = "error")
      }
    })
  })
}

## To be copied in the UI
# mod_code_page_ui("code_page_1")

## To be copied in the server
# mod_code_page_server("code_page_1")
