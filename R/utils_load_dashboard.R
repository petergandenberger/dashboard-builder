#' load_dashboard
#'
#' @description A fct function
#'
#' @return The return value, if any, from executing the function.
#'
#' @noRd
load_dashboard <- function (st, grid_id, loaded_dashboard, data, triggers_dashboard_page) {
  if(length(st$list()) > 0) {
    shinyalert(
      title = "Load dashboard?",
      callbackR = function(overwrite) {
        if(isTRUE(overwrite)) {
          removeUI(
            selector = paste0(".grid-stack-item-content"),
            multiple = TRUE,
            immediate = TRUE
          )
          shinyjs::js$remove_all_grid_elements(grid_id = grid_id)
          st$del(st$list())
          data$data <- reactiveVal(loaded_dashboard$data)
          data$name <- reactiveVal(loaded_dashboard$data_name)
          triggers_dashboard_page$loaded_dashboard <- loaded_dashboard
        }
      },
      text = "This will delete the current dashboard!",
      type = "warning",
      showCancelButton = TRUE,
      confirmButtonCol = '#DD6B55',
      confirmButtonText = 'Yes!'
    )
  } else {
    data$data <- reactiveVal(loaded_dashboard$data)
    data$name <- reactiveVal(loaded_dashboard$data_name)
    triggers_dashboard_page$loaded_dashboard <- loaded_dashboard
  }
}

#' is_valid_dashbard
#'
#' @description A fct function
#'
#' @return TRUE if the dashboard is valid, FALSE otherwise
#'
#' @import checkmate
#'
#' @noRd
is_valid_dashbard <- function(dashboard) {
  if(!testList(dashboard, any.missing = FALSE)) {return(FALSE)}
  if(!check_set_equal(names(dashboard), c("elements", "layout" ,"data", "data_name"))) {return(FALSE)}
  return(TRUE)
}
