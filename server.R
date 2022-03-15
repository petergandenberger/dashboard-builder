server <- function(input, output, session) {
  current_id <- 1
  
  observeEvent(input$add_element, {
    add_element(current_id)
    current_id <<- current_id + 1
  })
  
  data_r <- reactiveValues(data = mtcars, name = "mtcars")
  
  results <- esquisse_server(
    id = "esquisse",
    data_rv = data_r
  )
  
  observeEvent(input$open_modal, {
    shinyjs::show("esquisseModal")
  })
  
  observeEvent(input$save_modal, {
    if(!is.null(results$code_plot)) {
      render_plot(output, results$code_plot, target = input$open_modal)
    }
    
    shinyjs::hide("esquisseModal")
  })
  
  observeEvent(input$close_modal, {
    shinyjs::hide("esquisseModal")
  })
}