create_bar_chart <- function(df, prim_var) {
  
  validate(
    need(nrow(df) > 0, "Select regions on the map to add their values to this graph.")
  )
  
  df$name <- ifelse(is.na(df$NAME_2), as.character(df$ST), as.character(df$NAME_2))
  
  df %>% 
    group_by(name) %>%
    e_charts(name, stack = "grp") %>%
    e_bar_(prim_var) %>%
    e_axis_labels(y = prim_var) %>% 
    e_y_axis(nameLocation = "center", nameGap  = 30)  %>% 
    e_flip_coords() %>%
    e_tooltip(
      formatter = htmlwidgets::JS(paste0("
        function(params){
          return(
            '<strong>' + params.seriesName + '</strong><br />", 
             prim_var, ": ' + params.value[0]
          )
        } 
      "))
    )
}