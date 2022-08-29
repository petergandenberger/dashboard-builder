GGPlotElementBuilder <- R6::R6Class("GGPlotElementBuilder",
  inherit = dashboardBuilderElementBuilder,
  private = list(
    ggplot_results = NULL
  ),
  public = list(
    initialize = function(dataset) {
      private$.elementBuilder_name = "GGplot"
      super$initialize(dataset)
    },

    get_builder_UI = function (ns) {
      data_rv <- reactiveValues(data = private$dataset, name = "dat")
      private$ggplot_results <- esquisse::esquisse_server(
        id = "esquisse", data_rv = data_rv
      )
      esquisse::esquisse_ui(
        id = ns("esquisse"),
        controls = c("labs", "parameters", "appearance", "filters"),
        header = FALSE
      )
    },

    load_element = function(dashboardBuilderElement, session) {
      if(is.null(dashboardBuilderElement)) {
        private$.dashboardBuilderElement <- NULL
      } else {
        private$.dashboardBuilderElement <- dashboardBuilderElement
        #TODO
      }
    },

    build_element = function (input, ns) {
      code_element <- private$ggplot_results$code_plot

      if(is.null(code_element)) {
        return(NULL)
      }

      if(is.null(private$.dashboardBuilderElement)) {
        element_name <- paste0("plot_", round(runif(1) * 10000000, 0))
        builder_class <- "GGPlotElementBuilder"

        code_preprocessing <- NULL

        uiOutput <- plotOutput(outputId = ns(element_name), height = "100%")
        renderFunction <- renderPlot


        ggplot_element <- dashboardBuilderElement$new(element_name, builder_class,
                                          code_preprocessing, code_element,
                                          uiOutput, renderFunction)
      } else {
        ggplot_element <- private$.dashboardBuilderElement
        ggplot_element$code_element <- code_element
      }

      ggplot_element$inner_state <- input$textElementBuilder_textInput

      ggplot_element$renderFunction_name <- "renderPlot"
      ggplot_element$uiOutput_name <- paste0('plotOutput(outputId = "', ggplot_element$element_name, '", height = "100%")')

      ggplot_element
    }
  )
)
