#' dashboard_export
#'
#' @description exports the dashboard and downloads the files
#'
#' @return The return value, if any, from executing the utility.
#'
#' @noRd
export_dashboard <- function(input, st, saved_layout, data) {
  saveRDS(data, "out/data.RDS")

  file <- create_appR_file(st, saved_layout)

  write(file, file = "out/app.R")
  styler::style_file("out/app.R")
  files <- c("out/app.R", "out/dashboard.Rproj", "out/www/styles.css")
  files <- c(files, 'out/data.RDS')
  utils::zip(zipfile = 'out/dashboard', files)
}


create_appR_file <- function(st, saved_layout) {
  grid_stack_items <- jsonify::from_json(saved_layout)
  elements <- st$list()

  elements_ui <- ''
  for(e in elements) {
    element <- st$get(e)
    item <- grid_stack_items[grid_stack_items$id == paste0("c_", element$element_name), ]


    if(element$add_bounding_box) {
      content <- paste0('
      box(
          title = "', element$display_name, '", status = "primary", solidHeader = TRUE, width = 12,
          height = "100%", collapsible = F,
          ', element$uiOutput_name, ')')
    } else {
      content <- element$uiOutput_name
    }

    elements_ui <- paste0(elements_ui, '
    grid_stack_item(
        h = ', item$h, ', w = ', item$w, ', x = ', item$x, ', y = ', item$y,
                          ', id = "c_', element$element_name, '", style = "overflow:hidden",',
                          content, '),'
    )
  }
  # remove last comma
  elements_ui <- substr(elements_ui,1,nchar(elements_ui)-1)

  elements_server <- ''
  for(e in elements) {
    element <- st$get(e)

    code <- element$code_element
    if(!is.null(element$code_preprocessing)) {
      code <- paste0(element$code_preprocessing, "\n", code)
    }

    elements_server <- paste0(elements_server, '
    output$', element$element_name, ' <- ', element$renderFunction_name, '({
          ',code, '
    })'
    )
  }

  text <- readtext::readtext('out/app_template.R')$text
  code <- styler::style_text(code)
  code <- paste0(code, collapse = "\n")
  file <- sprintf(text, elements_ui, elements_server)
  return(file)
}
