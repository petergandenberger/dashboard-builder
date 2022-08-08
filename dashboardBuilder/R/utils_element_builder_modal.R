#' element_builder_modal
#'
#' @description creates one tab per elementBuilder from the elementBuilder_list
#'
#' @return The return value, if any, from executing the utility.
#'
#' @noRd
element_builder_modal <- function(elementBuilder_list, ns) {
  tabs <- lapply(elementBuilder_list(), FUN = function(elementBuilder) {
    tabPanel(elementBuilder$elementBuilder_name,
             elementBuilder$get_builder_UI(ns))
  })

  tabs <- append(tabs, list(title = "Create Element", side = "left", status = "secondary",
                            collapsible = FALSE, width = 12, id = ns("tabset1")))


  modalDialog(
    do.call(bs4Dash::tabBox,
            tabs),
    footer = tagList(
      textInput(ns("element_name"), "Element Name", paste0("Element", round(runif(1) * 10000000, 0))),
      modalButton("Cancel"),
      actionButton(ns("edit_element_ok"), "Load")
    ),
    size = "l"
  )
}
