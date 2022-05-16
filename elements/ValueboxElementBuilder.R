ValueboxElementBuilder <- R6::R6Class("ValueboxElementBuilder",
  inherit = dRagonElementBuilder,                               
  public = list(
    initialize = function(dataset) {
      private$.elementBuilder_name = "Valuebox"
      super$initialize(dataset)
    },
    
    get_builder_UI = function () {
      div(
        textInput("valueboxElementBuilder_title", "Title", "Title"),
        numericInput("valueboxElementBuilder_value", "Value", "0"),
        textInput("valueboxElementBuilder_icon", "Icon", "credit-card")
      )
    },
    
    load_element = function(dRagonElement, session) {
      # set slider to saved number 
      private$dRagonElement <- dRagonElement
      updateTextInput(session, "valueboxElementBuilder_title", "Title", 
                      dRagonElement$inner_state$valueboxElementBuilder_title)
      updateNumericInput(session, "valueboxElementBuilder_value", "Value", 
                         dRagonElement$inner_state$valueboxElementBuilder_value)
    },
    
    build_element = function (input) {
      title <- input$valueboxElementBuilder_title
      value <- input$valueboxElementBuilder_value
      icon <- input$valueboxElementBuilder_icon
      
      code_element <- paste0('bs4Dash::bs4ValueBox(
            "', title, '", ', value, ', icon = icon("', icon, '"), width = 12)')
      if(is.null(private$dRagonElement)) {
        element_name <- paste0("vb_", round(runif(1) * 10000000, 0))
        builder_class <- "ValueboxElementBuilder"
        
        code_preprocessing <- NULL
        
        uiOutput <- bs4Dash::bs4ValueBoxOutput(outputId = element_name, width = 12)
        renderFunction <-  bs4Dash::renderbs4ValueBox
        
        infobox_element <- dRagonElement$new(element_name, builder_class, 
                                          code_preprocessing, code_element,
                                          uiOutput, renderFunction)
      } else {
        infobox_element <- private$dRagonElement
        infobox_element$code_element <- code_element
      }
      
      infobox_element$add_bounding_box <- FALSE
      
      infobox_element$inner_state$valueboxElementBuilder_title <- title
      infobox_element$inner_state$valueboxElementBuilder_value <- value
      infobox_element$inner_state$valueboxElementBuilder_icon <- icon
      
      infobox_element$renderFunction_name <- "bs4Dash::renderbs4ValueBox"
      infobox_element$uiOutput_name <- paste0("bs4Dash::bs4ValueBoxOutput(outputId = '", element_name, "', width = 12)")
      
      infobox_element
    }
  )
)