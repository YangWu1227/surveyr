# Test data ---------------------------------------------------------------

df <- readr::read_rds(test_path("testdata_multiselect.rds"))
patterns <- c("no_vote", "civic_engagement", "media", "activism")
list_df <- split_df(df, patterns, "weightvec")
captions <- list("caption", c("caption1", "caption2"), "caption", c("caption1", "caption2"))
parents <- rep(c(FALSE, TRUE), 2)
results <- apply_topline_multiselect(
  list_df = list_df,
  weight = "weightvec",
  caption = captions,
  parent = parents
)

# Errors ------------------------------------------------------------------

test_that("combine_topline_multiselect() provides meaningful error messages", {
  # Invalid input for 'l' (wrong type)
  expect_snapshot(
    x = combine_topline_multiselect(c(3, 5, 6)),
    error = TRUE
  )
  # Invalid input for 'l' (right type but incorrect list, i.e., no 'result' and 'error)
  expect_snapshot(
    x = combine_topline_multiselect(list("test" = c(3, 4), "error" = ("test"))),
    error = TRUE
  )
})

# Functionality -----------------------------------------------------------

test_that("Does combine_topline_multiselect() return correct output type and class", {
  # Test data
  list_toplines <- combine_topline_multiselect(results)
  # Correct base type and size?
  expect_vector(
    object = list_toplines,
    ptype = list(),
    size = length(list_toplines)
  )
  # Class of all elements should be 'flextable'
  expect_s3_class(
    object = list_toplines[[1]],
    class = "flextable",
    exact = TRUE
  )
  expect_s3_class(
    object = list_toplines[[2]],
    class = "flextable",
    exact = TRUE
  )
  expect_s3_class(
    object = list_toplines[[3]],
    class = "flextable",
    exact = TRUE
  )
  expect_s3_class(
    object = list_toplines[[4]],
    class = "flextable",
    exact = TRUE
  )
})
