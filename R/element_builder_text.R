TextElementBuilder <- R6::R6Class("TextElementBuilder",
  inherit = dashboardBuilderElementBuilder,
  public = list(
    initialize = function(dataset) {
      private$.elementBuilder_name = "Text"
      super$initialize(dataset)
    },

    get_builder_UI = function (ns) {
      textInput(ns("textElementBuilder_textInput"), "Caption", "Enter some text to display in element")
    },

    load_element = function(dashboardBuilderElement, session) {
      # set slider to saved number
      private$.dashboardBuilderElement <- dashboardBuilderElement
      updateTextInput(session, "textElementBuilder_textInput", "Caption", dashboardBuilderElement$inner_state)
    },

    build_element = function (input, ns) {
      code_element <- paste0('"', input$textElementBuilder_textInput, '"')
      if(is.null(private$.dashboardBuilderElement)) {
        element_name <- paste0("txt_", round(runif(1) * 10000000, 0))
        builder_class <- "TextElementBuilder"

        code_preprocessing <- NULL

        uiOutput <- textOutput(outputId = ns(element_name))
        renderFunction <- renderText

        text_element <- dashboardBuilderElement$new(element_name, builder_class,
                                          code_preprocessing, code_element,
                                          uiOutput, renderFunction)
      } else {
        text_element <- private$.dashboardBuilderElement
        text_element$code_element <- code_element
      }

      text_element$inner_state <- input$textElementBuilder_textInput

      text_element$renderFunction_name <- "renderText"
      text_element$uiOutput_name <- paste0('textOutput(outputId = "', text_element$element_name, '")')

      text_element
    }
  )
)
