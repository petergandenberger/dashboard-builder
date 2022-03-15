ui <- function() {
  tagList(
    tags$head(
      tags$link(rel = "stylesheet", type = "text/css", href = "style-app.css"),
      tags$link(rel = "stylesheet", type = "text/css", href = "https://cdnjs.cloudflare.com/ajax/libs/font-awesome/4.7.0/css/font-awesome.min.css")
    ),
    # we need shinyjs for the leafdown map
    useShinyjs(),
    tags$script("function openModal(id) {
                Shiny.setInputValue('open_modal', id, {priority: 'event'});
    }"),
    # ---- header
    tags$header(
      class = "site-header",
      div(
        style = "padding: 0 20px;",
        class="wrapper site-header__wrapper",
        div(
          style = "margin: 0 20px;",
          actionButton("add_element", "Add Element", 
                       style = "margin-top: 50%; transform: translateY(-50%);", 
                       class = "healthdown-button")
        )
      )
    ),
    tags$hr(),
    div(class = "modal", id = "esquisseModal",
      esquisse_ui(
        id = "esquisse", 
        controls = c("labs", "parameters", "appearance", "filters"),
        header = FALSE # dont display gadget title
      ),
      div(
        actionButton("close_modal", "Close"),
        actionButton("save_modal", "Save"),
        style = "width: 80%; margin-left: 10%;"
      )
    ),
    # ---- second row
    grid_stack()
  )
}
