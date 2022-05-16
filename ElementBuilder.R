ElementBuilder <- R6::R6Class("ElementBuilder",
  private = list(
    # see documentation at corresponding active field
    .element_name = NULL,
    .code_preprocessing = NULL,
    .code_element = NULL
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
    
    code_preprocessing = function(value) {
      if (missing(value)) {
        private$.code_preprocessing
      } else {
        checkmate::assert_character(value, min.chars = 1)
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
    }
  ),
  public = list(
    getUIOUtput = function(element_id) {},
    getUIRenderFunction = function() {},
    
    # serializeable
    saveElement = function() {},
    loadElement = function() {}
  ),

                        
)