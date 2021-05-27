#' Set up all Grid Stack
#'
#' @description
#' This function loads all necessary resources.
#'
#' @export
useGridstackeR <- function() {
  htmltools::htmlDependency(
    name = "gridstackjs",
    version = "4.2.3",
    src = "gridstackjs",
    script = c("dist/gridstack-h5.js"),
    stylesheet = "dist/gridstack.min.css",
    all_files = FALSE
  )
}

#' Grid Stack Container
#'
#' @description
#' This acts as a container for the \link{grid_stack_item}'s.
#'
#' @param ... content to include in the container
#' @param opts grid options: check
#' \href{https://github.com/gridstack/gridstack.js/tree/master/doc#grid-options}{ gridstack documentation}
#' for more details
#' @param ncols: number of columns for the grid (If you need > 12 columns you need to generate the CSS manually)
#'
#'
#' @importFrom shiny div
#' @export
grid_stack <- function(..., opts = "{cellHeight: 70}", ncols = 12) {
  tagList(
    div(
      class = "grid-stack",
      ...
    ),
    shiny::tags$script(
      paste0("var grid = GridStack.init(", opts, ");
              grid.column(", ncols, ");")
    )
  )
}

#' Grid Stack Item
#'
#' @description
#' This is a wrapper for the individual items to be displayed in the \link{grid_stack}
#'
#' @param ... content to include in the grid stack item
#' @param w the width in columns usually 1-12
#' @param h the height in rows
#' @param x the x-position
#' @param y the y-position
#'
#' @importFrom shiny div
#' @export
grid_stack_item <- function(...,
                            autoPosition = '', w = '', h = '', x = '', y = '',
                            maxW = '', minW = '', maxH = '', minH = '',
                            locked = '', noResize = '', noMove = '', resizeHandles = '') {
  div(
    class = "grid-stack-item",
    'gs-auto-position' = autoPosition, 'gs-w' = w, 'gs-h' = h, 'gs-x' = x, 'gs-y' = y,
    'gs-max-w' = maxW, 'gs-min-w' = minW, 'gs-max-h' = maxH, 'gs-min-h' = minH,
    'gs-locked' = locked, 'gs-no-resize' = noResize,
    'gs-no-move' = noMove, 'gs-resize-handles' = resizeHandles,
    div(
      class = "grid-stack-item-content",
      ...
    )
  )
}
