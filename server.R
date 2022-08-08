server <- function(input, output, session) {
  elementBuilder_list <- NULL
  path <- tempfile("storr_")
  st <- storr::storr_rds(path)
  
  observeEvent(input$deleteElement, {
    delete_element(input$deleteElement, st)
  })
  
  
  
  observe({
    req(!is.null(data_imported$data()))
    dat <<- data.frame(data_imported$data())
    elementBuilder_list <<- list(TextElementBuilder$new(dat),
         ValueboxElementBuilder$new(dat), 
         DataTableElementBuilder$new(dat),
         GGPlotElementBuilder$new(dat))
  })
  
 
  
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