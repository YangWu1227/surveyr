x <- runif(1000000, 0.0000001, 1.99999999)

test_that("sumcpp() should return the same output as base sum()", {
  expect_equal(
    object = sumcpp(x),
    expected = sum(x)
  )
})
