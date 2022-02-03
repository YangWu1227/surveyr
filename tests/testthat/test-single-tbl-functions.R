# Test data ---------------------------------------------------------------

df <- readr::read_csv(test_path("testdata.csv"), show_col_types = FALSE)

# Tests for generate_xtab()  -----------------------------------------

# Errors ------------------------------------------------------------------

test_that("generate_xtab() provides meaningful error messages", {
  # Invalid input for 'df' (list)
  expect_snapshot(
    x = generate_xtab(
      df = list("2", body(dplyr::mutate)),
      x = "education_rollup",
      y = "party_reg",
      weight = "weightvec",
      caption = "caption"
    ),
    error = TRUE
  )
  # Invalid input for 'caption' (numeric)
  expect_snapshot(
    x = generate_xtab(
      df = df,
      x = "education_rollup",
      y = "party_reg",
      weight = "weightvec",
      caption = 3
    ),
    error = TRUE
  )
  # Invalid input for 'caption' (correct type but wrong length)
  expect_snapshot(
    x = generate_xtab(
      df = df,
      x = "education_rollup",
      y = "party_reg",
      weight = "weightvec",
      caption = c("caption1", "caption2")
    ),
    error = TRUE
  )
  # Invalid input for "x", "y", or "weight" (numeric)
  expect_snapshot(
    x = generate_xtab(
      df = df,
      x = 3,
      y = "party_reg",
      weight = "weightvec",
      caption = "caption"
    ),
    error = TRUE
  )
  # Invalid input for "x", "y", or "weight" (correct type but wrong length)
  expect_snapshot(
    x = generate_xtab(
      df = df,
      x = c("education_rollup", "party_reg"),
      y = "party_reg",
      weight = "weightvec",
      caption = "caption"
    ),
    error = TRUE
  )
  # Invalid input for "x", "y", or "weight" (correct type but wrong length)
  expect_snapshot(
    x = generate_xtab(
      df = df,
      x = "party_reg",
      y = TRUE,
      weight = "weightvec",
      caption = "caption"
    ),
    error = TRUE
  )
})

test_that("generate_xtab() errors when specifing x, y, or weight that does not exist", {
  expect_snapshot(
    x = generate_xtab(
      df = df,
      x = "does_not_exist",
      y = "education_rollup",
      weight = "weightvec",
      caption = "caption"
    ),
    error = TRUE
  )
  expect_snapshot(
    x = generate_xtab(
      df = df,
      x = "education_rollup",
      y = "does_not_exist",
      weight = "weightvec",
      caption = "caption"
    ),
    error = TRUE
  )
})

# Functionality -----------------------------------------------------------

test_that("generate_xtab() returns correct output type and class", {
  # Correct s3 class?
  expect_s3_class(
    object = generate_xtab(
      df = df,
      x = "party_reg",
      y = "education_rollup",
      weight = "weightvec",
      caption = "caption"
    ),
    class = c("flextable")
  )
  # Correct base type? (should be a list)
  expect_type(
    object = generate_xtab(
      df = df,
      x = "education_rollup",
      y = "issue_focus",
      weight = "weightvec",
      caption = "caption"
    ),
    type = "list"
  )
})


# Tests for generate_xtab_3way()  -----------------------------------------

# Errors ------------------------------------------------------------------

test_that("generate_xtab_3way() provides meaningful error messages", {
  # Invalid input for 'df' (list)
  expect_snapshot(
    x = generate_xtab_3way(
      df = list("2", body(dplyr::mutate)),
      x = "education_rollup",
      y = "party_reg",
      z = "issue_focus",
      weight = "weightvec",
      caption = "caption"
    ),
    error = TRUE
  )
  # Invalid input for 'caption' (numeric)
  expect_snapshot(
    x = generate_xtab_3way(
      df = df,
      x = "education_rollup",
      y = "party_reg",
      z = "issue_focus",
      weight = "weightvec",
      caption = 3
    ),
    error = TRUE
  )
  # Invalid input for 'caption' (correct type but wrong length)
  expect_snapshot(
    x = generate_xtab_3way(
      df = df,
      x = "education_rollup",
      y = "party_reg",
      z = "issue_focus",
      weight = "weightvec",
      caption = c("caption1", "caption2")
    ),
    error = TRUE
  )
  # Invalid input for "x", "y", "z", or "weight" (numeric)
  expect_snapshot(
    x = generate_xtab_3way(
      df = df,
      x = 3,
      y = "party_reg",
      z = "issue_focus",
      weight = "weightvec",
      caption = "caption"
    ),
    error = TRUE
  )
  # Invalid input for "x", "y", "z", or "weight" (correct type but wrong length)
  expect_snapshot(
    x = generate_xtab_3way(
      df = df,
      x = c("education_rollup", "party_reg"),
      y = "party_reg",
      z = "issue_focus",
      weight = "weightvec",
      caption = "caption"
    ),
    error = TRUE
  )
  # Invalid input for "x", "y", "z", or "weight" (correct length but wrong type)
  expect_snapshot(
    x = generate_xtab_3way(
      df = df,
      x = "party_reg",
      y = TRUE,
      z = "issue_focus",
      weight = "weightvec",
      caption = "caption"
    ),
    error = TRUE
  )
  # Invalid input for "x", "y", "z", or "weight" (correct length but wrong type)
  expect_snapshot(
    x = generate_xtab_3way(
      df = df,
      x = "education_rollup",
      y = "party_reg",
      z = complex(4),
      weight = "weightvec",
      caption = "caption"
    ),
    error = TRUE
  )
})

