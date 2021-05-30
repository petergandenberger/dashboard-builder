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
    htmltools::htmlDependency(
      name = "gridstack",
      version = "4.2.3",
      package = "dRagon",
      src = "assets",
      script = c("gridstackjs/gridstack-h5.js", "gridstackeR.js"),
      stylesheet = "gridstackjs/gridstack.min.css"
    ),
    div(
      class = "grid-stack",
      ...
    ),
    shiny::tags$script(
      paste0("initGridstackeR(", opts, ", ", ncols, ");")
    )
  )
}

#' Grid Stack Item
#'
#' @description
#' This is a wrapper for the individual items to be displayed in the \link{grid_stack}
#' Check the \href{https://github.com/gridstack/gridstack.js/tree/master/doc#item-options}{ gridstack documentation}
#' for more information.
#'
#' @param ... content to include in the grid stack item
#' @param autoPosition tells to ignore x and y attributes and to place element to the first
#' available position. Having either one missing will also do that
#' @param x,y element position in column/row.
#' Note: if one is missing this will \code{autoPosition} the item
#' @param w,h element size in column/row
#' @param maxW,minW,maxH,minH element constraints in column/row (default none)
#' @param locked means another widget wouldn't be able to move it during dragging or resizing.
#' The widget can still be dragged or resized by the user.
#' You need to add \code{noResize} and \code{noMove} attributes to completely lock the widget.
#' @param noResize disable element resizing
#' @param noMove disable element moving
#' @param resizeHandles - widgets can have their own custom resize handles.
#' For example 'e,w' will make that particular widget only resize east and west.
#'
#' @importFrom shiny div
#' @export
grid_stack_item <- function(...,
                            autoPosition = '', x = '', y = '', w = '', h = '',
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
