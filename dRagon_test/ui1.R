ui <- fluidPage(
  includeCSS("www/style.css"),
  includeCSS("www/gridstack/dist/gridstack.min.css"),
  includeScript(path = "www/overlay.js"),
  includeScript(path = "www/gridstack.js", type = "module"),
  includeScript(path = "www/gridstack/dist/gridstack-h5.js"),
  # Application title
  titlePanel("Old Faithful Geyser Data"),
  
  
    
    # Show a plot of the generated distribution
    mainPanel(
      tags$button("add", class = "trigger_add"),
      div(
        div(
          div("Item 1",  class = "grid-stack-item-content")
          , class = "grid-stack-item"
        ),
        div(
          div(
            a(icon(name = "cog"), class = "trigger_popup_fricc"),
            a(icon(name = "times"), class = "trigger_delete", style = "float:right;"),
            plotOutput(outputId = "main_plot"),
            div( selectInput(inputId = "n_breaks",
                             label = "Number of bins in histogram (approximate):",
                             choices = c(10, 20, 35, 50),
                             selected = 20),
                 
                 checkboxInput(inputId = "individual_obs",
                               label = strong("Show individual observations"),
                               value = FALSE),
                 
                 checkboxInput(inputId = "density",
                               label = strong("Show density estimate"),
                               value = FALSE),
                 conditionalPanel(condition = "input.density == true",
                                  sliderInput(inputId = "bw_adjust",
                                              label = "Bandwidth adjustment:",
                                              min = 0.2, max = 2, value = 1, step = 0.2)
                 ), class = "dR_popup")
            , class = "grid-stack-item-content dR-box")
          , class = "grid-stack-item gs-w='2'"
        )
        ,class = "grid-stack"
      )
    )
)