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
      el = "sidebar_data",
      title = "Import Data",
      description = "Import the Dataset you want to use for your dashboard.",
      position = "left"
    )$
    step(
      el = "sidebar_edit",
      title = "Add Element(s)",
      description = "Add as many elements as you like. You can add DataTables, ValueBoxes and Graphs",
      position = "left"
    )$
    step(
      el = "dashboard_page-grid-dashboard",
      title = "Dashboard Content",
      description = "All elments you add are displayed here. You can move, scale, edit, and delete them."
    )$
    step(
      el = "sidebarItemExpanded",
      title = "Views",
      description = "View the dashboard's ui or its code.",
      position = "right"
    )$
    step(
      el = "sidebar_export",
      title = "Export Dashboard",
      description = "When you are happy with your dashboard, you can export it to get your fully functioning R-Project.",
      position = "left"
    )$
    step(
      el = "sidebar_dashboard",
      title = "Save Dashboard",
      description = "You can save and load dashbards to continue working on them at a later date or share them with frinds and coworkers.",
      position = "left"
    )
  return(guide)
}
