#' guide_cicerone 
#'
#' @description Creates the Cicerone object which guides the user through the app.
#' TODO: replace the hard-coded ids
#'
#' @return The Cicerone object which guides the user through the app.
#' 
#' @import cicerone
#'
#' @noRd
create_guide <- function() {
  guide <- Cicerone$
    new()$ 
    step(
      el = "dashboard_page-import_data-import_data",
      title = "Import Data",
      description = "Import the Dataset you want to use for your dashboard."
    )$ 
    step(
      el = "dashboard_page-element_add",
      title = "Add Element(s)",
      description = "Add as many elements as you like. You can add DataTables, ValueBoxes and Graphs"
    )$
    step(
      el = "dashboard_page-export_dashboard-export",
      title = "Export Dashboard",
      description = "When you are happy with your dashboard, you can export it to get your fully functioning R-Project."
    )
  return(guide)
}