#' utils_gridstackeR_to_rowcol
#'
#' @description A fct function
#'
#' @return The return value, if any, from executing the function.
#'
#' @noRd
gridstackeR_to_rowcol <- function(layout) {
  split <- split_rows(layout)
  if(!split) {
    split <- split_cols(layout)
  }
  return(split)
}

split_rows <- function(layout) {
  if(contains_only_one_element(layout)) {
    element <- list(type = 'el', size = nrow(layout), content = layout[1, 1])
    return(element)
  }
  row_split_indices <- find_row_splits(layout)
  if(length(row_split_indices) == 0) {
    return(FALSE)
  } else {
    row_splits <- get_row_splits(layout, row_split_indices)
    rows <- list()
    for(split in row_splits) {
      content_split <- split_cols(split)
      if(typeof(content_split) == 'logical' && content_split == FALSE) {
        return(FALSE)
      } else {
        row <- list(type = 'row', size = nrow(split), content = content_split)
        rows <- append(rows, row)
      }
    }
    return(rows)
  }
}

split_cols <- function(layout) {
  if(contains_only_one_element(layout)) {
    element <- list(type = 'el', size = ncol(layout), content = layout[1, 1])
    return(element)
  }
  col_split_indices <- find_col_splits(layout)
  if(length(col_split_indices) == 0) {
    return(FALSE)
  } else {
    col_splits <- get_col_splits(layout, col_split_indices)
    cols <- list()
    for(split in col_splits) {
      content_split <- split_rows(split)
      if(typeof(content_split) == 'logical' && content_split == FALSE) {
        return(FALSE)
      } else {
        col <- list(type = 'col', size = ncol(split), content = content_split)
        cols <- append(cols, col)
      }
    }
    return(cols)
  }
}

find_row_splits <- function(layout) {
  splits <- c()
  for(row in 1:(nrow(layout)-1)) {
    if (all(layout[row, ] != layout[row+1, ])) {
      splits <- c(splits, row)
    }
  }
  return(splits)
}

find_col_splits <- function(layout) {
  splits <- c()
  for(col in 1:(ncol(layout)-1)) {
    if (all(layout[, col] != layout[, col+1])) {
      splits <- c(splits, col)
    }
  }
  return(splits)
}

get_col_splits <- function(layout, col_splits) {
  layout_split <- list()
  col_splits <- c(0, col_splits, ncol(layout))
  for(s in 1:(length(col_splits) - 1)) {
    layout_split <- c(layout_split, list(layout[, (col_splits[s]+1):col_splits[s+1]]))
  }
  return(layout_split)
}

get_row_splits <- function(layout, row_splits) {
  layout_split <- list()
  row_splits <- c(0, row_splits, nrow(layout))
  for(s in 1:(length(row_splits) - 1)) {
    layout_split <- c(layout_split, list(layout[(row_splits[s]+1):row_splits[s+1], ]))
  }
  return(layout_split)
}

contains_only_one_element <- function(layout) {
  return(length(unique(unlist(layout))) == 1)
}

