GGPlotElementBuilder <- R6::R6Class("GGPlotElementBuilder",
  inherit = ElementBuilder,
  
  public = list(
    getUIOUtput = function() {
      plotOutput(outputId = paste0("plot_", super$element_name()), height = "100%")
    },
    getUIRenderFunction = function() {shiny::renderPlot},
    
    # serializeable
    saveElement = function() {},
    loadElement = function() {}
  )                      
                         
                         
)                  