mod_healthdown <- function(input, output, session) {
  my_leafdown <- Leafdown$new(spdfs_list, "leafdown", input)

  rv <- reactiveValues()
  rv$update_leafdown <- 0

  observeEvent(input$drill_down, {
    my_leafdown$drill_down()
    rv$update_leafdown <- rv$update_leafdown + 1
  })

  observeEvent(input$drill_up, {
    my_leafdown$drill_up()
    rv$update_leafdown <- rv$update_leafdown + 1
  })

  data <- reactive({
    req(rv$update_leafdown)
    data <- my_leafdown$curr_data
    
    if (my_leafdown$curr_map_level == 2) {
      data$ST <- substr(data$HASC_2, 4, 5)
      us_health_counties_year <- subset(us_health_counties, year == input$year)
      # there are counties with the same name in different states so we have to join on both
      data <- overwrite_join(data, us_health_counties_year, by = c("NAME_2", "ST"))
    } else {
      data$ST <- substr(data$HASC_1, 4, 5)
      us_health_states_year <- subset(us_health_states, year == input$year)
      data <- overwrite_join(data, us_health_states_year, by = "ST")
    }
    
    my_leafdown$add_data(data)
    data
  })


  output$leafdown <- renderLeaflet({
    req(spdfs_list)
    req(data)

    data <- data()
    data$y <- data[, input$prim_var]
    fillcolor <- leaflet::colorNumeric("Blues", data$y)
    legend_title <- input$prim_var

    labels <- create_labels(data, my_leafdown$curr_map_level, input$prim_var, input$sec_var)
    my_leafdown$draw_leafdown(
      fillColor = ~ fillcolor(data$y),
      weight = 3, 
      fillOpacity = 1, 
      color = "white", 
      label = labels
    ) %>%
      # set the view to be center on the US
      setView(-95, 39, 4) %>%
      addLegend(
        pal = fillcolor,
        values = ~ data$y,
        title = legend_title,
        opacity = 1
      )
  })

  output$line <- renderEcharts4r({
    create_line_graph(us_health_all, my_leafdown$curr_sel_data(), input$prim_var, input$sec_var)
  })

  output$scatter <- renderEcharts4r({
    create_scatter_plot(my_leafdown$curr_sel_data(), input$prim_var, input$sec_var)
  })

  output$bar <- renderEcharts4r({
    create_bar_chart(my_leafdown$curr_sel_data(), input$prim_var)
  })


  output$mytable <- DT::renderDataTable({
    all_data <- data()
    sel_data <- my_leafdown$curr_sel_data()
    map_level <- my_leafdown$curr_map_level
    create_mytable(all_data, sel_data, map_level, input$prim_var)
  })

  # (Un)select shapes in map when click on table
  observeEvent(input$mytable_row_last_clicked, {
    sel_row <- input$mytable_row_last_clicked
    sel_shape_id <- my_leafdown$curr_poly_ids[sel_row]
    my_leafdown$toggle_shape_select(sel_shape_id)
  })
}
