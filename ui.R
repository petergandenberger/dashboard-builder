ui <- dashboardPage(
  title = "Dashboard-Builder Demo",
  dashboardHeader(),
  dashboardSidebar(disable = TRUE),
  dashboardBody(
    useShinyjs(),
    tags$link(rel = "stylesheet", type = "text/css", href = "style-app.css"),
    
    
    tags$style(".dataTables_scroll {height: calc(100% - 100px);}
                .dataTables_wrapper {height: 100%;}
                .datatables {height: 100%!important; overflow: scroll;}"),
    
    
    tags$style("#element_name {margin-bottom: 25px;}"),
    tags$style(".grid-stack-item-content .col-sm-12 {height: 100%;}"),
    tags$style(".bs4Dash.card {height: calc(100% - 10px);}"),
    tags$style(".small-box {height: calc(100% - 10px);}"),
    tags$style(".small-box .inner {height: calc(100% - 10px);}"),
    tags$style(".grid-stack-item-content {height:100%; overflow:hidden!important;}"),
    tags$script("function openModal(id) {
                Shiny.setInputValue('open_modal', id, {priority: 'event'});
    }"),
    tags$script("function deleteElement(id) {
                Shiny.setInputValue('deleteElement', id, {priority: 'event'});
    }"),
    actionButton("add_element", "Add Element", style = "margin-top: 25px"),
    actionButton("export", "Export", style = "margin-top: 25px"),
    actionButton("import_data", "Import Data", style = "margin-top: 25px"),
    downloadButton("downloadDashboard", "Download", style = "visibility: hidden;"),
    tags$hr(),
    # ---- second row
    grid_stack(dynamic_full_window_height = TRUE, height_offset = 50)
  )            
)



