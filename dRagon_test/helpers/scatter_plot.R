create_scatter_plot <- function(df, prim_var, sec_var) {
  validate(
    need(nrow(df) > 0, "Select regions on the map to add their values to this graph.")
  )
  
  df$name <- ifelse(is.na(df$NAME_2), as.character(df$ST), as.character(df$NAME_2))

  df %>%
    group_by(name) %>%
    e_charts_(prim_var) %>%
    e_scatter_(sec_var, symbol_size = 15) %>%
    e_axis_labels(
      x = prim_var,
      y = sec_var
    ) %>%
    e_x_axis(
      nameLocation = "center", nameGap = 30,
      min = floor(0.9 * min(df[[prim_var]]))
    ) %>%
    e_y_axis(
      nameLocation = "center", nameGap = 50,
      min = floor(0.9 * min(df[[sec_var]]))
    ) %>%
    e_tooltip(
      formatter = htmlwidgets::JS(paste0("
        function(params){
          return(
            '<strong>' + params.seriesName + '</strong><br />", 
            prim_var, ": ' + params.value[0] +  '<br />", 
            sec_var, ": ' + params.value[1]
          )
        } 
      "))
    )
}
