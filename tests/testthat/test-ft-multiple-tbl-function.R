# Test data ---------------------------------------------------------------

df <- readr::read_rds(test_path("testdata_ft.rds"))

topline_args <- generate_topline_args(
  df,
  var_of_interest = names(df)[startsWith(names(df), "feeling")]
)

xtab_args <- list_xtab_args(
  df,
  var_of_interest = names(df)[startsWith(names(df), "feeling")],
  dependent_vars = rep(list(c("education_rollup", "gender")), 5)
) |>
  flatten_args()

# Errors ------------------------------------------------------------------

test_that("Invalid input for 'l' (list)", {
  expect_snapshot(
    x = ft_generate_tbls(
      l = list(topline_args),
      df = df,
      weight = "weightvec",
      type = "topline",
      output = "word"
    ),
    error = TRUE
  )
  expect_snapshot(
    x = ft_generate_tbls(
      l = list(xtab_args),
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
    x = ft_generate_tbls(
      l = topline_args,
      df = list(df),
      weight = "weightvec",
      type = "topline",
      output = "word"
    ),
    error = TRUE
  )
  expect_snapshot(
    x = ft_generate_tbls(
      l = xtab_args,
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
    x = ft_generate_tbls(
      l = topline_args,
      df = df,
      weight = "var_do_not_exist",
      type = "topline",
      output = "word"
    ),
    error = TRUE
  )
  expect_snapshot(
    x = ft_generate_tbls(
      l = xtab_args,
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
    x = ft_generate_tbls(
      l = topline_args,
      df = df,
      weight = weightvec,
      type = "topline",
      output = "word"
    ),
    error = TRUE
  )
  expect_snapshot(
    x = ft_generate_tbls(
      l = xtab_args,
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
    x = ft_generate_tbls(
      l = topline_args,
      df = df,
      weight = "weightvec",
      type = FALSE,
      output = "latex"
    ),
    error = TRUE
  )
  expect_snapshot(
    x = ft_generate_tbls(
      l = xtab_args,
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
    x = ft_generate_tbls(
      l = topline_args,
      df = df,
      weight = "weightvec",
      type = "incorrect",
      output = "word"
    ),
    error = TRUE
  )
  expect_snapshot(
    x = ft_generate_tbls(
      l = xtab_args,
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
    x = ft_generate_tbls(
      l = xtab_args,
      df = df,
      weight = "weightvec",
      type = "topline",
      output = 3
    ),
    error = TRUE
  )
  expect_snapshot(
    x = ft_generate_tbls(
      l = xtab_args,
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
    x = ft_generate_tbls(
      l = xtab_args,
      df = df,
      weight = "weightvec",
      type = "topline",
      output = "should_be_word_or_latex"
    ),
    error = TRUE
  )
  expect_snapshot(
    x = ft_generate_tbls(
      l = xtab_args,
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
    x = ft_generate_tbls(
      l = topline_args,
      df = df,
      weight = "weightvec",
      # Mismatched
      type = "crosstab",
      output = "word"
    ),
    error = TRUE
  )
  expect_snapshot(
    x = ft_generate_tbls(
      l = xtab_args,
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

test_that("ft_generate_tbls() returns correct output type and class", {
  # Test examples
  list_of_topline_word <- ft_generate_tbls(
    l = topline_args,
    df = df,
    weight = "weightvec",
    type = "topline",
    output = "word"
  )
  list_of_xtab_word <- ft_generate_tbls(
    l = xtab_args,
    df = df,
    weight = "weightvec",
    type = "crosstab",
    output = "word"
  )
  list_of_topline_latex <- ft_generate_tbls(
    l = topline_args,
    df = df,
    weight = "weightvec",
    type = "topline",
    output = "latex"
  )
  list_of_xtab_latex <- ft_generate_tbls(
    l = xtab_args,
    df = df,
    weight = "weightvec",
    type = "crosstab",
    output = "latex"
  )
  # Correct type?
  expect_vector(
    object = list_of_topline_word,
    ptype = list()
  )
  expect_vector(
    object = list_of_xtab_word,
    ptype = list()
  )
  expect_vector(
    object = list_of_topline_latex,
    ptype = list()
  )
  expect_vector(
    object = list_of_xtab_latex,
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
  expect_s3_class(
    object = list_of_topline_word[[4]],
    class = c("flextable")
  )
  expect_s3_class(
    object = list_of_topline_word[[5]],
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
  expect_s3_class(
    object = list_of_topline_latex[[4]],
    class = c("kableExtra", "knitr_kable")
  )
  expect_s3_class(
    object = list_of_topline_latex[[5]],
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
  expect_s3_class(
    object = list_of_xtab_word[[4]],
    class = c("flextable")
  )
  expect_s3_class(
    object = list_of_xtab_word[[5]],
    class = c("flextable")
  )
  expect_s3_class(
    object = list_of_xtab_word[[6]],
    class = c("flextable")
  )
  expect_s3_class(
    object = list_of_xtab_word[[7]],
    class = c("flextable")
  )
  expect_s3_class(
    object = list_of_xtab_word[[8]],
    class = c("flextable")
  )
  expect_s3_class(
    object = list_of_xtab_word[[9]],
    class = c("flextable")
  )
  expect_s3_class(
    object = list_of_xtab_word[[10]],
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
  expect_s3_class(
    object = list_of_xtab_latex[[4]],
    class = c("kableExtra", "knitr_kable")
  )
  expect_s3_class(
    object = list_of_xtab_latex[[5]],
    class = c("kableExtra", "knitr_kable")
  )
  expect_s3_class(
    object = list_of_xtab_latex[[6]],
    class = c("kableExtra", "knitr_kable")
  )
  expect_s3_class(
    object = list_of_xtab_latex[[7]],
    class = c("kableExtra", "knitr_kable")
  )
  expect_s3_class(
    object = list_of_xtab_latex[[8]],
    class = c("kableExtra", "knitr_kable")
  )
  expect_s3_class(
    object = list_of_xtab_latex[[9]],
    class = c("kableExtra", "knitr_kable")
  )
  expect_s3_class(
    object = list_of_xtab_latex[[10]],
    class = c("kableExtra", "knitr_kable")
  )
})
