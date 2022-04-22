# Tests for instantiation -------------------------------------------------

test_that("Test that instantaition works for different inputs", {
  # Test data
  df <- data.frame("x" = 2)
  data_cleaner <- FrameCleaner$new(df)
  tb_cleaner <- FrameCleaner$new(as_tibble(df))
  dt_cleaner <- FrameCleaner$new(as.data.table(df))


  # Check 'df' fields

  expect_s3_class(
    object = data_cleaner$df,
    class = c("data.table", "data.frame"),
    exact = TRUE
  )
  expect_s3_class(
    object = tb_cleaner$df,
    class = c("data.table", "data.frame"),
    exact = TRUE
  )
  expect_s3_class(
    object = dt_cleaner$df,
    class = c("data.table", "data.frame"),
    exact = TRUE
  )

  # Check 'col_nms' fields

  expect_equal(
    object = data_cleaner$col_nms,
    expected = c("x")
  )
  expect_equal(
    object = tb_cleaner$col_nms,
    expected = c("x")
  )
  expect_equal(
    object = dt_cleaner$col_nms,
    expected = c("x")
  )

  # Check 'ptype' fields

  expect_equal(
    object = data_cleaner$ptype,
    expected = vec_ptype(data.frame("x" = 9))
  )
  expect_equal(
    object = tb_cleaner$ptype,
    expected = vec_ptype(tibble("x" = 9))
  )
  expect_equal(
    object = dt_cleaner$ptype,
    expected = vec_ptype(data.table("x" = 10))
  )
})

test_that("Instantiation should not affect original input data", {
  # Test data
  df <- data.frame("x" = 2)
  tb <- tibble("x" = 2)

  df_cleaner <- FrameCleaner$new(df)
  tb_cleaner <- FrameCleaner$new(tb)

  # Original objects should be preserved
  expect_s3_class(
    object = df,
    class = c("data.frame"),
    exact = TRUE
  )
  expect_s3_class(
    object = tb,
    class = c("tbl_df", "tbl", "data.frame"),
    exact = TRUE
  )
})

# Tests for 'col_nms_trim' method -----------------------------------------

test_that("Test that 'col_nms_trim' method on tibble and data.table inputs", {
  # Test data
  tb <- tibble("  leading" = 1, "trailing  " = 2, "  both    " = 3)
  dt <- data.table("  leading" = 1, "trailing  " = 2, "  both    " = 3)

  # Trim column names
  tb_cleaner <- FrameCleaner$new(tb)
  dt_cleaner <- FrameCleaner$new(dt)
  tb_cleaner$col_nms_trim()
  dt_cleaner$col_nms_trim()

  expect_equal(
    object = tb_cleaner$col_nms,
    expected = c("leading", "trailing", "both")
  )
  # Data.table input is modified in place
  # Therefore, 'dt' should be modified
  expect_equal(
    object = names(dt),
    expected = c("leading", "trailing", "both")
  )

  # Restore for 'tb' returns a copy
  expect_equal(
    object = tb_cleaner$restore(),
    expected = tibble("leading" = 1, "trailing" = 2, "both" = 3)
  )
  # Restore 'dt' should return original object
  expect_true(rlang::is_reference(dt_cleaner$restore(), dt))
})
