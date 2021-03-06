# Tests for list_xtab_args() ----------------------------------------------

df <- readr::read_csv(test_path("testdata.csv"), show_col_types = FALSE)

# Two-way -----------------------------------------------------------------

test_that("list_xtab_args() provides meaningful error messages", {
  # Invalid input for 'var_of_interest' (wrong type)
  expect_snapshot(
    x = list_xtab_args(
      df = df,
      var_of_interest = c(3, 4, 1)
    ),
    error = TRUE
  )
  # Invalid input for 'dependent_vars' (wrong type)
  expect_snapshot(
    x = list_xtab_args(
      df = df,
      var_of_interest = c("education_rollup", "party_reg", "issue_focus"),
      dependent_vars = c(3, 4, 5)
    ),
    error = TRUE
  )
})

test_that("list_xtab_args() does the error list accurately capture invalid input for 'df'", {
  expect_snapshot_output(
    x = list_xtab_args(
      df = list(df),
      var_of_interest = c("education_rollup", "party_reg", "issue_focus"),
      dependent_vars = NULL,
      rm = "weightvec"
    ),
    cran = FALSE,
    variant = "list_xtab_args"
  )
})

test_that("list_xtab_args() does the error list accurately capture invalid input for 'var_interest' (not found in df)", {
  expect_snapshot_output(
    x = list_xtab_args(
      df = df,
      var_of_interest = c("education_rollup", "party_reg", "issue_focus", "unknown"),
      dependent_vars = NULL,
      rm = "weightvec"
    ),
    cran = FALSE,
    variant = "list_xtab_args"
  )
})

test_that("list_xtab_args() Does the error list accurately capture invalid input for 'dependent_vars' (not in df)", {
  expect_snapshot_output(
    x = list_xtab_args(
      df = df,
      var_of_interest = c("education_rollup", "party_reg", "issue_focus"),
      dependent_vars = list(c("party_reg", "unknown"), "issue_focus", "party_reg"),
      rm = "weightvec"
    ),
    cran = FALSE,
    variant = "list_xtab_args"
  )
})

test_that("list_xtab_args() does the error list accurately capture invalid input for 'rm' (not in df and wrong type)", {
  expect_snapshot_output(
    x = list_xtab_args(
      df = df,
      var_of_interest = c("education_rollup", "party_reg", "issue_focus"),
      dependent_vars = list(c("party_reg", "issue_focus"), "issue_focus", "party_reg"),
      rm = "unknown"
    ),
    cran = FALSE,
    variant = "list_xtab_args"
  )
  expect_snapshot_output(
    x = list_xtab_args(
      df = df,
      var_of_interest = c("education_rollup", "party_reg", "issue_focus"),
      dependent_vars = list(c("party_reg", "issue_focus"), "issue_focus", "party_reg"),
      rm = c(3, 4)
    ),
    cran = FALSE,
    variant = "list_xtab_args"
  )
})

# Three-way ---------------------------------------------------------------

test_that("list_xtab_3way_args() provides meaningful error messages", {
  # Invalid input for 'control_var' (wrong type)
  expect_snapshot(
    x = list_xtab_3way_args(
      df = df,
      control_var = c(3, 4, 1),
      dependent_vars = list(c("education_rollup", "party_reg")),
      independent_vars = list(c("party_reg", "education_rollup"))
    ),
    error = TRUE
  )
})

test_that("list_xtab_3way_args() does the error list accurately capture invalid input for 'df'", {
  expect_snapshot_output(
    x = list_xtab_3way_args(
      df = list(df),
      control_var = "issue_focus",
      dependent_vars = list(c("education_rollup", "party_reg")),
      independent_vars = list(c("party_reg", "education_rollup"))
    ),
    cran = FALSE,
    variant = "list_xtab_3way_args"
  )
})

