create_mytable <- function(all_data, sel_data, map_level, prim_var) {
  if (map_level == 1) {
    curr_gid <- "GID_1"
    extension <- list()
  } else {
    curr_gid <- "GID_2"
    extension <- 'RowGroup'
  }
  
  sel_ids <- which(all_data[[curr_gid]] %in% sel_data[[curr_gid]])
  data_sub <- subset_tbl_data(all_data, map_level, prim_var)
  DT::datatable(
    data_sub, rownames = FALSE, selection = list(selected = sel_ids), extensions = extension,
    options = table_options(map_level)
  )
  
}

subset_tbl_data <- function(df, map_level, prim_var) {
  rel_columns <- c("ST", prim_var)
  if (map_level == 2) {
    rel_columns <- c(rel_columns, "NAME_2")
  }
  df_sub <- df[, rel_columns]
  if (map_level == 2) {
    df_sub <- df_sub[, c(3, 2, 1)]
    names(df_sub)[1] <- "County"
  }
  df_sub
}

table_options <- function(map_level) {
  tbl_options <- list(
    dom = 'ft', deferRender = TRUE, scrollY = "55vh", scroller = TRUE, paging = FALSE, bSort = FALSE
  )
  if (map_level == 2) {
    tbl_options <- c(
      tbl_options, 
      list(
        rowGroup = list(dataSrc = 2), 
        columnDefs = list(list(visible = FALSE, targets = 2))
      )
    )
  }
  tbl_options
}
