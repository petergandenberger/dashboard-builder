library(shinyjs)
library(dRagon)
source("dRagon_helpers.R")

ui <- fluidPage(
  includeCSS("www/style.css"),
  includeCSS("www/gridstack/dist/gridstack.min.css"),
  includeScript("www/overlay.js"),
  # Application title
  titlePanel("dRagon Example", a(icon(name = "cog"))),
  
  
  
  # Show a plot of the generated distribution
  mainPanel(
    actionButton("add", label = "add"),
    grid_stack(
      grid_stack_item(h = 4, w = 4, id = "plot_container",
        HTML(dRagonBox(plotOutput(outputId = "main_plot", height = "auto"),
               div(selectInput(inputId = "n_breaks",
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
                                                min = 0.2, max = 2, value = 1, step = 0.2))
                                  
                   )
               )
             )
      )
    )
  )
)

server <- function(input, output) {
  par(mar = c(1,1,1,1))
  
  observeEvent(input$add, {
    js$add_grid_stack_item(
      dRagonBox(content = div("hi"), content_dropdown = div(selectInput(inputId = "n_breaks2",
                                                           label = "Number of bins in histogram (approximate):",
                                                           choices = c(10, 20, 35, 50),
                                                           selected = 20),
                
                checkboxInput(inputId = "individual_obs2",
                              label = strong("Show individual observations"),
                              value = FALSE),
                
                checkboxInput(inputId = "density2",
                              label = strong("Show density estimate"),
                              value = FALSE),
                conditionalPanel(condition = "input.density == true",
                                 sliderInput(inputId = "bw_adjust2",
                                             label = "Bandwidth adjustment:",
                                             min = 0.2, max = 2, value = 1, step = 0.2))))
      )
  })
  
  output$main_plot <- renderPlot({
      hist(faithful$eruptions,
           probability = TRUE,
           breaks = as.numeric(input$n_breaks),
           xlab = "Duration (minutes)",
           main = "Geyser eruption duration")
      
      if (input$individual_obs) {
        rug(faithful$eruptions)
      }
      
      if (input$density) {
        dens <- density(faithful$eruptions,
                        adjust = input$bw_adjust)
        lines(dens, col = "blue")
      }
    }, height = function() {input$plot_container_height - 60}
  )
}

# Create Shiny object
shinyApp(ui = ui, server = server)