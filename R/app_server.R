#' The application server-side
#'
#' @param input,output,session Internal parameters for {shiny}.
#'     DO NOT REMOVE.
#' @import shiny
#' @noRd
app_server <- function(input, output, session) {
  # Import Data ############################################################
  data <- reactiveValues(name = reactiveVal(NULL), data = reactiveVal(NULL))
  data_imported <- mod_import_data_server("import_data")

  observe({
    req(data_imported$data())
    if(length(st$list()) > 0) {
      shinyalert(
        title = "Import new dataset?",
        callbackR = function(overwrite) {
          if(isTRUE(overwrite)) {
            removeUI(
              selector = paste0(".grid-stack-item-content"),
              multiple = TRUE,
              immediate = TRUE
            )
            shinyjs::js$remove_all_grid_elements(grid_id = grid_id)
            st$del(st$list())
            data$name <- reactiveVal(data_imported$name())
            data$data <- reactiveVal(data_imported$data())
          }
        },
        text = "This will delete the current dashboard!",
        type = "warning",
        showCancelButton = TRUE,
        confirmButtonCol = '#DD6B55',
        confirmButtonText = 'Yes!'
      )
    } else {
      data$name <- reactiveVal(data_imported$name())
      data$data <- reactiveVal(data_imported$data())
    }
  })

  output$txt_current_dataset <- renderText({
    if(is.null(data$name())) {
      return("No dataset loaded...")
    } else {
      data$name()
    }
  })

  # Dashboard page ############################################################
  triggers_dashboard_page <- reactiveValues(add_element = NULL, add_filter = NULL, loaded_dashboard = NULL)
  observeEvent(input$element_add, {triggers_dashboard_page$add_element <- -1})
  observeEvent(input$filter_add, {triggers_dashboard_page$add_filter <- -1})

  dashboard_page_id = "dashboard_page"
  st <- mod_dashboard_page_server(dashboard_page_id, data, triggers_dashboard_page)
  grid_id <- paste0(dashboard_page_id, "-grid-dashboard")

  # Load Example ###############################################################
  observeEvent(input$load_example | input$help_load_example, {
    loaded_dashboard <- readRDS("out/example_dashboard.RDS")
    load_dashboard(st, grid_id, loaded_dashboard, data, triggers_dashboard_page)
  }, ignoreInit = TRUE)

  # Code page ##################################################################
  trigger_code_page <- reactiveVal()
  observeEvent(input$tabs, {if(input$tabs == "tab_code") {trigger_code_page(-1)}})
  mod_code_page_server("code_page", st, grid_id = grid_id, trigger_code_page)

  # EXPORT elements ############################################################
  mod_export_dashboard_server("export_dashboard", st, data, grid_id = grid_id)

  # Save Dashboard ############################################################
  observeEvent(input$save_dashboard, {
    shinyjs::js$save_grid_layout(grid_id = grid_id)
  })

  observeEvent(input[[paste0(grid_id, "_saved_layout")]], {
    saved_layout <- input[[paste0(grid_id, "_saved_layout")]]
    if(saved_layout != "[]" & length(st$list()) > 0) {
      elements <- st$mget(st$list())
      saved_dashboard <- list(elements = elements, layout = saved_layout, data = data$data(), data_name = data$name())
      saveRDS(saved_dashboard, "out/saved_dashboard.RDS")
      shinyjs::click("downloadSavedDashboard")
    } else {
      shinyalert("No Dashboard found", "Please create a Dashboard before saving!", type = "error")
    }
  })

  output$downloadSavedDashboard <- downloadHandler(
    filename = function() {
      "dashboard.RDS"
    },
    content = function(file) {
      file.copy("out/saved_dashboard.RDS", file)
    }
  )

  # Load Dashboard ############################################################
  observeEvent(input$load_dashboard, {
    loaded_dashboard <- readRDS(input$load_dashboard$datapath)

    if(is_valid_dashbard(loaded_dashboard)) {
      load_dashboard(st, grid_id, loaded_dashboard, data, triggers_dashboard_page)
    } else {
      shinyalert("Invalid Dashboard", "Please upload dashboard you saved using this dashboard-builder!", type = "error")
    }

  })


  # Guide ######################################################################
  guide <- create_guide()$init()
  observeEvent(input$guide_header | input$guide_dashboard, {
    shinyjs::removeClass(selector = "body", class = "sidebar-collapse")
    guide$start()
  }, ignoreInit = TRUE)

  # hide help overlay after data was imported
  observe({
    req(data)
    if(!is.null(data$data()) || input$tabs != "tab_dashboard"){
      shinyjs::hide("help_overlay", anim = FALSE)
    } else if(input$tabs == "tab_dashboard") {
      shinyjs::show("help_overlay", anim = FALSE)
    }
  })

  # About ############################################################
  mod_about_server("about")
}
