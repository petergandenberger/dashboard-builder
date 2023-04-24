test_that("test row- & col-splits", {
  # abb
  # abb
  layout_input <- rbind(c('a', 'b', 'b'), c('a', 'b', 'b'))

  row_splits <- find_row_splits(layout_input)
  expect_equal(row_splits, c())
  col_splits <- find_col_splits(layout_input)
  expect_equal(col_splits, c(1))

  # aaacc
  # bbbbb
  layout_input <- rbind(c('a', 'a', 'a', 'c', 'c'), c('b', 'b', 'b', 'b', 'b'))

  row_splits <- find_row_splits(layout_input)
  expect_equal(row_splits, c(1))
  col_splits <- find_col_splits(layout_input)
  expect_equal(col_splits, c())

  # aac
  # bbb
  # dee
  layout_input <- rbind(c('a', 'a', 'c'), c('b', 'b', 'b'), c('d', 'e', 'e'))

  row_splits <- find_row_splits(layout_input)
  expect_equal(row_splits, c(1, 2))
  col_splits <- find_col_splits(layout_input)
  expect_equal(col_splits, c())


  # aacf
  # bbbf
  # deef
  layout_input <- rbind(c('a', 'a', 'c', 'f'), c('b', 'b', 'b', 'f'), c('d', 'e', 'e', 'f'))

  row_splits <- find_row_splits(layout_input)
  expect_equal(row_splits, c())
  col_splits <- find_col_splits(layout_input)
  expect_equal(col_splits, c(3))

  # aad
  # cbd
  # cee
  layout_input <- rbind(c('a', 'a', 'd'), c('c', 'b', 'd'), c('c', 'e', 'e'))

  row_splits <- find_row_splits(layout_input)
  expect_equal(row_splits, c())
  col_splits <- find_col_splits(layout_input)
  expect_equal(col_splits, c())
})