test_that("list_xtab_3way_args() does the error list accurately capture invalid input for 'control' (not found in df)", {
  expect_snapshot_output(
    x = list_xtab_3way_args(
      df = df,
      control_var = c("education_rollup", "unknown", "issue_focus"),
      dependent_vars = list(
        c("issue_focus", "party_reg"),
        c("issue_focus", "education_rollup"),
        c("party_reg", "education_rollup")
      ),
      independent_vars = list(
        c("party_reg", "issue_focus"),
        c("education_rollup", "issue_focus"),
        c("education_rollup", "party_reg")
      )
    ),
    cran = FALSE,
    variant = "list_xtab_3way_args"
  )
})

test_that("list_xtab_3way_args() does the error list accurately capture invalid input for 'dependent_vars' (not in df)", {
  expect_snapshot_output(
    x = list_xtab_3way_args(
      df = df,
      control_var = c("education_rollup", "party_reg", "issue_focus"),
      dependent_vars = list(
        c("issue_focus", "party_reg"),
        c("issue_focus", "unknown"),
        c("unknown", "education_rollup")
      ),
      independent_vars = list(
        c("party_reg", "issue_focus"),
        c("education_rollup", "issue_focus"),
        c("education_rollup", "party_reg")
      )
    ),
    cran = FALSE,
    variant = "list_xtab_3way_args"
  )
})

test_that("list_xtab_3way_args() does the error list accurately capture invalid input for 'independent_vars' (not in df)", {
  expect_snapshot_output(
    x = list_xtab_3way_args(
      df = df,
      control_var = c("education_rollup", "party_reg", "issue_focus"),
      dependent_vars = list(
        c("issue_focus", "party_reg"),
        c("issue_focus", "education_rollup"),
        c("party_reg", "education_rollup")
      ),
      independent_vars = list(
        c("party_reg", "unknwon"),
        c("education_rollup", "issue_focus"),
        c("education_rollup", "party_reg")
      )
    ),
    cran = FALSE,
    variant = "list_xtab_3way_args"
  )
})

# Tests for flatten_args() ------------------------------------------------

# Errors ------------------------------------------------------------------

test_that("flatten_args() provides meaningful error messages", {
  # Invalid input for 'l' (wrong type)
  expect_snapshot(
    x = flatten_args(c(3, 5, 6)),
    error = TRUE
  )
  # Invalid input for 'l' (right type but incorrect list, i.e., no 'result' and 'error)
  expect_snapshot(
    x = flatten_args(list("test" = c(3, 4), "error" = ("test"))),
    error = TRUE
  )
})

# Functionality -----------------------------------------------------------

test_that("Does flatten_args() return correct output type and class and snapshot", {
  # Test data
  list_of_args <- list_xtab_args(
    df = df,
    var_of_interest = c("education_rollup", "party_reg", "issue_focus"),
    dependent_vars = list(
      c("party_reg", "issue_focus"),
      c("education_rollup", "issue_focus"),
      c("party_reg", "education_rollup")
    ),
    rm = "weightvec"
  )
  list_of_args_3way <- list_xtab_3way_args(
    df = df,
    control_var = c("education_rollup", "party_reg", "issue_focus"),
    dependent_vars = list(
      c("issue_focus", "party_reg"),
      c("issue_focus", "education_rollup"),
      c("party_reg", "education_rollup")
    ),
    independent_vars = list(
      c("party_reg", "issue_focus"),
      c("education_rollup", "issue_focus"),
      c("education_rollup", "party_reg")
    )
  )
  # Class
  expect_s3_class(
    object = flatten_args(list_of_args),
    class = c("tbl_df", "tbl", "data.frame"),
    exact = TRUE
  )
  expect_s3_class(
    object = flatten_args(list_of_args_3way),
    class = c("tbl_df", "tbl", "data.frame"),
    exact = TRUE
  )
  # Snapshot
  expect_snapshot_output(
    x = flatten_args(list_of_args),
    cran = FALSE,
    variant = "list_xtab_args"
  )
  expect_snapshot_output(
    x = flatten_args(list_of_args_3way),
    cran = FALSE,
    variant = "list_xtab_3way_args"
  )
})
