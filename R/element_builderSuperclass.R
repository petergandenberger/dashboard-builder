dashboardBuilderElementBuilder <- R6::R6Class("dashboardBuilderElementBuilder",
  private = list(
    .elementBuilder_name = NULL,
    .dashboardBuilderElement = NULL,
    dataset = NULL
  ),
  active = list(
    elementBuilder_name = function(value) {
      if(missing(value)) {
        private$.elementBuilder_name
      } else {
        stop("elementBuilder_name is read only", call. = FALSE)
      }
    },
    dashboardBuilderElement = function(value) {
      if(missing(value)) {
        private$.dashboardBuilderElement
      } else {
        stop("elementBuilder_name is read only", call. = FALSE)
      }
    }
  ),
  public = list(
    initialize = function(dataset) {
      private$dataset <- dataset
    },

    load_element = function(dashboardBuilderElement, session) {
      stop("please overwrite 'load_element' in the elment-specific subclass", call. = FALSE)
    },

    get_builder_UI = function (ns) {
      stop("please overwrite 'get_builder_UI' in the elment-specific subclass", call. = FALSE)
    },

    build_element = function (input, ns) {
      stop("please overwrite 'build_element' in the elment-specific subclass", call. = FALSE)
    }
  )
)
