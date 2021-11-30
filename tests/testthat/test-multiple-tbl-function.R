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
      type = "topline"
    ),
    error = TRUE
  )
  expect_snapshot(
    x = generate_tbls(
      l = list(list_xtab),
      df = df,
      weight = "weightvec",
      type = "crosstab"
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
      type = "topline"
    ),
    error = TRUE
  )
  expect_snapshot(
    x = generate_tbls(
      l = list_xtab,
      df = list(df),
      weight = "weightvec",
      type = "crosstab"
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
      type = "topline"
    ),
    error = TRUE
  )
  expect_snapshot(
    x = generate_tbls(
      l = list_xtab,
      df = df,
      weight = "var_do_not_exist",
      type = "crosstab"
    ),
    error = TRUE
  )
})

test_that("nvalid input for 'weight' (no quotes around 'weight' variable but correct value)", {
  expect_snapshot(
    x = generate_tbls(
      l = list_topline,
      df = df,
      weight = weightvec,
      type = "topline"
    ),
    error = TRUE
  )
  expect_snapshot(
    x = generate_tbls(
      l = list_xtab,
      df = df,
      weight = weightvec,
      type = "crosstab"
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
      type = FALSE
    ),
    error = TRUE
  )
  expect_snapshot(
    x = generate_tbls(
      l = list_xtab,
      df = df,
      weight = "weightvec",
      type = 3
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
      type = "incorrect"
    ),
    error = TRUE
  )
  expect_snapshot(
    x = generate_tbls(
      l = list_xtab,
      df = df,
      weight = "weightvec",
      type = crosstab
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
      type = "crosstab"
    ),
    error = TRUE
  )
  expect_snapshot(
    x = generate_tbls(
      l = list_xtab,
      df = df,
      weight = "weightvec",
      # Mismatched
      type = "topline"
    ),
    error = TRUE
  )
})

# Functionality -----------------------------------------------------------

test_that("generate_tbls() returns correct output type and class", {
  # Test example
  list_of_topline <- generate_tbls(
    l = list_topline,
    df = df,
    weight = "weightvec",
    type = "topline"
  )
  list_of_xtab <- generate_tbls(
    l = list_xtab,
    df = df,
    weight = "weightvec",
    type = "crosstab"
  )
  # Correct type?
  expect_vector(
    object = generate_tbls(
      l = list_topline,
      df = df,
      weight = "weightvec",
      type = "topline"
    ),
    ptype = list()
  )
  expect_vector(
    object = generate_tbls(
      l = list_xtab,
      df = df,
      weight = "weightvec",
      type = "crosstab"
    ),
    ptype = list()
  )
  # Do list elements, i.e. source code, have the right class? (toplines)
  expect_s3_class(
    object = list_of_topline[[1]],
    class = c("kableExtra", "knitr_kable")
  )
  expect_s3_class(
    object = list_of_topline[[2]],
    class = c("kableExtra", "knitr_kable")
  )
  expect_s3_class(
    object = list_of_topline[[3]],
    class = c("kableExtra", "knitr_kable")
  )
  # Do list elements, i.e. source code, have the right class? (crosstabs)
  expect_s3_class(
    object = list_of_xtab[[1]],
    class = c("kableExtra", "knitr_kable")
  )
  expect_s3_class(
    object = list_of_xtab[[2]],
    class = c("kableExtra", "knitr_kable")
  )
  expect_s3_class(
    object = list_of_xtab[[3]],
    class = c("kableExtra", "knitr_kable")
  )
})
