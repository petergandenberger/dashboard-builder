server <- function(input, output, session) {
  mapdata <<- readRDS("mapdata.RDS")
  covid <<- readRDS("covid.RDS")
  
  layouts <- read.csv2("saved_layouts.csv", stringsAsFactors = FALSE)
  rvs <- reactiveValues(elements = data.frame(element_id = character(0), element_code = character(0)),
                        current_id = 1)
  
  data_r <- reactiveValues(data = covid, name = "covid")
  
  results <- esquisse_server(
    id = "esquisse"
    #,data_rv = data_r
  )
  
  observeEvent(input$add_element, {
    add_element(rvs$current_id)
    rvs$elements <- rbind(rvs$elements, list(element_id = rvs$current_id, element_code = ""), stringsAsFactors = F)
    rvs$current_id <- rvs$current_id + 1
  })
  
  editBoxModal <- function() {
    modalDialog(
      tabBox(
        width = 12,
        # The id lets us use input$tabset1 on the server to find the current tab
        id = "tabset1",
        tabPanel("Graph", 
                 esquisse_ui(
                    id = "esquisse", 
                    controls = c("labs", "parameters", "appearance", "filters"),
                    header = FALSE
                  )
        ),
        tabPanel("R Code", 
                 aceEditor(
                   outputId = "rcode",
                   fontSize = 15,
                   theme = 'chrome',
                   mode = 'r',
                   placeholder = "Write R-code that creates a plot OR some pre-processing that is run before the esquisser-plot"
                 )),
      ),
      footer = tagList(
        checkboxInput("run_code_before_plot", "Run R-Code before plotting"),
        modalButton("Cancel"),
        actionButton("edit_layout_ok", "Load")
      ),
      size = "l"
    )
  }
  
  observeEvent(input$run_code_before_plot, {
    
  })
  
  observeEvent(input$open_modal, {
    showModal(editBoxModal())
  })
  
  observeEvent(input$load_layout, {
    showModal(loadLayoutModal())
  })
  
  observeEvent(input$edit_layout_ok, {
    if(!is.null(results$code_plot)) {
      if(input$run_code_before_plot && input$rcode != "") {
        render_plot(output, results$code_plot, target = input$open_modal, input$rcode)
      } else {
        render_plot(output, results$code_plot, target = input$open_modal)
        rvs$elements[paste0("plot_", rvs$elements$element_id) == input$open_modal, "element_code"] <- results$code_plot
      }
    } else if(input$rcode != "") {
      render_plot(output, input$rcode, target = input$open_modal)
      rvs$elements[paste0("plot_", rvs$elements$element_id) == input$open_modal, "element_code"] <- input$rcode
    }
    removeModal()
  })
  
  observeEvent(input$save_layout, {
    js$save_grid_stack_layout()
  })
  
  observeEvent(input$saved_layout, {
    showModal(layoutNameModal())
  })
  
  layoutNameModal <- function(failed = FALSE) {
    modalDialog(
      #textInput("new_layout_name", "Layout name",
      #          placeholder = 'Enter the name for the new layout'
      #),
      div(tags$b("Cannot save layouts in online demo (yet)", style = "color: red;")),
      if (failed)
        div(tags$b("This name already exists, please try a new one", style = "color: red;")),
      
      footer = tagList(
        modalButton("Cancel"),
        actionButton("layout_name_ok", "OK")
      )
    )
  }
  
  observeEvent(input$layout_name_ok, {
    # Check that data object exists and is data frame.
    #if (input$new_layout_name %in% unique(layouts$name)) {
    #  showModal(layoutNameModal(failed = TRUE))
    #} else {
    #  new_layout <- jsonlite::fromJSON(input$saved_layout)
    #  new_layout <- cbind(new_layout, rvs$elements)
    #  new_layout$name <- input$new_layout_name
    #  new_layout <- new_layout %>% select(names(layouts))
    #  layouts <<- rbind(layouts, new_layout)
    #  write.csv2(layouts, "saved_layouts.csv", row.names = FALSE)
      removeModal()
    #}
  })
  
  loadLayoutModal <- function() {
    modalDialog(
      selectInput("select_load_layout", "Load Layout", choices = unique(layouts$name)),
      footer = tagList(
        modalButton("Cancel"),
        actionButton("layout_load_ok", "Load")
      )
    )
  }
  
  observeEvent(input$layout_load_ok, {
    removeUI(
      selector = paste0(".grid-stack-item"),
      multiple = TRUE,
      immediate = TRUE
    )
    layout <- layouts %>% filter(name == input$select_load_layout)
    rvs$elements <- load_layout(layout, output)
    rvs$current_id <- max(rvs$elements$element_id) + 1
    removeModal()
  })
  
  observeEvent(input$new_layout, {
    removeUI(
      selector = paste0(".grid-stack-item"),
      multiple = TRUE,
      immediate = TRUE
    )
  })
  
}