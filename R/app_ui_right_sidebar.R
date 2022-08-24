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
    div(class="header",
      h3("Data"),
    ),
    div(class="body",
      tags$ul(
        tags$li(id = "import_data_btn", icon("upload"), mod_import_data_ui("import_data")),
        tags$li(textOutput("txt_current_dataset"), style = "padding-left: 20px;")
      )
    ),
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
    ),
    div(class="header",
        h3("Export"),
    ),
    div(class="body",
        tags$ul(
          tags$li(id = "export_btn", icon("download"),
                  mod_export_dashboard_ui("export_dashboard"))
          #tags$li(icon(name = "underline"),  "Tipography")
        )
    )
  )
}
