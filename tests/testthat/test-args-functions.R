# Test data ---------------------------------------------------------------

df <- readr::read_csv("/Users/kenwu/Rpkg/citizenr/tests/testthat/testdata.csv", show_col_types = FALSE)

# Errors ------------------------------------------------------------------

test_that("Invalid input for 'df'", {
  # Crosstab: invalid input for 'df'
  expect_snapshot(
    x = generate_xtab_args(
      df = c(3, 4),
      var_of_interest = "party_reg",
      rm = "weightvec"
    ),
    error = TRUE
  )
  # Topline: invalid input for 'df'
  expect_snapshot(
    x = generate_topline_args(
      df = c(3, 4),
      var_of_interest = "party_reg",
      rm = "weightvec"
    ),
    error = TRUE
  )
})

test_that("Invalid input for 'var_of_interest' (wrong type and length)", {
  # Crosstab: invalid input for 'var_of_interest' (wrong type)
  expect_snapshot(
    x = generate_xtab_args(
      df = df,
      var_of_interest = 3,
      rm = "weightvec"
    ),
    error = TRUE
  )
  # Topline: invalid input for 'var_of_interest' (wrong type)
  expect_snapshot(
    x = generate_topline_args(
      df = df,
      var_of_interest = 3,
      rm = "weightvec"
    ),
    error = TRUE
  )
  # Crosstab: invalid input for 'var_of_interest' (wrong length)
  expect_snapshot(
    x = generate_xtab_args(
      df = df,
      var_of_interest = c("education_rollup", "issue_focus"),
      rm = "weightvec"
    ),
    error = TRUE
  )
  # Topline: invalid input for 'var_of_interest' (wrong length)
  expect_snapshot(
    x = generate_topline_args(
      df = df,
      var_of_interest = c(
        "education_rollup", "issue_focus",
        "issue_focus", "issue_focus", "issue_focus"
      ),
      rm = "weightvec"
    ),
    error = TRUE
  )
})

test_that("Invalid input for 'rm' (incorrect value not found in df)", {
  # Crosstab: invalid input for 'rm' (incorrect value not found in df)
  expect_snapshot(
    x = generate_xtab_args(
      df = df,
      var_of_interest = "education_rollup",
      rm = "non_existent_var"
    ),
    error = TRUE
  )
  # Topline: invalid input for 'rm' (incorrect value not found in df)
  expect_snapshot(
    x = generate_topline_args(
      df = df,
      var_of_interest = "party_reg",
      rm = "non_existent_var"
    ),
    error = TRUE
  )
})

test_that("Invalid input for 'rm' (wrong type)", {
  # Crosstab: invalid input for 'rm' (wrong type)
  expect_snapshot(
    x = generate_xtab_args(
      df = df,
      var_of_interest = "education_rollup",
      rm = 3
    ),
    error = TRUE
  )
  # Topline: invalid input for 'rm' (wrong type)
  expect_snapshot(
    x = generate_topline_args(
      df = df,
      var_of_interest = "party_reg",
      rm = list("test")
    ),
    error = TRUE
  )
})

test_that("Invalid input for 'dependent_var'", {
  # Wrong type
  expect_snapshot(
    x = generate_xtab_args(
      df = df,
      var_of_interest = "education_rollup",
      dependent_vars = 3,
      rm = "weightvec"
    ),
    error = TRUE
  )
  # Wrong length
  expect_snapshot(
    x = generate_xtab_args(
      df = df,
      var_of_interest = "education_rollup",
      dependent_vars = c(
        "issue_focus",
        "party_reg",
        "weightvec",
        "education_rollup"
      ),
      rm = NULL
    ),
    error = TRUE
  )
})

# Functionality -----------------------------------------------------------

test_that("Argument generators return correct s3 class", {
  # NULL cases
  expect_s3_class(
    object = generate_xtab_args(
      df = df,
      var_of_interest = "issue_focus",
      dependent_vars = NULL,
      rm = NULL
    ),
    class = c("tbl_df", "tbl", "data.frame"),
    exact = TRUE
  )
  expect_s3_class(
    object = generate_topline_args(
      df = df,
      var_of_interest = "issue_focus",
      rm = NULL
    ),
    class = c("tbl_df", "tbl", "data.frame"),
    exact = TRUE
  )
  # Non-NULL
  expect_s3_class(
    object = generate_xtab_args(
      df = df,
      var_of_interest = "issue_focus",
      dependent_vars = c("education_rollup", "issue_focus", "party_reg"),
      rm = "weightvec"
    ),
    class = c("tbl_df", "tbl", "data.frame"),
    exact = TRUE
  )
  expect_s3_class(
    object = generate_topline_args(
      df = df,
      var_of_interest = "issue_focus",
      rm = c("education_rollup", "issue_focus", "party_reg")
    ),
    class = c("tbl_df", "tbl", "data.frame"),
    exact = TRUE
  )
})

test_that("Snapshots of random outputs", {
  # Crosstab
  expect_snapshot_output(
    x = generate_xtab_args(
      df = df,
      var_of_interest = "issue_focus",
      dependent_vars = NULL,
      rm = NULL
    ),
    cran = FALSE,
    variant = "xtab_args_output"
  )
  expect_snapshot_output(
    x = generate_xtab_args(
      df = df,
      var_of_interest = "issue_focus",
      dependent_vars = c("education_rollup", "issue_focus", "party_reg"),
      rm = "weightvec"
    ),
    cran = FALSE,
    variant = "xtab_args_output"
  )
  # Topline
  expect_snapshot_output(
    x = generate_topline_args(
      df = df,
      var_of_interest = "issue_focus",
      rm = NULL
    ),
    cran = FALSE,
    variant = "topline_args_output"
  )
  expect_snapshot_output(
    x = generate_topline_args(
      df = df,
      var_of_interest = "issue_focus",
      rm = c("education_rollup", "issue_focus", "party_reg")
    ),
    cran = FALSE,
    variant = "topline_args_output"
  )
})
