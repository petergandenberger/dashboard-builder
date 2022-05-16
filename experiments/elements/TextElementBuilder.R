TextElementBuilder <- R6::R6Class("TextElementBuilder",
  inherit = dRagonElementBuilder,                               
  public = list(
    initialize = function(dataset) {
      private$.elementBuilder_name = "TextElement"
      super$initialize(dataset)
    },
    
    get_builder_UI = function () {
      textInput("textElementBuilder_textInput", "Caption", "Enter some text to display in element")
    },
    
    load_element = function(dRagonElement, session) {
      # set slider to saved number 
      private$dRagonElement <- dRagonElement
      updateTextInput(session, "textElementBuilder_textInput", "Caption", dRagonElement$inner_state)
    },
    
    build_element = function (input) {
      code_element <- paste0('"', input$textElementBuilder_textInput, '"')
      if(is.null(private$dRagonElement)) {
        element_name <- paste0(round(runif(1) * 10000000, 0))
        builder_class <- "TextElementBuilder"
        
        code_preprocessing <- NULL
        
        uiOutput <- textOutput(outputId = element_name)
        renderFunction <- renderText
        
        text_element <- dRagonElement$new(element_name, builder_class, 
                                          code_preprocessing, code_element,
                                          uiOutput, renderFunction)
      } else {
        text_element <- private$dRagonElement
        text_element$code_element <- code_element
      }
      
      text_element$inner_state <- input$textElementBuilder_textInput
      
      text_element$renderFunction_name <- "renderText"
      text_element$uiOutput_name <- paste0('textOutput(outputId = "', element_name, '")')
      
      text_element
    }
  )
)