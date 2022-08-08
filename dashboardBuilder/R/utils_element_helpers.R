#' element_render_server
#'
#' @description A utils function
#'
#' @return The return value, if any, from executing the utility.
#'
#' @noRd
element_render_server <- function(input, output, element) {
  code <- element$code_element
  if(!is.null(element$code_preprocessing)) {
    code <- paste0(element$code_preprocessing, "\n", code)
  }

  x <- {eval(parse(text = code))}
  output[[element$element_name]] <- element$renderFunction(x)
}


#' element_render_ui
#'
#' @description A utils function
#'
#' @return The return value, if any, from executing the utility.
#'
#'
#' @import shinyjs
#'
#' @noRd
element_render_ui <- function(element) {
  js$add_grid_stack_element(paste0('{"w": 3, "h": 3, "id": "c_', element$element_name,'", ',
                                   '"content": "<button class = \\"settings\\" id = \\"btn_edit_', element$element_name,
                                   '\\" data-target = \\"', element$element_name, '\\"',
                                   ' onclick = \\"openModal(this.dataset.target)\\" style = \\"right: 40px\\"><i class=\\"fa fa-cog\\"></i></button>',
                                   '<button class = \\"settings\\" id = \\"btn_delete_', element$element_name,
                                   '\\" data-target = \\"', element$element_name, '\\"',
                                   ' onclick = \\"deleteElement(this.dataset.target)\\"><i class=\\"fa fa-times\\"></i></button>"}'))

  if(element$add_bounding_box) {
    content <- box(
      title = element$display_name, status = "success", solidHeader = TRUE,
      width = 12, height = "100%", collapsible = F,
      element$uiOutput
    )
  } else {
    content <- element$uiOutput
  }

  insertUI(
    selector = paste0("div[gs-id = 'c_", element$element_name, "'] .grid-stack-item-content"),
    where = "afterBegin",
    content
  )
}


#' element_delete
#'
#' @description A utils function
#'
#' @return The return value, if any, from executing the utility.
#'
#' @noRd
element_delete <- function(element_id, store) {
  removeUI(
    selector = paste0(".grid-stack-item[gs-id='c_", element_id, "'")
  )
  store$del(element_id)
}
