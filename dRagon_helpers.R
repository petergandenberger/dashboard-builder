render_plot <- function(output, code, target) {
  output[[target]] <- renderPlot({eval(parse(text = code))})
}

add_element <- function(current_id) {
  js$add_grid_stack_element(paste0('{"w": 3, "h": 3, "id": "c_', current_id,'",',
                                   '"content": "<button class = \\"settings\\" id = \\"btn_', current_id, '\\" data-target = \\"plot_', current_id, '\\" onclick = \\"openModal(this.dataset.target)\\"><i class=\\"fa fa-cog\\"></button>"}'))
  insertUI(
    selector = paste0("div[gs-id = 'c_", current_id, "'] .grid-stack-item-content"),
    where = "beforeEnd",
    ui = plotOutput(outputId = paste0("plot_", current_id), height = "100%")
  )
  shinyjs::click(paste0("btn_", current_id))
}
