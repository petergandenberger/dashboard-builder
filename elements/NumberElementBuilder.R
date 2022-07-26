NumberElementBuilder <- R6::R6Class("NumberElementBuilder",
  inherit = dashboardBuilderElementBuilder,                               
  public = list(
    initialize = function(dataset) {
      private$.elementBuilder_name = "Number"
      super$initialize(dataset)
    },
    
    get_builder_UI = function () {
      sliderInput("numberElementBuilder_slider", label = h3("Slider"), min = 0, 
                  max = 100, value = 50)
    },
    
    load_element = function(dashboardBuilderElement, session) {
      # set slider to saved number 
      private$dashboardBuilderElement <- dashboardBuilderElement
      updateSliderInput(session, "numberElementBuilder_slider", label = "Slider", min = 0, 
                        max = 100, value = dashboardBuilderElement$inner_state)
    },
    
    build_element = function (input) {
      code_element <- paste0('"', input$numberElementBuilder_slider, '"')
      if(is.null(private$dashboardBuilderElement)) {
        element_name <- paste0(round(runif(1) * 10000000, 0))
        builder_class <- "NumberElementBuilder"
        
        code_preprocessing <- NULL
        
        uiOutput <- textOutput(outputId = element_name)
        renderFunction <- renderText
        
        number_element <- dashboardBuilderElement$new(element_name, builder_class, 
                                            code_preprocessing, code_element,
                                            uiOutput, renderFunction)
      } else {
        number_element <- private$dashboardBuilderElement
        number_element$code_element <- code_element
      }
      
      number_element$inner_state <- input$numberElementBuilder_slider
      number_element$renderFunction_name <- "renderText"
      number_element$uiOutput_name <- paste0('textOutput(outputId = "', element_name, '")')
      number_element
    }
  )
)