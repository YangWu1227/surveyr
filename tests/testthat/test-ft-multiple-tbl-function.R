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

xtab_3way_args <- list_xtab_3way_args(
  df,
  control_var = names(df)[startsWith(names(df), "feeling")],
  independent_vars = rep(list(c("gender", "education_rollup")), 5),
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
      type = "topline"
    ),
    error = TRUE
  )
  expect_snapshot(
    x = ft_generate_tbls(
      l = list(xtab_args),
      df = df,
      weight = "weightvec",
      type = "crosstab_2way"
    ),
    error = TRUE
  )
  expect_snapshot(
    x = ft_generate_tbls(
      l = list(xtab_3way_args),
      df = df,
      weight = "weightvec",
      type = "crosstab_3way"
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
      type = "topline"
    ),
    error = TRUE
  )
  expect_snapshot(
    x = ft_generate_tbls(
      l = xtab_args,
      df = list(df),
      weight = "weightvec",
      type = "crosstab_2way"
    ),
    error = TRUE
  )
  expect_snapshot(
    x = ft_generate_tbls(
      l = xtab_3way_args,
      df = list(df),
      weight = "weightvec",
      type = "crosstab_3way"
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
      type = "topline"
    ),
    error = TRUE
  )
  expect_snapshot(
    x = ft_generate_tbls(
      l = xtab_args,
      df = df,
      weight = "var_do_not_exist",
      type = "crosstab_2way"
    ),
    error = TRUE
  )
  expect_snapshot(
    x = ft_generate_tbls(
      l = xtab_3way_args,
      df = df,
      weight = "var_do_not_exist",
      type = "crosstab_3way"
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
      type = "topline"
    ),
    error = TRUE
  )
  expect_snapshot(
    x = ft_generate_tbls(
      l = xtab_args,
      df = df,
      weight = weightvec,
      type = "crosstab_2way"
    ),
    error = TRUE
  )
  expect_snapshot(
    x = ft_generate_tbls(
      l = xtab_3way_args,
      df = df,
      weight = weightvec,
      type = "crosstab_3way"
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
      type = FALSE
    ),
    error = TRUE
  )
  expect_snapshot(
    x = ft_generate_tbls(
      l = xtab_args,
      df = df,
      weight = "weightvec",
      type = 3
    ),
    error = TRUE
  )
  expect_snapshot(
    x = ft_generate_tbls(
      l = xtab_3way_args,
      df = df,
      weight = "weightvec",
      type = 1:2 + 1i*(8:9)
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
      type = "incorrect"
    ),
    error = TRUE
  )
  expect_snapshot(
    x = ft_generate_tbls(
      l = xtab_args,
      df = df,
      weight = "weightvec",
      type = crosstab_2way
    ),
    error = TRUE
  )
  expect_snapshot(
    x = ft_generate_tbls(
      l = xtab_3way_args,
      df = df,
      weight = "weightvec",
      type = "crosstab_3wayy"
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
      type = "crosstab_2way"
    ),
    error = TRUE
  )
  expect_snapshot(
    x = ft_generate_tbls(
      l = xtab_args,
      df = df,
      weight = "weightvec",
      # Mismatched
      type = "topline"
    ),
    error = TRUE
  )
  expect_snapshot(
    x = ft_generate_tbls(
      l = xtab_3way_args,
      df = df,
      weight = "weightvec",
      # Mismatched
      type = "crosstab_2way"
    ),
    error = TRUE
  )
})

# Functionality -----------------------------------------------------------

test_that("ft_generate_tbls() returns correct output type and class", {
  # Test examples
  list_of_topline <- ft_generate_tbls(
    l = topline_args,
    df = df,
    weight = "weightvec",
    type = "topline"
  )
  list_of_xtab <- ft_generate_tbls(
    l = xtab_args,
    df = df,
    weight = "weightvec",
    type = "crosstab_2way"
  )
  list_of_xtab_3way <- ft_generate_tbls(
    l = xtab_3way_args,
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
  expect_s3_class(
    object = list_of_topline[[4]],
    class = c("flextable")
  )
  expect_s3_class(
    object = list_of_topline[[5]],
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
  expect_s3_class(
    object = list_of_xtab[[4]],
    class = c("flextable")
  )
  expect_s3_class(
    object = list_of_xtab[[5]],
    class = c("flextable")
  )
  expect_s3_class(
    object = list_of_xtab[[6]],
    class = c("flextable")
  )
  expect_s3_class(
    object = list_of_xtab[[7]],
    class = c("flextable")
  )
  expect_s3_class(
    object = list_of_xtab[[8]],
    class = c("flextable")
  )
  expect_s3_class(
    object = list_of_xtab[[9]],
    class = c("flextable")
  )
  expect_s3_class(
    object = list_of_xtab[[10]],
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
  expect_s3_class(
    object = list_of_xtab_3way[[7]],
    class = c("flextable")
  )
  expect_s3_class(
    object = list_of_xtab_3way[[8]],
    class = c("flextable")
  )
  expect_s3_class(
    object = list_of_xtab_3way[[9]],
    class = c("flextable")
  )
  expect_s3_class(
    object = list_of_xtab_3way[[10]],
    class = c("flextable")
  )
})
