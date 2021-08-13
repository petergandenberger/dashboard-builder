mod_healthdown_ui <- function() {
  tagList(
    tags$head(
      tags$link(rel = "stylesheet", type = "text/css", href = "bootstrap.min.css"),
      tags$link(rel = "stylesheet", type = "text/css", href = "style-app.css"),
      tags$link(rel = "stylesheet", type = "text/css", href = "style.css"),
      tags$link(rel = "stylesheet", type = "text/css", href = "gridstack/dist/gridstack.min.css"),
      tags$script(src = "gridstack.js", type = "module"),
      tags$script(src = "gridstack/dist/gridstack-h5.js")
      #includeScript(path = "www/overlay.js"),
    ),
    # we need shinyjs for the leafdown map
    useShinyjs(),
    fluidRow(
      class = "top-row",
      box(
        width = 2,
        class = "card-hexagon",
        img(src = "assets/images/hex-healthdown.png"),
        div("Health Ranking", class = "card-hexagon-title")
      ),
      box(
        width = 8,
        height = "100px",
        fluidRow(
          div(
            class = "spread3evenly",
            div(
              class = "var-dropdown",
              pickerInput(
                inputId = "year",
                label = "Select the Year",
                choices = all_years,
                selected = max(all_years)
              )
            ),
            div(
              class = "var-dropdown",
              pickerInput(
                inputId = "prim_var",
                label = "Select the Primary Variable",
                choices = all_vars,
                selected = all_vars[1]
              )
            ),
            div(
              class = "var-dropdown",
              pickerInput(
                inputId = "sec_var",
                label = "Select the Secondary Variable",
                choices = all_vars,
                selected = all_vars[2]
              )
            )
          )
        )
      ),
      box(
        width = 2,
        class = "card-hexagon",
        div(style = "height: 100px; width: 100px", 
        img(src = "assets/images/hex-leafdown.png"),
        div(
          class = "card-hexagon-title",
          tags$a(
            "Leafdown", 
            tags$i(class = "fas fa-xs fa-external-link-alt"), 
            href = "https://github.com/hoga-it/leafdown", 
            target = "_blank", 
            style = "color: white;"
          )
        )
      )
      )
    ),
    
    # ---- second row
    div(
      class = "grid-stack",
      div(
        class = "grid-stack-item", 
        'gs-w' = '2', 'gs-h' = '10', 'gs-x' = '0', 'gs-y' = '0',
        div(
          class = "grid-stack-item-content dR-box",
          DT::dataTableOutput("mytable", height = "100%"))
      ),
      div(
        class = "grid-stack-item", 
        'gs-w' = '5', 'gs-h' = '5', 'gs-x' = '2', 'gs-y' = '0',
        div(
          class = "grid-stack-item-content dR-box",
          actionButton("drill_down", "Drill Down", icon = icon("arrow-down"), class = "drill-button healthdown-button"),
          actionButton("drill_up", "Drill Up", icon = icon("arrow-up"), class = "drill-button healthdown-button"),
          leafletOutput("leafdown", height = "100%")
        )
      ),
      tags$div(
        class = "grid-stack-item", 
        'gs-w' = '5', 'gs-h' = '5', 'gs-x' = '7', 'gs-y' = '0',
        div(
          class = "grid-stack-item-content dR-box",
          echarts4rOutput("bar", height = "30vh")
        )
      ),
      div(
        class = "grid-stack-item", 
        'gs-w' = '5', 'gs-h' = '5', 'gs-x' = '2', 'gs-y' = '5',
        div(
          class = "grid-stack-item-content dR-box",
          echarts4rOutput("line", height = "30vh")
        )
      ),
      div(
        class = "grid-stack-item",
        'gs-w' = '5', 'gs-h' = '5', 'gs-x' = '7', 'gs-y' = '5',
        div(
          class = "grid-stack-item-content dR-box",
          echarts4rOutput("scatter", height = "30vh")
        )
      )
    )
  )
}
