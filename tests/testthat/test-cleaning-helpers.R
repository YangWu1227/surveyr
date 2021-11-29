# Tests for rm_spl_char() -------------------------------------------------

# Errors ------------------------------------------------------------------

test_that("rm_spl_char() provides meaningful error messages", {
  # Invalid type for df (vector)
  expect_snapshot(x = rm_spl_char(df = c(3, 4), var = c("col_1")), error = TRUE)
  # Invalid type for df (list)
  expect_snapshot(x = rm_spl_char(df = list(3, body(dplyr::mutate)), var = c("col_1")), error = TRUE)
  # Invalid type for df (matrix)
  expect_snapshot(x = rm_spl_char(df = matrix(1:4, nrow = 2), var = c("col_1")), error = TRUE)
  # Invalid type for var (wrong type numeric but should be character)
  expect_snapshot(x = rm_spl_char(df = as.data.frame(matrix(1:4, nrow = 2)), var = c(3)), error = TRUE)
  # Invalid type for var (right type but number of cols > number of columns in df)
  expect_snapshot(x = rm_spl_char(df = as.data.frame(matrix(1:4, ncol = 1)), var = c("V1", "V2")), error = TRUE)
  # Not all columsn in 'var' are found in 'df'
  expect_snapshot(x = rm_spl_char(df = as.data.frame(matrix(1:4, ncol = 2)), var = c("V1", "V9")), error = TRUE)
})

# Functionality -----------------------------------------------------------

test_that("rm_spl_char() returns correct value type and correct output", {
  # Testing input
  df <- tibble::tibble(
    col1 = rep(c("test_that"), 5),
    col2 = rep(c("test-that"), 5),
    col3 = rep(c("test/that"), 5)
  )
  # Should return an object that inherits from data.frame class
  expect_s3_class(rm_spl_char(df, c("col1", "col2", "col3")), class = "data.frame")
  # Should return an object of the same class as the input
  expect_s3_class(rm_spl_char(df, c("col1")), class = sloop::s3_class(df), exact = TRUE)
  # Does the returned data frame have special characters removed?
  expect_snapshot_output(rm_spl_char(df, c("col1", "col2", "col3")),
    cran = FALSE,
    variant = "rm_spl_char_all_columns"
  )
  expect_snapshot_output(rm_spl_char(df, c("col1", "col2")),
    cran = FALSE,
    variant = "rm_spl_char_subset_of_columns"
  )
})

# Tests for col_nms_to_title() --------------------------------------------

# Errors ------------------------------------------------------------------

test_that("col_nms_to_title() provides meaningful error messages", {
  # Invalid type for df (vector)
  expect_snapshot(x = col_nms_to_title(df = c(3, 4)), error = TRUE)
  # Invalid type for df (list)
  expect_snapshot(x = col_nms_to_title(df = list(3, body(dplyr::mutate))), error = TRUE)
  # Invalid type for df (matrix)
  expect_snapshot(x = col_nms_to_title(df = matrix(1:4, nrow = 2)), error = TRUE)
})

# Functionality -----------------------------------------------------------

test_that("col_nms_to_title() returns correct value type and correct output", {
  # Testing input
  df <- tibble::tibble(
    col1 = rep(c("test_that"), 1),
    col2 = rep(c("test-that"), 1),
    col3 = rep(c("test/that"), 1)
  )
  # Should return an object that inherits from data.frame class
  expect_s3_class(col_nms_to_title(df), class = "data.frame")
  # Should return an object of the same class as the input
  expect_s3_class(col_nms_to_title(df), class = sloop::s3_class(df), exact = TRUE)
  # Snapshot
  expect_snapshot_output(
    x = col_nms_to_title(df),
    cran = FALSE,
    variant = "col_nms_to_title"
  )
})

# Tests for col_nms_rm_splchar() ------------------------------------------

# Errors ------------------------------------------------------------------

test_that("col_nms_rm_splchar() provides meaningful error messages", {
  # Invalid type for df (vector)
  expect_snapshot(x = col_nms_rm_splchar(df = c(3, 4)), error = TRUE)
  # Invalid type for df (list)
  expect_snapshot(x = col_nms_rm_splchar(df = list(3, body(dplyr::mutate))), error = TRUE)
  # Invalid type for df (matrix)
  expect_snapshot(x = col_nms_rm_splchar(df = matrix(1:4, nrow = 2)), error = TRUE)
})

# Functionality -----------------------------------------------------------

test_that("col_nms_rm_splchar() returns correct value type and correct output", {
  # Testing input
  df <- tibble::tibble(
    col_1 = rep(c("test_that"), 1),
    `col/2` = rep(c("test-that"), 1),
    `col.3` = rep(c("test/that"), 1),
    `col!4` = rep(c("test/that"), 1),
  )
  # Should return an object that inherits from data.frame class
  expect_s3_class(col_nms_rm_splchar(df), class = "data.frame")
  # Should return an object of the same class as the input
  expect_s3_class(col_nms_rm_splchar(df), class = sloop::s3_class(df), exact = TRUE)
  # Snapshot
  expect_snapshot_output(
    x = col_nms_rm_splchar(df),
    cran = FALSE,
    variant = "col_nms_rm_splchar"
  )
})
