#' The application User-Interface
#'
#' @param request Internal parameter for `{shiny}`.
#'     DO NOT REMOVE.
#' @import shiny
#' @import shinydashboard
#' @noRd
app_ui <- function(request) {
  tagList(
    # Leave this function for adding external resources
    golem_add_external_resources(),
    # Your application UI logic
    dashboardPage(
      header = shinydashboardPlus::dashboardHeader(title = "Dashboard-Builder",
                      leftUi = tagList(
                        mod_import_data_ui("import_data"),
                        actionButton("add_element", "Add Element"),
                        mod_export_dashboard_ui("export_dashboard")
                      )
      ),
      dashboardSidebar(
        sidebarMenu(
          id = "tabs",
          menuItem("Dashboard", tabName = "dashboard", icon = icon("dashboard")),
          menuItem("About", tabName = "about", icon = icon("info"))
        )
      ),
      dashboardBody(
        tabItems(
          # First tab content
          tabItem(tabName = "dashboard",
                  mod_dashboard_page_ui("dashboard_page")
          ),

          # Second tab content
          tabItem(tabName = "about",
                  mod_about_ui("about")
          )
        )
      )
    )
  )
}

#' Add external Resources to the Application
#'
#' This function is internally used to add external
#' resources inside the Shiny application.
#'
#' @import shiny
#' @importFrom golem add_resource_path activate_js favicon bundle_resources
#' @noRd
golem_add_external_resources <- function() {
  add_resource_path(
    "www",
    app_sys("app/www")
  )

  tags$head(
    favicon(),
    bundle_resources(
      path = app_sys("app/www"),
      app_title = "dashboardBuilder"
    ),
    shinyjs::useShinyjs()
    # Add here other external resources
    # for example, you can add shinyalert::useShinyalert()
  )
}
