# Test data ---------------------------------------------------------------

df <- readRDS(system.file("tests/testthat", "testdata.rds", package = "citizenr"))

# Tests for generate_xtab() -----------------------------------------------

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

# Functionality -----------------------------------------------------------

test_that("generate_xtab() returns correct output type and class", {
  # Correct s3 class?
  expect_s3_class(
    object = generate_xtab(
      df = df,
      x = "education_rollup",
      y = "party_reg",
      weight = "weightvec",
      caption = "caption"
    ),
    class = c("kableExtra", "knitr_kable")
  )
  # Correct vector size?
  expect_vector(
    object = generate_xtab(
      df = df,
      x = "education_rollup",
      y = "party_reg",
      weight = "weightvec",
      caption = "caption"
    ),
    ptype = NULL,
    size = 1
  )
})

# Test for generate_topline() ---------------------------------------------

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
    class = c("kableExtra", "knitr_kable")
  )
  # Correct vector size?
  expect_vector(
    object = generate_topline(
      df = df,
      x = "issue_focus",
      weight = "weightvec",
      caption = "caption"
    ),
    ptype = NULL,
    size = 1
  )
})
