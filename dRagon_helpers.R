render_plot <- function(output, code, target, pre_code = NULL) {
  if(!is.null(pre_code)) {
    code <- paste0(pre_code, "\n", code)
  }
  
  x <-  {eval(parse(text = code))}
  output[[target]] <- renderPlot(x)
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


load_layout <- function (layout, output) {
  elements <- c()
  l <- jsonlite::toJSON(layout %>% select(-element_id, -element_code))
  js$load_grid_stack_layout_simple(l)
  
  for(r in 1:nrow(layout)) {
    element <- layout[r, c("element_id", "element_code")]
    insertUI(
      selector = paste0("div[gs-id = 'c_", element$element_id, "'] .grid-stack-item-content"),
      where = "beforeEnd",
      ui = plotOutput(outputId = paste0("plot_", element$element_id), height = "100%"),
      immediate = TRUE
    )
    render_plot(output, gsub("\\n", "", element$element_code), target = paste0("plot_", element$element_id))
    elements <- rbind(elements, element, stringsAsFactors = F)
  }
  return(elements)
}
