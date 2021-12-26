# Test data ---------------------------------------------------------------

df <- readr::read_rds(test_path("testdata_multiselect.rds"))
patterns <- c("no_vote", "civic_engagement", "media", "activism")
list_df <- split_df(df, patterns, "weightvec")

no_vote <- generate_topline_multiselect(
  df = list_df[[1]],
  weight = "weightvec",
  caption = "caption",
  parent = FALSE
)

civic <- generate_topline_multiselect(
  df = list_df[[2]],
  weight = "weightvec",
  caption = "caption",
  parent = TRUE
)

media <- generate_topline_multiselect(
  df = list_df[[3]],
  weight = "weightvec",
  caption = "caption",
  parent = FALSE
)

activism <- generate_topline_multiselect(
  df = list_df[[4]],
  weight = "weightvec",
  caption = "caption",
  parent = TRUE
)

# Errors ------------------------------------------------------------------

test_that("generate_topline_multiselect() returns helpful errors", {
  # Wrong type for df
  expect_snapshot(
    x = generate_topline_multiselect(
      df = c(3, 4),
      weight = "weightvec",
      caption = "caption",
      parent = TRUE
    ),
    error = TRUE
  )
  expect_snapshot(
    x = generate_topline_multiselect(
      df = c(3, 4),
      weight = "weightvec",
      caption = "caption",
      parent = FALSE
    ),
    error = TRUE
  )
  # Wrong type for weight
  expect_snapshot(
    x = generate_topline_multiselect(
      df = list_df[[1]],
      weight = 3,
      caption = "caption",
      parent = FALSE
    ),
    error = TRUE
  )
  expect_snapshot(
    x = generate_topline_multiselect(
      df = list_df[[1]],
      weight = 3,
      caption = "caption",
      parent = TRUE
    ),
    error = TRUE
  )
})

# Functionality -----------------------------------------------------------

test_that("generate_topline_multiselect() returns correct output and class", {
  # Correct base type (list)
  # No vote
  expect_type(
    object = no_vote,
    type = "list"
  )
  # Civic engagement
  expect_type(
    object = civic,
    type = "list"
  )
  # Correct class
  # No vote
  expect_s3_class(
    object = no_vote[[1]],
    class = "flextable",
    exact = TRUE
  )
  # Civic
  expect_s3_class(
    object = civic[[1]],
    class = "flextable",
    exact = TRUE
  )
  expect_s3_class(
    object = civic[[2]],
    class = "flextable",
    exact = TRUE
  )
  # Media
  expect_s3_class(
    object = media[[1]],
    class = "flextable",
    exact = TRUE
  )
  # Activism
  expect_s3_class(
    object = activism[[1]],
    class = "flextable",
    exact = TRUE
  )
  expect_s3_class(
    object = activism[[2]],
    class = "flextable",
    exact = TRUE
  )
})

test_that("generate_topline_multiselect() returns correct number of elements based on 'parent'", {
  # Correct length for single toplines (no parents)
  expect_vector(
    object = no_vote,
    ptype = list(),
    size = 1
  )
  expect_vector(
    object = media,
    ptype = list(),
    size = 1
  )
  expect_vector(
    object = civic,
    ptype = list(),
    size = 2
  )
  expect_vector(
    object = activism,
    ptype = list(),
    size = 2
  )
})
