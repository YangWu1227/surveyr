# Test data ---------------------------------------------------------------

df <- readr::read_csv(test_path("testdata.csv"), show_col_types = FALSE)

# Functionalities ---------------------------------------------------------

# Topline -----------------------------------------------------------------

test_that("Custom topline function returns correct s3 class (data.table) and output", {
  # Test examples
  topline_1 <- citizenr:::topline_internal(df, issue_focus, weightvec)
  topline_2 <- citizenr:::topline_internal(df, education_rollup, weightvec)
  # Correct base type
  expect_type(
    object = topline_1,
    type = "list"
  )
  expect_type(
    object = topline_2,
    type = "list"
  )
  # S3 class (data.table)
  expect_s3_class(
    object = topline_1,
    class = c("data.table", "data.frame"),
    exact = TRUE
  )
  expect_s3_class(
    object = topline_2,
    class = c("data.table", "data.frame"),
    exact = TRUE
  )
  # Snapshots of output
  expect_snapshot_output(
    x = citizenr:::topline_internal(df, issue_focus, weightvec),
    cran = FALSE,
    variant = "custom_topline_output"
  )
  expect_snapshot_output(
    x = citizenr:::topline_internal(df, education_rollup, weightvec),
    cran = FALSE,
    variant = "custom_topline_output"
  )
})

# Crosstab ----------------------------------------------------------------

test_that("Custom crosstab function returns correct s3 class (data.table) and output", {
  # Test examples
  xtab_1 <- citizenr:::moe_crosstab_internal(df, issue_focus, education_rollup, weightvec)
  xtab_2 <- citizenr:::moe_crosstab_internal(df, party_reg, education_rollup, weightvec)
  # Correct base type
  expect_type(
    object = xtab_1,
    type = "list"
  )
  expect_type(
    object = xtab_2,
    type = "list"
  )
  # S3 class (data.table)
  expect_s3_class(
    object = xtab_1,
    class = c("data.table", "data.frame"),
    exact = TRUE
  )
  expect_s3_class(
    object = xtab_2,
    class = c("data.table", "data.frame"),
    exact = TRUE
  )
  # Snapshots of output
  expect_snapshot_output(
    x = citizenr:::moe_crosstab_internal(df, issue_focus, education_rollup, weightvec),
    cran = FALSE,
    variant = "custom_xtab_output"
  )
  expect_snapshot_output(
    x = citizenr:::moe_crosstab_internal(df, party_reg, education_rollup, weightvec),
    cran = FALSE,
    variant = "custom_xtab_output"
  )
})

# Three-way crosstab ------------------------------------------------------

test_that("Custom three-way crosstab function returns correct s3 class (data.table) and output", {
  # Test examples
  xtab_3way_1 <- citizenr:::moe_crosstab_3way_internal(df, issue_focus, education_rollup, party_reg, weightvec)
  xtab_3way_2 <- citizenr:::moe_crosstab_3way_internal(df, party_reg, education_rollup, issue_focus, weightvec)
  # Correct base type
  expect_type(
    object = xtab_3way_1,
    type = "list"
  )
  expect_type(
    object = xtab_3way_2,
    type = "list"
  )
  # S3 class (data.table)
  expect_s3_class(
    object = xtab_3way_1,
    class = c("data.table", "data.frame"),
    exact = TRUE
  )
  expect_s3_class(
    object = xtab_3way_2,
    class = c("data.table", "data.frame"),
    exact = TRUE
  )
  # Snapshots of output
  expect_snapshot_output(
    x = citizenr:::moe_crosstab_3way_internal(df, issue_focus, education_rollup, party_reg, weightvec),
    cran = FALSE,
    variant = "custom_xtab_output"
  )
  expect_snapshot_output(
    x = citizenr:::moe_crosstab_3way_internal(df, party_reg, education_rollup, issue_focus, weightvec),
    cran = FALSE,
    variant = "custom_xtab_output"
  )
})
