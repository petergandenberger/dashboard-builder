element_builder_modal <- function() {
    modalDialog(
      tabBox(
        width = 12,
        # The id lets us use input$tabset1 on the server to find the current tab
        id = "tabset1"
      ),
      footer = tagList(
        #checkboxInput("run_code_before_plot", "Run R-Code before plotting"),
        textInput("element_name", "Element Name", paste0("Element", round(runif(1) * 10000000, 0))),
        modalButton("Cancel"),
        actionButton("edit_layout_ok", "Load")
      ),
      size = "l"
    )
}