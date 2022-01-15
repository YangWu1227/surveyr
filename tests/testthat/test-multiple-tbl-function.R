# Test data ---------------------------------------------------------------

df <- readr::read_csv(test_path("testdata.csv"), show_col_types = FALSE)

list_xtab <- tibble::tribble(
  ~x, ~y, ~caption,
  "education_rollup", "party_reg", "caption1",
  "education_rollup", "issue_focus", "caption2",
  "issue_focus", "party_reg", "caption3"
)

list_xtab_3way <- list_xtab_3way_args(
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
) |>
  flatten_args()

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
      type = "crosstab_2way"
    ),
    error = TRUE
  )
  expect_snapshot(
    x = generate_tbls(
      l = list(list_xtab_3way),
      df = df,
      weight = "weightvec",
      type = "crosstab_3way"
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
      type = "crosstab_2way"
    ),
    error = TRUE
  )
  expect_snapshot(
    x = generate_tbls(
      l = list_xtab_3way,
      df = list(df),
      weight = "weightvec",
      type = "crosstab_3way"
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
      type = "crosstab_2way"
    ),
    error = TRUE
  )
  expect_snapshot(
    x = generate_tbls(
      l = list_xtab_3way,
      df = df,
      weight = "var_do_not_exist",
      type = "crosstab_3way"
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
      type = "topline"
    ),
    error = TRUE
  )
  expect_snapshot(
    x = generate_tbls(
      l = list_xtab,
      df = df,
      weight = weightvec,
      type = "crosstab_2way"
    ),
    error = TRUE
  )
  expect_snapshot(
    x = generate_tbls(
      l = list_xtab_3way,
      df = df,
      weight = weightvec,
      type = "crosstab_3way"
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
  expect_snapshot(
    x = generate_tbls(
      l = list_xtab_3way,
      df = df,
      weight = "weightvec",
      type = 1:2 + 1i * (8:9)
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
      type = crosstab_2way
    ),
    error = TRUE
  )
  expect_snapshot(
    x = generate_tbls(
      l = list_xtab_3way,
      df = df,
      weight = "weightvec",
      type = "crosstab_3wayy"
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
      type = "crosstab_2way"
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
  expect_snapshot(
    x = generate_tbls(
      l = list_xtab_3way,
      df = df,
      weight = "weightvec",
      # Mismatched
      type = "crosstab_2way"
    ),
    error = TRUE
  )
})

# Functionality -----------------------------------------------------------

test_that("generate_tbls() returns correct output type and class", {
  # Test examples
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
    type = "crosstab_2way"
  )
  list_of_xtab_3way <- generate_tbls(
    l = list_xtab_3way,
    df = df,
    weight = "weightvec",
    type = "crosstab_3way"
  )
  # Correct type?
  expect_vector(
    object = list_of_topline,
    ptype = list()
  )
  expect_vector(
    object = list_of_xtab,
    ptype = list()
  )
  expect_vector(
    object = list_of_xtab_3way,
    ptype = list()
  )
  # Do list elements have the right class? (toplines)
  expect_s3_class(
    object = list_of_topline[[1]],
    class = c("flextable")
  )
  expect_s3_class(
    object = list_of_topline[[2]],
    class = c("flextable")
  )
  expect_s3_class(
    object = list_of_topline[[3]],
    class = c("flextable")
  )
  # Do list elements have the right class? (crosstabs)
  # Two-way
  expect_s3_class(
    object = list_of_xtab[[1]],
    class = c("flextable")
  )
  expect_s3_class(
    object = list_of_xtab[[2]],
    class = c("flextable")
  )
  expect_s3_class(
    object = list_of_xtab[[3]],
    class = c("flextable")
  )
  # Three-way
  expect_s3_class(
    object = list_of_xtab_3way[[1]],
    class = c("flextable")
  )
  expect_s3_class(
    object = list_of_xtab_3way[[2]],
    class = c("flextable")
  )
  expect_s3_class(
    object = list_of_xtab_3way[[3]],
    class = c("flextable")
  )
  expect_s3_class(
    object = list_of_xtab_3way[[4]],
    class = c("flextable")
  )
  expect_s3_class(
    object = list_of_xtab_3way[[5]],
    class = c("flextable")
  )
  expect_s3_class(
    object = list_of_xtab_3way[[6]],
    class = c("flextable")
  )
})
