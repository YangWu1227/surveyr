# Test data ---------------------------------------------------------------

df <- readr::read_rds(test_path("testdata_multiselect.rds"))
patterns <- c("no_vote", "civic_engagement", "media", "activism")

# Errors ------------------------------------------------------------------

test_that("check_patterns() return meaningful error messages", {
  # Invalid input (non-character vectors)
  expect_snapshot(
    x = check_patterns(c(3, 4), patterns),
    error = TRUE
  )
  # Missing argument
  expect_snapshot(
    x = check_patterns(patterns),
    error = TRUE
  )
})

# Functionality -----------------------------------------------------------

test_that("The function returns correct base type and snapshot", {
  # Right base type?
  expect_type(
    object = check_patterns(names(df), patterns),
    type = "logical"
  )
  # Right value?
  expect_equal(
    object = check_patterns(names(df), patterns),
    expected = rep(TRUE, length(patterns))
  )
  expect_equal(
    object = check_patterns(c("matched_extra", "unmatched_extra", "special"), c("matched_", "3", "sp")),
    expected = c(TRUE, FALSE, TRUE)
  )
})
