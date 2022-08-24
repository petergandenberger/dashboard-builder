#' The application User-Interface
#'
#' @param request Internal parameter for `{shiny}`.
#'     DO NOT REMOVE.
#' @import shiny
#' @import shinydashboardPlus
#' @noRd
app_ui <- function(request) {
  tagList(
    # Leave this function for adding external resources
    golem_add_external_resources(),
    # Your application UI logic
    dashboardPage(
      header = dashboardHeader(
        title = "Dashboard-Builder",
        tags$li(class = "dropdown",
                actionLink("github_header", label = "", icon = icon("github"), style = "float:right;",
                           onclick ="window.open('https://github.com/petergandenberger/dashboard-builder', '_blank')"),
                actionLink("documentation_header", label = "", icon = icon("book"), style = "float:right;",
                           onclick ="window.open('https://github.com/petergandenberger/dashboard-builder', '_blank')"),
                actionLink("guide_header", label = "", icon = icon("question"), style = "float:right;")
        )
      ),
      sidebar = dashboardSidebar(
        minified = TRUE,
        collapsed = TRUE,
        shinydashboard::sidebarMenu(
          id = "tabs",
          shinydashboard::menuItem("Dashboard", tabName = "dashboard", icon = icon("dashboard")),
          shinydashboard::menuItem("About", tabName = "about", icon = icon("info"))
        )
      ),
      body = dashboardBody(
        tabItems(
          # First tab content
          tabItem(tabName = "dashboard",
                  mod_dashboard_page_ui("dashboard_page")
          ),

          # Second tab content
          tabItem(tabName = "about",
                  mod_about_ui("about")
          )
        ),
        help_overlay()
      ),
      controlbar = right_sidebar()
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
#' @importFrom cicerone use_cicerone
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
    shinyjs::useShinyjs(),
    use_cicerone()
    # Add here other external resources
    # for example, you can add shinyalert::useShinyalert()
  )
}
