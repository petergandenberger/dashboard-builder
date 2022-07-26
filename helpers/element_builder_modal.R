element_builder_modal <- function(elementBuilder_list) {
  # create one tab per elementBuilder from the elementBuilder_list
  tabs <- lapply(elementBuilder_list, FUN = function(elementBuilder) {
    tabPanel(elementBuilder$elementBuilder_name, 
             elementBuilder$get_builder_UI())
  })
  
  tabs <- append(tabs, list(title = "Create Element", side = "left", status = "secondary",
                 collapsible = FALSE, width = 12, id = "tabset1"))
  
  
    modalDialog(
      do.call(bs4Dash::tabBox, 
              tabs),
      footer = tagList(
        textInput("element_name", "Element Name", paste0("Element", round(runif(1) * 10000000, 0))),
        modalButton("Cancel"),
        actionButton("edit_layout_ok", "Load")
      ),
      size = "l"
    )
}