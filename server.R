server <- function(input, output, session) {
  elementBuilder_list <- list(TextElementBuilder$new(mtcars),
                              ValueboxElementBuilder$new(mtcars), 
                              DataTableElementBuilder$new(mtcars),
                              GGPlotElementBuilder$new(mtcars))
  path <- tempfile("storr_")
  st <- storr::storr_rds(path)
  
  observeEvent(input$deleteElement, {
    delete_element(input$deleteElement, st)
  })
  
  observeEvent(input$export, {
    js$save_grid_stack_layout()
  })
  
  observeEvent(input$saved_layout, {
    export_dashboard(input, st, input$saved_layout)
    shinyjs::click("downloadDashboard")
  })
  
  output$downloadDashboard <- downloadHandler(
    filename = function() {
      "out/app.R"
    },
    content = function(file) {
      file.copy("out/app.R", file)
    }
  )
  
  observeEvent(input$add_element, {
    showModal(element_builder_modal())
    # create one tab per elementBuilder from the elementBuilder_list
    first <- TRUE
    for(elementBuilder in elementBuilder_list) {
      appendTab(
        "tabset1",
        tabPanel(elementBuilder$elementBuilder_name, 
                 elementBuilder$get_builder_UI()),
        select = first
      )
      first <- FALSE
    }
  })

  observeEvent(input$open_modal, {
    showModal(element_builder_modal())
    current_element <- st$get(input$open_modal)
    updateTextInput(session, "element_name", "Element Name", 
                    current_element$display_name)
    
    for(elementBuilder in elementBuilder_list) {
      if(class(elementBuilder)[1] == current_element$builder_class) {
        elementBuilder$load_element(current_element, session)
        appendTab(
          "tabset1",
          tabPanel(elementBuilder$elementBuilder_name, 
                   elementBuilder$get_builder_UI()),
          select = class(elementBuilder)[1] == current_element$builder_class
        )
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