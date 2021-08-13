overwrite_join <- function(x, y, by = NULL){
  bycols <- which(colnames(x) %in% by) 
  commoncols <- which(colnames(x) %in% colnames(y))
  duplicatecols <- commoncols[!commoncols %in% bycols]
  x %>% select(-all_of(duplicatecols)) %>% left_join(y, by = by)
}


percent <- function(x, digits = 2, format = "f", ...) {
  paste0(formatC(x * 100, format = format, digits = digits, ...), "%")
}

create_labels <- function(data, map_level, prim_var, sec_var) {
  labels <- sprintf(
    "<strong>%s</strong><br/>
    %s: %s<br/>
    %s: %s<br/>
    </sup>",
    data[, paste0("NAME_", map_level)],
    prim_var, data[, prim_var],
    sec_var, data[, sec_var]
  )
  labels %>% lapply(htmltools::HTML)
}
