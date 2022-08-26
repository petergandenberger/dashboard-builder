#' right_sidebar helper function
#'
#' @description function to create the right sidebar at the main page
#'
#' @noRd
#'
#' @importFrom shinydashboardPlus dashboardControlbar
#'
right_sidebar <- function () {
  dashboardControlbar(
    id = "right_sidebar",
    skin = "dark",
    collapsed = FALSE,
    div(id = "sidebar_data",
      div(class="header",
        h3("Data"),
      ),
      div(class="body",
        tags$ul(
          tags$li(id = "import_data_btn", icon("upload"), mod_import_data_ui("import_data")),
          tags$li(textOutput("txt_current_dataset"), style = "padding-left: 20px;")
        )
      )
    ),
    div(id = "sidebar_edit",
      div(class="header",
          h3("Edit"),
      ),
      div(class="body",
          tags$ul(
            tags$li(id = "element_add_btn", icon("square-plus"),
                    actionButton("element_add", "Add Element", class = "sidebar-button")),
            tags$li(id = "filter_add_btn", icon("filter"),
                    actionButton("filter_add", "Add Filter", class = "sidebar-button"))
          )
      )
    ),
    div(id = "sidebar_export",
      div(class="header",
          h3("Export"),
      ),
      div(class="body",
          tags$ul(
            tags$li(id = "export_btn", icon("download"),
                    mod_export_dashboard_ui("export_dashboard"))
          )
      )
    ),
    div(id = "sidebar_dashboard",
      div(class="header",
          h3("Dashboard"),
      ),
      div(class="body",
          tags$ul(
            tags$li(icon("info"), actionButton("load_example", "Load Example Dashboard", class = "sidebar-button")),
            tags$li(icon("save"), actionButton("save_dashboard", "Save Dashboard", class = "sidebar-button")),
            tags$li(id = "load_dashboard", fileInput("load_dashboard", NULL, accept = c(".RDS"),
                                                     buttonLabel = list(icon("folder-open"), "Upload Dashboard"))),
            downloadButton("downloadSavedDashboard", "Download", style = "visibility: hidden;")
          )
      )
    )
  )
}
