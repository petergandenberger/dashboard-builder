dashboardBuilderElement <-  R6::R6Class("dashboardBuilderElement",
  private = list(
    # see documentation at corresponding active field
    .element_name = NULL,
    .display_name = NULL,
    # see documentation at corresponding active field
    .builder_class = NULL,
    # see documentation at corresponding active field
    .code_preprocessing = NULL,
    # see documentation at corresponding active field
    .code_element = NULL,
    # see documentation at corresponding active field
    .uiOutput = NULL,
    .uiOutput_name = NULL,
    # see documentation at corresponding active field
    .renderFunction = NULL,
    .renderFunction_name = NULL,
    .inner_state = NULL,
    .add_bounding_box = TRUE
  ),
  active = list(
    #' @field element_name, the name of the element which will be used as a prefix 
    #' for the function names when exporting the element.
    element_name = function(value) {
      if (missing(value)) {
        private$.element_name
      } else {
        checkmate::assert_character(value, min.chars = 1)
        private$.element_name <- value
      }
    }, 
    
    display_name = function(value) {
      if (missing(value)) {
        private$.display_name
      } else {
        checkmate::assert_character(value, min.chars = 1)
        private$.display_name <- value
      }
    }, 
    
    add_bounding_box = function(value) {
      if(missing(value)) {
        private$.add_bounding_box
      } else {
        private$.add_bounding_box <- value
      }
    },
    
    inner_state = function(value) {
      if (missing(value)) {
        private$.inner_state
      } else {
        private$.inner_state <- value
      }
    },
    
    builder_class = function(value) {
      if (missing(value)) {
        private$.builder_class
      } else {
        checkmate::assert_character(value, min.chars = 1)
        private$.builder_class <- value
      }
    },
    
    code_preprocessing = function(value) {
      if (missing(value)) {
        private$.code_preprocessing
      } else {
        private$.code_preprocessing <- value
      }
    },
    code_element = function(value) {
      if (missing(value)) {
        private$.code_element
      } else {
        checkmate::assert_character(value, min.chars = 1)
        private$.code_element <- value
      }
    },
    uiOutput = function(value) {
      if (missing(value)) {
        private$.uiOutput
      } else {
        private$.uiOutput <- value
      }
    },
    uiOutput_name = function(value) {
      if (missing(value)) {
        private$.uiOutput_name
      } else {
        private$.uiOutput_name <- value
      }
    },
    renderFunction = function(value) {
      if (missing(value)) {
        private$.renderFunction
      } else {
        private$.renderFunction <- value
      }
    },
    renderFunction_name = function(value) {
      if (missing(value)) {
        private$.renderFunction_name
      } else {
        private$.renderFunction_name <- value
      }
    }
  ), 
  public = list(
    initialize = function(element_name, builder_class, 
                          code_preprocessing, code_element,
                          uiOutput, renderFunction) {
      self$element_name <- element_name
      self$builder_class <- builder_class
      self$code_preprocessing <- code_preprocessing
      self$code_element <- code_element
      self$uiOutput <- uiOutput
      self$renderFunction <- renderFunction
    }
  )
)