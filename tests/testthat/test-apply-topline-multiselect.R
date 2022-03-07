# Test data ---------------------------------------------------------------

df <- readr::read_rds(test_path("testdata_multiselect.rds"))
patterns <- c("no_vote", "civic_engagement", "media", "activism")
list_df <- split_df(df, patterns, "weightvec")
captions <- list("caption", c("caption1", "caption2"), "caption", c("caption1", "caption2"))
parents <- rep(c(FALSE, TRUE), 2)

# Errors ------------------------------------------------------------------

test_that("apply_topline_multiselect() returns meaningful errors", {
  # Invalid list of data.tables
  expect_snapshot(
    x = apply_topline_multiselect(
      list_df = list(list_df[[1]], 3),
      weight = "weightvec",
      caption = captions,
      parent = parents
    ),
    error = TRUE
  )
  # Invalid input for weight (wrong type)
  expect_snapshot(
    x = apply_topline_multiselect(
      list_df = list_df,
      weight = 3,
      caption = captions,
      parent = parents
    ),
    error = TRUE
  )
  # Invalid input for caption
  expect_snapshot(
    x = apply_topline_multiselect(
      list_df = list_df,
      weight = "weightvec",
      caption = 3,
      parent = parents
    ),
    error = TRUE
  )
  # Invalid input for parent
  expect_snapshot(
    x = apply_topline_multiselect(
      list_df = list_df,
      weight = "weightvec",
      caption = captions,
      parent = c("wrong_type", "not_boolean")
    ),
    error = TRUE
  )
})

# Functionality -----------------------------------------------------------

test_that("Does apply_topline_multiselect() return correct output type and class", {
  # Test data
  results <- apply_topline_multiselect(
    list_df = list_df,
    weight = "weightvec",
    caption = captions,
    parent = parents
  )
  # Base type (container)
  expect_vector(
    object = results,
    ptype = list(),
    size = 2
  )
  # First element should be 'no vote', a single list
  expect_vector(
    object = results[["result"]][["no_vote"]],
    ptype = list(),
    size = 1
  )
  # Check class of 'no vote', should be a flextable
  expect_s3_class(
    object = results[["result"]][["no_vote"]][[1]],
    class = "flextable",
    exact = TRUE
  )
  # Second element should be 'civic engagement', a double list
  expect_vector(
    object = results[["result"]][["civic_engagement"]],
    ptype = list(),
    size = 2
  )
  # Check classes of 'civic engagement', should be flextables
  expect_s3_class(
    object = results[["result"]][["civic_engagement"]][[1]],
    class = "flextable",
    exact = TRUE
  )
  expect_s3_class(
    object = results[["result"]][["civic_engagement"]][[2]],
    class = "flextable",
    exact = TRUE
  )
  # Third element should be 'media', a single list
  expect_vector(
    object = results[["result"]][["media"]],
    ptype = list(),
    size = 1
  )
  # Check class of 'media', should be a flextable
  expect_s3_class(
    object = results[["result"]][["media"]][[1]],
    class = "flextable",
    exact = TRUE
  )
  # Second element should be 'activism', a double list
  expect_vector(
    object = results[["result"]][["activism"]],
    ptype = list(),
    size = 2
  )
  # Check classes of 'activism', should be flextables
  expect_s3_class(
    object = results[["result"]][["activism"]][[1]],
    class = "flextable",
    exact = TRUE
  )
  expect_s3_class(
    object = results[["result"]][["activism"]][[2]],
    class = "flextable",
    exact = TRUE
  )
})

# Tests for caption generation function -----------------------------------

# Errors ------------------------------------------------------------------

test_that("Test that topline_caption_multiselect() return helpful errors", {
  # Invalid input for patterns (numeric)
  expect_snapshot(
    x = topline_caption_multiselect(
      patterns = c(1, 2, 3, 4),
      parent = parents
    ),
    error = TRUE
  )
  # Invalid input for parent (character)
  expect_snapshot(
    x = topline_caption_multiselect(
      patterns = patterns,
      parent = c("TRUE", "FALSE", "TRUE", "TRUE")
    ),
    error = TRUE
  )
  # Invalid lenghs
  expect_snapshot(
    x = topline_caption_multiselect(
      patterns = patterns,
      parent = c(parents, TRUE)
    ),
    error = TRUE
  )
})

# Functionality -----------------------------------------------------------

test_that("Test that topline_caption_multiselect() return correct output", {
  # Test data (all have parents)
  captions_parents <- topline_caption_multiselect(
    patterns = patterns[c(2, 4)],
    parent = parents[c(2, 4)]
  )
  # Test data (Some terms have parents)
  captions <- topline_caption_multiselect(
    patterns = patterns,
    parent = parents
  )
  # Test data (No parents)
  captions_no_parents <- topline_caption_multiselect(
    patterns = patterns[c(1, 3)],
    parent = parents[c(1, 3)]
  )

  # Expect list objects
  expect_vector(
    object = captions_parents,
    ptype = list(),
    size = 2
  )
  expect_vector(
    object = captions,
    ptype = list(),
    size = 4
  )
  expect_vector(
    object = captions_no_parents,
    ptype = list(),
    size = 2
  )

  # Snapshots
  expect_snapshot_output(
    x = captions_parents,
    cran = FALSE,
    variant = "captions_output_parents"
  )
  expect_snapshot_output(
    x = captions,
    cran = FALSE,
    variant = "captions_output_mixed"
  )
  expect_snapshot_output(
    x = captions_no_parents,
    cran = FALSE,
    variant = "captions_output_no_parents"
  )
})
