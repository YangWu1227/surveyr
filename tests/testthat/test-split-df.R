# Test data ---------------------------------------------------------------

df <- readr::read_rds(test_path("testdata_multiselect.rds"))
patterns <- c("no_vote", "civic_engagement", "media", "activism")

# Errors ------------------------------------------------------------------

test_that("split_df() returns meaningful error messages", {
  # Invalid input for 'df' (wrong type)
  expect_snapshot(
    x = split_df(
      list(c("Wrong_input")),
      patterns,
      "weightvec"
    ),
    error = TRUE
  )
  # Invalid input for patterns (wrong type)
  expect_snapshot(
    x = split_df(
      df,
      c(3, 4, 99),
      "weightvec"
    ),
    error = TRUE
  )
  # Invalid input for weight (no quote)
  expect_snapshot(
    x = split_df(
      df,
      patterns,
      weightvec
    ),
    error = TRUE
  )
  # Invalid input for weight (does not exist)
  expect_snapshot(
    x = split_df(
      df,
      patterns,
      "does_not_exist"
    ),
    error = TRUE
  )
})

# Functionality -----------------------------------------------------------

test_that("split_df() returns correct output type and class", {
  df_list <- split_df(df, patterns, "weightvec")
  # Correct type?
  expect_vector(
    object = df_list,
    ptype = list()
  )
  # Do list elements have the right class? (data.tables)
  expect_s3_class(
    object = df_list[[1]],
    class = c("data.table", "data.frame"),
    exact = TRUE
  )
  expect_s3_class(
    object = df_list[[2]],
    class = c("data.table", "data.frame"),
    exact = TRUE
  )
  expect_s3_class(
    object = df_list[[3]],
    class = c("data.table", "data.frame"),
    exact = TRUE
  )
  expect_s3_class(
    object = df_list[[4]],
    class = c("data.table", "data.frame"),
    exact = TRUE
  )
  # Do the name attributes of 'df_list' match the 'patterns' vector?
  expect_identical(
    object = names(df_list),
    expected = patterns
  )
})

test_that("snapshot of outputs", {
  expect_snapshot_output(
    x = split_df(df, patterns, "weightvec"),
    cran = FALSE,
    variant = "split_function_output"
  )
})
