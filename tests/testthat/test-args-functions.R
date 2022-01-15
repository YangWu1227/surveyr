# Test data ---------------------------------------------------------------

df <- readr::read_csv(test_path("testdata.csv"), show_col_types = FALSE)

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
  # Three-way crosstab: invalid input for 'df'
  expect_snapshot(
    x = generate_xtab_3way_args(
      df = c(3, 4),
      control_var = "party_reg",
      independent_vars = c("education_rollup", "issue_focus"),
      dependent_vars = c("issue_focus", "education_rollup")
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

test_that("Invalid input for 'control_var' wrong type, length, and value", {
  # Wrong type
  expect_snapshot(
    x = generate_xtab_3way_args(
      df = df,
      control_var = complex(3),
      independent_vars = c("education_rollup", "issue_focus"),
      dependent_vars = c("issue_focus", "education_rollup")
    ),
    error = TRUE
  )
  # Wrong length
  expect_snapshot(
    x = generate_xtab_3way_args(
      df = df,
      control_var = c("party_reg", "party_reg"),
      independent_vars = c("education_rollup", "issue_focus"),
      dependent_vars = c("issue_focus", "education_rollup")
    ),
    error = TRUE
  )
  # Wrong value
  expect_snapshot(
    x = generate_xtab_3way_args(
      df = df,
      control_var = "does_not_exist",
      independent_vars = c("education_rollup", "issue_focus"),
      dependent_vars = c("issue_focus", "education_rollup")
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

test_that("Invalid input for 'dependent_var' for two-way crosstabs", {
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

test_that("Invalid inputs for 'independent_var' and 'dependent_var' for three-way crosstabs", {
  # Wrong type for independent
  expect_snapshot(
    x = generate_xtab_3way_args(
      df = df,
      control_var = "party_reg",
      independent_vars = c(3),
      dependent_vars = c("issue_focus", "education_rollup")
    ),
    error = TRUE
  )
  # Wrong length for independent
  expect_snapshot(
    x = generate_xtab_3way_args(
      df = df,
      control_var = "party_reg",
      independent_vars = c("issue_focus", "education_rollup", "issue_focus", "education_rollup"),
      dependent_vars = c("issue_focus", "education_rollup")
    ),
    error = TRUE
  )
  # Indepedent variables do not exist
  expect_snapshot(
    x = generate_xtab_3way_args(
      df = df,
      control_var = "party_reg",
      independent_vars = c("not", "exist", "issue_focus"),
      dependent_vars = c("issue_focus", "education_rollup")
    ),
    error = TRUE
  )
  # Wrong type for dependent
  expect_snapshot(
    x = generate_xtab_3way_args(
      df = df,
      control_var = "party_reg",
      independent_vars = c("issue_focus", "education_rollup"),
      dependent_vars = c(3)
    ),
    error = TRUE
  )
  # Wrong length for dependent
  expect_snapshot(
    x = generate_xtab_3way_args(
      df = df,
      control_var = "party_reg",
      independent_vars = c("issue_focus", "education_rollup"),
      dependent_vars = c("issue_focus", "education_rollup", "issue_focus", "education_rollup")
    ),
    error = TRUE
  )
  # Depedent variables do not exist
  expect_snapshot(
    x = generate_xtab_3way_args(
      df = df,
      control_var = "party_reg",
      independent_vars = c("issue_focus", "education_rollup"),
      dependent_vars = c("not", "exist", "issue_focus")
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
    object = generate_xtab_3way_args(
      df = df,
      control_var = "issue_focus",
      dependent_vars = c("education_rollup", "party_reg"),
      independent_vars = c("party_reg", "education_rollup")
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
  # Two-way crosstab
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
  # Three-way crosstab
  expect_snapshot_output(
    x = generate_xtab_3way_args(
      df = df,
      control_var = "issue_focus",
      dependent_vars = c("education_rollup", "party_reg"),
      independent_vars = c("party_reg", "education_rollup")
    ),
    cran = FALSE,
    variant = "xtab_3way_args_output"
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
