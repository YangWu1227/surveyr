# Test data ---------------------------------------------------------------

df <- readr::read_csv(test_path("testdata.csv"), show_col_types = FALSE)

list_xtab <- tibble::tribble(
  ~x, ~y, ~caption,
  "education_rollup", "party_reg", "caption1",
  "education_rollup", "issue_focus", "caption2",
  "issue_focus", "party_reg", "caption3"
)

list_topline <- tibble::tribble(
  ~x, ~caption,
  "education_rollup", "caption1",
  "party_reg", "caption2",
  "issue_focus", "caption3"
)

# Errors ------------------------------------------------------------------

test_that("Invalid input for 'l' (list)", {
  expect_snapshot(
    x = generate_tbls(
      l = list(list_topline),
      df = df,
      weight = "weightvec",
      type = "topline",
      output = "word"
    ),
    error = TRUE
  )
  expect_snapshot(
    x = generate_tbls(
      l = list(list_xtab),
      df = df,
      weight = "weightvec",
      type = "crosstab",
      output = "latex"
    ),
    error = TRUE
  )
})

test_that("Invalid input for 'df' (list)", {
  expect_snapshot(
    x = generate_tbls(
      l = list_topline,
      df = list(df),
      weight = "weightvec",
      type = "topline",
      output = "word"
    ),
    error = TRUE
  )
  expect_snapshot(
    x = generate_tbls(
      l = list_xtab,
      df = list(df),
      weight = "weightvec",
      type = "crosstab",
      output = "latex"
    ),
    error = TRUE
  )
})

test_that("Invalid input for 'weight' (correct type but incorrect value)", {
  expect_snapshot(
    x = generate_tbls(
      l = list_topline,
      df = df,
      weight = "var_do_not_exist",
      type = "topline",
      output = "word"
    ),
    error = TRUE
  )
  expect_snapshot(
    x = generate_tbls(
      l = list_xtab,
      df = df,
      weight = "var_do_not_exist",
      type = "crosstab",
      output = "latex"
    ),
    error = TRUE
  )
})

test_that("invalid input for 'weight' (no quotes around 'weight' variable but correct value)", {
  expect_snapshot(
    x = generate_tbls(
      l = list_topline,
      df = df,
      weight = weightvec,
      type = "topline",
      output = "word"
    ),
    error = TRUE
  )
  expect_snapshot(
    x = generate_tbls(
      l = list_xtab,
      df = df,
      weight = weightvec,
      type = "crosstab",
      output = "latex"
    ),
    error = TRUE
  )
})

test_that("Invalid input for 'type' (wrong type)", {
  expect_snapshot(
    x = generate_tbls(
      l = list_topline,
      df = df,
      weight = "weightvec",
      type = FALSE,
      output = "latex"
    ),
    error = TRUE
  )
  expect_snapshot(
    x = generate_tbls(
      l = list_xtab,
      df = df,
      weight = "weightvec",
      type = 3,
      output = "word"
    ),
    error = TRUE
  )
})

test_that("Invalid input for 'type' (incorect value)", {
  expect_snapshot(
    x = generate_tbls(
      l = list_topline,
      df = df,
      weight = "weightvec",
      type = "incorrect",
      output = "word"
    ),
    error = TRUE
  )
  expect_snapshot(
    x = generate_tbls(
      l = list_xtab,
      df = df,
      weight = "weightvec",
      type = crosstab,
      output = "latex"
    ),
    error = TRUE
  )
})

test_that("Invalid input for 'output' (wrong type)", {
  expect_snapshot(
    x = generate_tbls(
      l = list_xtab,
      df = df,
      weight = "weightvec",
      type = "topline",
      output = 3
    ),
    error = TRUE
  )
  expect_snapshot(
    x = generate_tbls(
      l = list_xtab,
      df = df,
      weight = "weightvec",
      type = "crosstab",
      output = TRUE
    ),
    error = TRUE
  )
})

