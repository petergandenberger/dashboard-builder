#' help_overlay
#'
#' @description A utils function
#'
#' @return The return value, if any, from executing the utility.
#'
#' @noRd
help_overlay <- function() {
  div(id = "help_overlay",
      style = "position: absolute; left: 50%; top: 50%; transform: translate(-50%, -50%); max-width: 1000px;",
      shinydashboardPlus::box(
        title = "Dashboard-Builder",
        width = 12,
        status = "navy",
        "The Dashboard-Builder helps you to create Shiny-Dashboards without writing any code."
      ),
      shinydashboardPlus::box(
        title = "Tutorial",
        width = 3,
        status = "navy",
        "Learn how to use the Dashboard-Builder and its most important features.",
        actionButton("guide_dashboard", "Tutorial",
                     icon = icon("circle-question"), style = "width: 100%; margin-top: 10px;")
      ),
      shinydashboardPlus::box(
        title = "Example Dashboard",
        width = 3,
        status = "navy",
        "Load an example dashboard to see what you can do with the Dashboard-Builder.",
        br(),
        actionButton("help_load_example", "Load Example", icon = icon("table-columns"),
                     style = "width: 100%; margin-top: 10px;")
      ),
      shinydashboardPlus::box(
        title = "Documentation",
        width = 3,
        status = "navy",
        "Have a look at the documentation on how to use the Dashboard-Builder",
        br(),
        actionButton("documentation", "Documentation", icon = icon("book"),
                     onclick ="window.open('https://petergandenberger.github.io/dashboard-builder/', '_blank')",
                     style = "width: 100%; margin-top: 10px;")
      ),
       shinydashboardPlus::box(
         title = "Github Project",
         width = 3,
         status = "navy",
         "For Feedback, Bugs, and Ideas please visit our Github Project.",
         br(),
         actionButton("gitHub", "GitHub", icon = icon("github"),
                      onclick ="window.open('https://github.com/petergandenberger/dashboard-builder', '_blank')",
                      style = "width: 100%; margin-top: 10px;")
       )
  )
}