test_that("generate_xtab_3way() errors when specifing x, y, z, or weight that does not exist", {
  expect_snapshot(
    x = generate_xtab_3way(
      df = df,
      x = "does_not_exist",
      y = "education_rollup",
      z = "issue_focus",
      weight = "weightvec",
      caption = "caption"
    ),
    error = TRUE
  )
  expect_snapshot(
    x = generate_xtab_3way(
      df = df,
      x = "education_rollup",
      y = "does_not_exist",
      z = "issue_focus",
      weight = "weightvec",
      caption = "caption"
    ),
    error = TRUE
  )
  expect_snapshot(
    x = generate_xtab_3way(
      df = df,
      x = "education_rollup",
      y = "issue_focus",
      z = "does_not_exist",
      weight = "weightvec",
      caption = "caption"
    ),
    error = TRUE
  )
})

# Functionality -----------------------------------------------------------

test_that("generate_xtab_3way() returns correct output type and class", {
  # Correct s3 class?
  expect_s3_class(
    object = generate_xtab_3way(
      df = df,
      x = "education_rollup",
      y = "issue_focus",
      z = "party_reg",
      weight = "weightvec",
      caption = "caption"
    ),
    class = c("flextable")
  )
  # Correct base type? (should be a list)
  expect_type(
    object = generate_xtab_3way(
      df = df,
      x = "education_rollup",
      y = "issue_focus",
      z = "party_reg",
      weight = "weightvec",
      caption = "caption"
    ),
    type = "list"
  )
})


# Test for generate_topline() ----------------------------------------

# Errors ------------------------------------------------------------------

test_that("generate_topline provides meaningful error messages", {
  # Invalid input for 'df' (list)
  expect_snapshot(
    x = generate_topline(
      df = list("2", body(dplyr::mutate)),
      x = "education_rollup",
      weight = "weightvec",
      caption = "caption"
    ),
    error = TRUE
  )
  # Invalid input for 'caption' (numeric)
  expect_snapshot(
    x = generate_topline(
      df = df,
      x = "education_rollup",
      weight = "weightvec",
      caption = 3
    ),
    error = TRUE
  )
  # Invalid input for 'caption' (correct type but wrong length)
  expect_snapshot(
    x = generate_topline(
      df = df,
      x = "education_rollup",
      weight = "weightvec",
      caption = c("caption1", "caption2")
    ),
    error = TRUE
  )
  # Invalid input for "x" or "weight" (numeric)
  expect_snapshot(
    x = generate_topline(
      df = df,
      x = "party_reg",
      weight = 3,
      caption = "caption"
    ),
    error = TRUE
  )
  # Invalid input for "x" (correct type but wrong length)
  expect_snapshot(
    x = generate_topline(
      df = df,
      x = c("education_rollup", "party_reg"),
      weight = "weightvec",
      caption = "caption"
    ),
    error = TRUE
  )
  # Invalid input for "x", "y", or "weight" (correct type but wrong length)
  expect_snapshot(
    x = generate_topline(
      df = df,
      x = TRUE,
      weight = "weightvec",
      caption = "caption"
    ),
    error = TRUE
  )
})

# Functionality -----------------------------------------------------------

test_that("generate_topline() returns correct output type and class", {
  # Correct s3 class?
  expect_s3_class(
    object = generate_topline(
      df = df,
      x = "party_reg",
      weight = "weightvec",
      caption = "caption"
    ),
    class = c("flextable")
  )
  # Correct base type? (should be a list)
  expect_type(
    object = generate_topline(
      df = df,
      x = "issue_focus",
      weight = "weightvec",
      caption = "caption"
    ),
    type = "list"
  )
})
