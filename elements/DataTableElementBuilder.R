DataTableElementBuilder <- R6::R6Class("DataTableElementBuilder",
  inherit = dashboardBuilderElementBuilder,                               
  public = list(
    initialize = function(dataset) {
      private$.elementBuilder_name = "DataTable"
      super$initialize(dataset)
    },
    
    get_builder_UI = function () {
      ui <- div()
      if(!is.null(private$dataset)) {
        ui <- selectInput("dataTableElementBuilder_vars", "Select vars for the Columns", 
                          names(private$dataset), multiple = TRUE)
      } else {
        ui <- div("No dataset available")
      }
      ui
    },
    
    load_element = function(dashboardBuilderElement, session) {
      # set slider to saved number 
      private$dashboardBuilderElement <- dashboardBuilderElement
      updateSelectInput(session, "dataTableElementBuilder_vars", "Select vars for the Columns", 
                        names(private$dataset), selected = dashboardBuilderElement$inner_state$vars)
    },
    
    build_element = function (input) {
      col1 <- input$dataTableElementBuilder_col1
      col2 <- input$dataTableElementBuilder_col2
      
      code_element <- paste0('DT::datatable(data_selected, options = list(paging = FALSE, searching = FALSE))')
      code_preprocessing <- paste0("print(dat)\ndata_selected <- dat %>% select(", paste(input$dataTableElementBuilder_vars, collapse = ", "), ")")
      
      
      if(is.null(private$dashboardBuilderElement)) {
        element_name <- paste0("dt_", round(runif(1) * 10000000, 0))
        builder_class <- "DataTableElementBuilder"
        
        
        
        uiOutput <- DT::dataTableOutput(outputId = element_name)
        renderFunction <- DT::renderDataTable
        
        dt_element <- dashboardBuilderElement$new(element_name, builder_class, 
                                          code_preprocessing, code_element,
                                          uiOutput, renderFunction)
      } else {
        element_name <- private$dashboardBuilderElement$element_name
        dt_element <- private$dashboardBuilderElement
        dt_element$code_element <- code_element
        dt_element$code_preprocessing <- code_preprocessing
      }
      
      dt_element$inner_state$vars <- input$dataTableElementBuilder_vars
      dt_element$renderFunction_name <- "DT::renderDataTable"
      dt_element$uiOutput_name <- paste0("DT::dataTableOutput(outputId = '", element_name, "')")
      dt_element
    }
  )
)