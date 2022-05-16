GGPlotElementBuilder <- R6::R6Class("GGPlotElementBuilder",
  inherit = dRagonElementBuilder,
  private = list(
    ggplot_results = NULL
  ),
  public = list(
    initialize = function(dataset) {
      private$.elementBuilder_name = "GGplotElement"
      super$initialize(dataset)
    },
    
    get_builder_UI = function () {
      data_rv <- reactiveValues(data = private$dataset, name = "mtcars")
      private$ggplot_results <- esquisse_server(
        id = "esquisse", data_rv = data_rv
      )
      esquisse_ui(
        id = "esquisse", 
        controls = c("labs", "parameters", "appearance", "filters"),
        header = FALSE
      )
    },
    
    load_element = function(dRagonElement, session) {
      # set slider to saved number 
      private$dRagonElement <- dRagonElement
      #TODO
    },
    
    build_element = function (input) {
      code_element <- private$ggplot_results$code_plot
      
      if(is.null(private$dRagonElement)) {
        element_name <- paste0(round(runif(1) * 10000000, 0))
        builder_class <- "GGPlotElementBuilder"
        
        code_preprocessing <- NULL
        
        uiOutput <- plotOutput(outputId = element_name, height = "100%")
        renderFunction <- renderPlot
        
        
        ggplot_element <- dRagonElement$new(element_name, builder_class, 
                                          code_preprocessing, code_element,
                                          uiOutput, renderFunction)
      } else {
        ggplot_element <- private$dRagonElement
        ggplot_element$code_element <- code_element
      }
      
      ggplot_element$inner_state <- input$textElementBuilder_textInput
      
      ggplot_element$renderFunction_name <- "renderPlot"
      ggplot_element$uiOutput_name <- paste0('plotOutput(outputId = "', element_name, '", height = "100%")')
      
      ggplot_element
    }
  )
)