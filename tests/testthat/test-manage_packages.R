#| eval: false

test_that("manage_packages works with valid packages", {
  # Test with a package that should always be available
  result <- manage_packages("base", quiet = TRUE)
  
  expect_type(result, "list")
  expect_equal(result$total, 1)
  expect_equal(result$success_rate, 1)
  expect_length(result$failed_installs, 0)
  expect_length(result$load_failures, 0)
})

test_that("manage_packages handles invalid packages gracefully", {
  # Test with a non-existent package - but skip if internet issues
  skip_if_offline()
  
  # Test that the function doesn't crash with invalid packages
  expect_no_error({
    result <- manage_packages("nonexistentpackage12345", quiet = TRUE)
  })
})

test_that("quick_summary works with data frames", {
  expect_output(quick_summary(mtcars, show_str = FALSE), "Rows: 32")
  expect_output(quick_summary(iris, show_str = FALSE), "Columns: 5")
})
