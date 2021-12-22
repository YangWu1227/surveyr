# Tests for generate_xtab_latex() -----------------------------------------

df <- readr::read_csv(test_path("testdata.csv"), show_col_types = FALSE)

# Errors ------------------------------------------------------------------

test_that("generate_xtab_latex() provides meaningful error messages", {
  # Invalid input for 'df' (list)
  expect_snapshot(
    x = generate_xtab_latex(
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
    x = generate_xtab_latex(
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
    x = generate_xtab_latex(
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
    x = generate_xtab_latex(
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
    x = generate_xtab_latex(
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
    x = generate_xtab_latex(
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

test_that("generate_xtab_latex() returns correct output type and class", {
  # Correct s3 class?
  expect_s3_class(
    object = generate_xtab_latex(
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
    object = generate_xtab_latex(
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


# Test for generate_topline_latex() ---------------------------------------

# Errors ------------------------------------------------------------------

test_that("generate_topline_latex provides meaningful error messages", {
  # Invalid input for 'df' (list)
  expect_snapshot(
    x = generate_topline_latex(
      df = list("2", body(dplyr::mutate)),
      x = "education_rollup",
      weight = "weightvec",
      caption = "caption"
    ),
    error = TRUE
  )
  # Invalid input for 'caption' (numeric)
  expect_snapshot(
    x = generate_topline_latex(
      df = df,
      x = "education_rollup",
      weight = "weightvec",
      caption = 3
    ),
    error = TRUE
  )
  # Invalid input for 'caption' (correct type but wrong length)
  expect_snapshot(
    x = generate_topline_latex(
      df = df,
      x = "education_rollup",
      weight = "weightvec",
      caption = c("caption1", "caption2")
    ),
    error = TRUE
  )
  # Invalid input for "x" or "weight" (numeric)
  expect_snapshot(
    x = generate_topline_latex(
      df = df,
      x = "party_reg",
      weight = 3,
      caption = "caption"
    ),
    error = TRUE
  )
  # Invalid input for "x" (correct type but wrong length)
  expect_snapshot(
    x = generate_topline_latex(
      df = df,
      x = c("education_rollup", "party_reg"),
      weight = "weightvec",
      caption = "caption"
    ),
    error = TRUE
  )
  # Invalid input for "x", "y", or "weight" (correct type but wrong length)
  expect_snapshot(
    x = generate_topline_latex(
      df = df,
      x = TRUE,
      weight = "weightvec",
      caption = "caption"
    ),
    error = TRUE
  )
})

# Functionality -----------------------------------------------------------

test_that("generate_topline_latex() returns correct output type and class", {
  # Correct s3 class?
  expect_s3_class(
    object = generate_topline_latex(
      df = df,
      x = "party_reg",
      weight = "weightvec",
      caption = "caption"
    ),
    class = c("kableExtra", "knitr_kable")
  )
  # Correct vector size?
  expect_vector(
    object = generate_topline_latex(
      df = df,
      x = "issue_focus",
      weight = "weightvec",
      caption = "caption"
    ),
    ptype = NULL,
    size = 1
  )
})


# Tests for generate_xtab_docx()  -----------------------------------------

# Errors ------------------------------------------------------------------

test_that("generate_xtab_docx() provides meaningful error messages", {
  # Invalid input for 'df' (list)
  expect_snapshot(
    x = generate_xtab_docx(
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
    x = generate_xtab_docx(
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
    x = generate_xtab_docx(
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
    x = generate_xtab_docx(
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
    x = generate_xtab_docx(
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
    x = generate_xtab_docx(
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

test_that("generate_xtab_docx() returns correct output type and class", {
  # Correct s3 class?
  expect_s3_class(
    object = generate_xtab_docx(
      df = df,
      x = "education_rollup",
      y = "party_reg",
      weight = "weightvec",
      caption = "caption"
    ),
    class = c("flextable")
  )
  # Correct base type? (should be a list)
  expect_type(
    object = generate_xtab_docx(
      df = df,
      x = "education_rollup",
      y = "issue_focus",
      weight = "weightvec",
      caption = "caption"
    ),
    type = "list"
  )
})


# Test for generate_topline_docx() ----------------------------------------

# Errors ------------------------------------------------------------------

test_that("generate_topline_docx provides meaningful error messages", {
  # Invalid input for 'df' (list)
  expect_snapshot(
    x = generate_topline_docx(
      df = list("2", body(dplyr::mutate)),
      x = "education_rollup",
      weight = "weightvec",
      caption = "caption"
    ),
    error = TRUE
  )
  # Invalid input for 'caption' (numeric)
  expect_snapshot(
    x = generate_topline_docx(
      df = df,
      x = "education_rollup",
      weight = "weightvec",
      caption = 3
    ),
    error = TRUE
  )
  # Invalid input for 'caption' (correct type but wrong length)
  expect_snapshot(
    x = generate_topline_docx(
      df = df,
      x = "education_rollup",
      weight = "weightvec",
      caption = c("caption1", "caption2")
    ),
    error = TRUE
  )
  # Invalid input for "x" or "weight" (numeric)
  expect_snapshot(
    x = generate_topline_docx(
      df = df,
      x = "party_reg",
      weight = 3,
      caption = "caption"
    ),
    error = TRUE
  )
  # Invalid input for "x" (correct type but wrong length)
  expect_snapshot(
    x = generate_topline_docx(
      df = df,
      x = c("education_rollup", "party_reg"),
      weight = "weightvec",
      caption = "caption"
    ),
    error = TRUE
  )
  # Invalid input for "x", "y", or "weight" (correct type but wrong length)
  expect_snapshot(
    x = generate_topline_docx(
      df = df,
      x = TRUE,
      weight = "weightvec",
      caption = "caption"
    ),
    error = TRUE
  )
})

# Functionality -----------------------------------------------------------

test_that("generate_topline_docx() returns correct output type and class", {
  # Correct s3 class?
  expect_s3_class(
    object = generate_topline_docx(
      df = df,
      x = "party_reg",
      weight = "weightvec",
      caption = "caption"
    ),
    class = c("flextable")
  )
  # Correct base type? (should be a list)
  expect_type(
    object = generate_topline_docx(
      df = df,
      x = "issue_focus",
      weight = "weightvec",
      caption = "caption"
    ),
    type = "list"
  )
})
