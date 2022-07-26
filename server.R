server <- function(input, output, session) {
  elementBuilder_list <- NULL
  path <- tempfile("storr_")
  st <- storr::storr_rds(path)
  
  observeEvent(input$deleteElement, {
    delete_element(input$deleteElement, st)
  })
  
  observeEvent(input$import_data, {
    import_modal(
      id = "import_mod",
      from = c("env", "file", "googlesheets"),
      title = "Import data to be used in application"
    )
  })
  
  data_imported <- import_server("import_mod", return_class = "tbl_df")
  
  observe({
    req(!is.null(data_imported$data()))
    dat <<- data.frame(data_imported$data())
    elementBuilder_list <<- list(TextElementBuilder$new(dat),
         ValueboxElementBuilder$new(dat), 
         DataTableElementBuilder$new(dat),
         GGPlotElementBuilder$new(dat))
  })
  
  observeEvent(input$export, {
    js$save_grid_stack_layout()
  })
  
  observeEvent(input$saved_layout, {
    export_dashboard(input, st, input$saved_layout, dat)
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
  
  observeEvent(input$add_element, {
    if(is.null(elementBuilder_list)) {
      shinyalert("No Dataset available", "Please add some data first!", type = "error")
    } else{
      showModal(element_builder_modal(elementBuilder_list))
    }
  })

  observeEvent(input$open_modal, {
    current_element <- st$get(input$open_modal)
    
    for(elementBuilder in elementBuilder_list) {
      if(class(elementBuilder)[1] == current_element$builder_class) {
        elementBuilder$load_element(current_element, session)
        
        
        showModal(element_builder_modal(list(elementBuilder)))
        updateTextInput(session, "element_name", "Element Name", 
                        current_element$display_name)
        break
      }
    }
  })
  
  observeEvent(input$edit_layout_ok, {
    #find active tab
    for(elementBuilder in elementBuilder_list) {
      if(elementBuilder$elementBuilder_name == input$tabset1) {
        element <- elementBuilder$build_element(input)
        element$display_name <- input$element_name
        # check if element already exists
        if(!st$exists(element$element_name)) {
          add_element(element)
        }
        render_element(input, output, element)
        st$set(element$element_name, element)
        break
      } 
    }
    removeModal()
  })
}