test_that("Invalid input for 'output' (correct type but incorrect value)", {
  expect_snapshot(
    x = generate_tbls(
      l = list_xtab,
      df = df,
      weight = "weightvec",
      type = "topline",
      output = "should_be_word_or_latex"
    ),
    error = TRUE
  )
  expect_snapshot(
    x = generate_tbls(
      l = list_xtab,
      df = df,
      weight = "weightvec",
      type = "crosstab",
      output = word
    ),
    error = TRUE
  )
})

test_that("Mismatched 'type' argument and 'l' list argument", {
  expect_snapshot(
    x = generate_tbls(
      l = list_topline,
      df = df,
      weight = "weightvec",
      # Mismatched
      type = "crosstab",
      output = "word"
    ),
    error = TRUE
  )
  expect_snapshot(
    x = generate_tbls(
      l = list_xtab,
      df = df,
      weight = "weightvec",
      # Mismatched
      type = "topline",
      output = "latex"
    ),
    error = TRUE
  )
})

# Functionality -----------------------------------------------------------

test_that("generate_tbls() returns correct output type and class", {
  # Test examples
  list_of_topline_word <- generate_tbls(
    l = list_topline,
    df = df,
    weight = "weightvec",
    type = "topline",
    output = "word"
  )
  list_of_xtab_word <- generate_tbls(
    l = list_xtab,
    df = df,
    weight = "weightvec",
    type = "crosstab",
    output = "word"
  )
  list_of_topline_latex <- generate_tbls(
    l = list_topline,
    df = df,
    weight = "weightvec",
    type = "topline",
    output = "latex"
  )
  list_of_xtab_latex <- generate_tbls(
    l = list_xtab,
    df = df,
    weight = "weightvec",
    type = "crosstab",
    output = "latex"
  )
  # Correct type?
  expect_vector(
    object = generate_tbls(
      l = list_topline,
      df = df,
      weight = "weightvec",
      type = "topline",
      output = "word"
    ),
    ptype = list()
  )
  expect_vector(
    object = generate_tbls(
      l = list_xtab,
      df = df,
      weight = "weightvec",
      type = "crosstab",
      output = "word"
    ),
    ptype = list()
  )
  expect_vector(
    object = generate_tbls(
      l = list_topline,
      df = df,
      weight = "weightvec",
      type = "topline",
      output = "latex"
    ),
    ptype = list()
  )
  expect_vector(
    object = generate_tbls(
      l = list_xtab,
      df = df,
      weight = "weightvec",
      type = "crosstab",
      output = "latex"
    ),
    ptype = list()
  )
  # Do list elements have the right class? (toplines)
  # Word
  expect_s3_class(
    object = list_of_topline_word[[1]],
    class = c("flextable")
  )
  expect_s3_class(
    object = list_of_topline_word[[2]],
    class = c("flextable")
  )
  expect_s3_class(
    object = list_of_topline_word[[3]],
    class = c("flextable")
  )
  # Latex
  expect_s3_class(
    object = list_of_topline_latex[[1]],
    class = c("kableExtra", "knitr_kable")
  )
  expect_s3_class(
    object = list_of_topline_latex[[2]],
    class = c("kableExtra", "knitr_kable")
  )
  expect_s3_class(
    object = list_of_topline_latex[[3]],
    class = c("kableExtra", "knitr_kable")
  )
  # Do list elements have the right class? (crosstabs)
  # Word
  expect_s3_class(
    object = list_of_xtab_word[[1]],
    class = c("flextable")
  )
  expect_s3_class(
    object = list_of_xtab_word[[2]],
    class = c("flextable")
  )
  expect_s3_class(
    object = list_of_xtab_word[[3]],
    class = c("flextable")
  )
  # Latex
  expect_s3_class(
    object = list_of_xtab_latex[[1]],
    class = c("kableExtra", "knitr_kable")
  )
  expect_s3_class(
    object = list_of_xtab_latex[[2]],
    class = c("kableExtra", "knitr_kable")
  )
  expect_s3_class(
    object = list_of_xtab_latex[[3]],
    class = c("kableExtra", "knitr_kable")
  )
})
