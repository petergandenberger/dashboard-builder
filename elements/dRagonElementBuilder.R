dRagonElementBuilder <- R6::R6Class("dRagonElementBuilder",
  private = list(
    .elementBuilder_name = NULL,
    dRagonElement = NULL,
    dataset = NULL
  ),
  active = list(
    elementBuilder_name = function(value) {
      if(missing(value)) {
        private$.elementBuilder_name
      } else {
        stop("elementBuilder_name is read only", call. = FALSE)
      }
    }
  ),
  public = list(
    initialize = function(dataset) {
      private$dataset <- dataset
    },
    
    load_element = function(dRagonElement, session) {
      stop("please overwrite 'load_element' in the elment-specific subclass", call. = FALSE)
    },
    
    get_builder_UI = function () {
      stop("please overwrite 'get_builder_UI' in the elment-specific subclass", call. = FALSE)
    },
    
    build_element = function (input) {
      stop("please overwrite 'build_element' in the elment-specific subclass", call. = FALSE)
    }
  )
)