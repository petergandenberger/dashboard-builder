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
          width = 4,
          status = "warning",
          "The Dashboard-Builder helps you to create Shiny-Dashboards without writing any code.",
          br(),
          br(),
          "Click 'Take a Tour' to learn how to use the Dashboard-Builder.",
          actionButton("guide_dashboard", "Take a Tour",
                       icon = icon("circle-question"), style = "width: 100%; margin-top: 10px;")
       ),
      shinydashboardPlus::box(
        title = "Example Dashboard",
        width = 4,
        status = "warning",
        "Load an example dashboard to see what you can do with the Dashboard-Builder.",
        br(),
        actionButton("help_load_example", "Load Example", icon = icon("table-columns"),
                     style = "width: 100%; margin-top: 10px;")
      ),
       shinydashboardPlus::box(
         title = "Github Project",
         width = 4,
         status = "warning",
         "For Feedback, Bugs, and Ideas please visit our Github Project.",
         br(),
         actionButton("gitHub", "GitHub", icon = icon("github"),
                      onclick ="window.open('https://github.com/petergandenberger/dashboard-builder', '_blank')",
                      style = "width: 100%; margin-top: 10px;")
       )
  )
}
