#' The application server-side
#'
#' @param input,output,session Internal parameters for {shiny}.
#'     DO NOT REMOVE.
#' @import shiny
#' @noRd
app_server <- function(input, output, session) {
  path <- tempfile("storr_")
  st <- storr::storr_rds(path)

  # Your application server logic
  mod_export_dashboard_server("export_dashboard")

  data <- mod_import_data_server("import_data")

  dat <- observe({
    req(data)
    observe()
    data$data()
  })

  new_element <- mod_add_element_server("add_element", data, st)

}
