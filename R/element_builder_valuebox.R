ValueboxElementBuilder <- R6::R6Class("ValueboxElementBuilder",
  inherit = dashboardBuilderElementBuilder,
  public = list(
    initialize = function(dataset) {
      private$.elementBuilder_name = "Valuebox"
      super$initialize(dataset)
    },

    get_builder_UI = function (ns) {
      div(
        textInput(ns("valueboxElementBuilder_title"), "Title", "Title"),
        numericInput(ns("valueboxElementBuilder_value"), "Value", "0"),
        textInput(ns("valueboxElementBuilder_icon"), "Icon", "credit-card")
      )
    },

    load_element = function(dashboardBuilderElement, session) {
      # set slider to saved number
      private$.dashboardBuilderElement <- dashboardBuilderElement
      updateTextInput(session, "valueboxElementBuilder_title", "Title",
                      dashboardBuilderElement$inner_state$valueboxElementBuilder_title)
      updateNumericInput(session, "valueboxElementBuilder_value", "Value",
                         dashboardBuilderElement$inner_state$valueboxElementBuilder_value)
    },

    build_element = function (input, ns) {
      title <- input$valueboxElementBuilder_title
      value <- input$valueboxElementBuilder_value
      icon <- input$valueboxElementBuilder_icon

      code_element <- paste0('shinydashboard::valueBox(
            value = "', value, '", subtitle = "', title, '", icon = icon("', icon, '"),',
            ' width = 12, color = "light-blue")')
      if(is.null(private$.dashboardBuilderElement)) {
        element_name <- paste0("vb_", round(runif(1) * 10000000, 0))
        builder_class <- "ValueboxElementBuilder"

        code_preprocessing <- NULL

        uiOutput <- bs4Dash::bs4ValueBoxOutput(outputId = ns(element_name), width = 12)
        renderFunction <-  bs4Dash::renderbs4ValueBox

        valuebox_element <- dashboardBuilderElement$new(element_name, builder_class,
                                          code_preprocessing, code_element,
                                          uiOutput, renderFunction)
      } else {
        valuebox_element <- private$.dashboardBuilderElement
        valuebox_element$code_element <- code_element
      }

      valuebox_element$add_bounding_box <- FALSE

      valuebox_element$inner_state$valueboxElementBuilder_title <- title
      valuebox_element$inner_state$valueboxElementBuilder_value <- value
      valuebox_element$inner_state$valueboxElementBuilder_icon <- icon

      valuebox_element$renderFunction_name <- "shinydashboard::renderValueBox"
      valuebox_element$uiOutput_name <- paste0("shinydashboard::valueBoxOutput(outputId = '",
                                              valuebox_element$element_name, "', width = 12)")

      valuebox_element
    }
  )
)
