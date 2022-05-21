DataTableElementBuilder <- R6::R6Class("DataTableElementBuilder",
  inherit = dRagonElementBuilder,                               
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
    
    load_element = function(dRagonElement, session) {
      # set slider to saved number 
      private$dRagonElement <- dRagonElement
      updateSelectInput(session, "dataTableElementBuilder_vars", "Select vars for the Columns", 
                        names(private$dataset), selected = dRagonElement$inner_state$vars)
    },
    
    build_element = function (input) {
      col1 <- input$dataTableElementBuilder_col1
      col2 <- input$dataTableElementBuilder_col2
      
      if(is.null(private$dRagonElement)) {
        element_name <- paste0("dt_", round(runif(1) * 10000000, 0))
        builder_class <- "DataTableElementBuilder"
        
        code_preprocessing <- paste0("print(dat)\ndata_selected <- dat %>% select(", paste(input$dataTableElementBuilder_vars, collapse = ", "), ")")
        
        
        code_element <- paste0('DT::datatable(data_selected, options = list(paging = FALSE, searching = FALSE))')
        
        
        uiOutput <- DT::dataTableOutput(outputId = element_name)
        renderFunction <- DT::renderDataTable
        
        dt_element <- dRagonElement$new(element_name, builder_class, 
                                          code_preprocessing, code_element,
                                          uiOutput, renderFunction)
      } else {
        dt_element <- private$dRagonElement
        dt_element$code_element <- code_element
      }
      
      dt_element$inner_state$vars <- input$dataTableElementBuilder_vars
      dt_element$renderFunction_name <- "DT::renderDataTable"
      dt_element$uiOutput_name <- paste0("DT::dataTableOutput(outputId = '", element_name, "')")
      dt_element
    }
  )
)