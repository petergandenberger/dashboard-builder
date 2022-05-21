ui <- dashboardPage(
  title = "Dashboard-Builder Demo",
  dashboardHeader(actionButton("add_element", "Add Element", style = "margin: 15px"),
                  actionButton("import_data", "Import Data", style = "margin: 15px"),
                  actionButton("export", "Export", style = "margin: 15px"),
                  downloadButton("downloadDashboard", "Download", style = "visibility: hidden;")),
  dashboardSidebar(disable = TRUE),
  dashboardBody(
    useShinyjs(),
    tags$link(rel = "stylesheet", type = "text/css", href = "style-app.css"),
    tags$script("function openModal(id) {
                Shiny.setInputValue('open_modal', id, {priority: 'event'});
    }"),
    tags$script("function deleteElement(id) {
                Shiny.setInputValue('deleteElement', id, {priority: 'event'});
    }"),
    # ---- ui
    grid_stack(dynamic_full_window_height = TRUE, height_offset = 50)
  )            
)



