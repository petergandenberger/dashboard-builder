mod_code_page_serveruiae <- function(id){
  moduleServer( id, function(input, output, session){
    ns <- session$ns

    observeEvent(input$uiaeload_code, {
    })
  })
}
