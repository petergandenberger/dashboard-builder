#' element_render_server
#'
#' @description A utils function
#'
#' @return The return value, if any, from executing the utility.
#'
#' @import ggplot2
#'
#' @noRd
element_render_server <- function(input, output, element, dat, ns) {
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
element_render_ui <- function(element, ns, w = 3, h = 3, x = -1, y = -1) {
  position <- paste0(', "x": ', x, ', "y": ', y)
  if(x == -1) {
    position <- ""
  }
  element_container <- paste0('{"w": ', w, ', "h": ', h, position,
                              ', "id": "c_', element$element_name,'", ',
    '"content": "<button class = \\"settings\\" id = \\"btn_edit_', element$element_name,
    '\\" data-target = \\"', element$element_name, '\\"',
    ' onclick = \\"openModal(this.dataset.target, `', ns(""), '`)\\" style = \\"right: 50px\\"><i class=\\"fa fa-cog\\"></i></button>',
    '<button class = \\"settings\\" id = \\"btn_delete_', element$element_name,
    '\\" data-target = \\"', element$element_name, '\\"',
    ' onclick = \\"deleteElement(this.dataset.target, `', ns(""), '`)\\"><i class=\\"fa fa-times\\"></i></button>"}')

  js$add_grid_element(grid_id = ns("grid-dashboard"), element = element_container)

  if(element$add_bounding_box) {
    content <- shinydashboardPlus::box(
      title = element$display_name, id = ns(paste0("box_", element$element_name)),
      width = 12, height = "100%",
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
element_delete <- function(element_id, grid_id, store) {
  removeUI(
    selector = paste0(".grid-stack-item[gs-id='c_", element_id, "'] .grid-stack-item-content"),
    immediate = TRUE
  )
  shinyjs::js$remove_grid_element(grid_id = grid_id, element_id = paste0("c_", element_id))
  store$del(element_id)
}
