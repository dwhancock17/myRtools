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
  expect_warning(
    manage_packages("nonexistentpackage12345", quiet = TRUE)
  )
})

test_that("quick_summary works with data frames", {
  expect_output(quick_summary(mtcars, show_str = FALSE), "Rows: 32")
  expect_output(quick_summary(iris, show_str = FALSE), "Columns: 5")
})

test_that("make_desc_or_table returns a gtsummary object", {

  skip_if_not_installed("broom.helpers")

  dat <- data.frame(
    refusal = factor(
      c("Transported", "Refused Care", "Transported", "Refused Care"),
      levels = c("Transported", "Refused Care")
    ),
    age = c(70, 82, 76, 90),
    gender = factor(c("Male", "Female", "Male", "Female"))
  )

  tbl <- make_desc_or_table(
    data = dat,
    outcome = refusal,
    predictors = c("age", "gender")
  )

  expect_s3_class(tbl, "gtsummary")
})


test_that("make_desc_or_table supports OR subsampling", {

  set.seed(1)

  dat <- data.frame(
    refusal = factor(
      sample(c("Transported", "Refused Care"), 1000, replace = TRUE, prob = c(0.9, 0.1)),
      levels = c("Transported", "Refused Care")
    ),
    age = rnorm(1000, 75, 8),
    injury = factor(sample(c("Yes", "No"), 1000, replace = TRUE))
  )

  expect_message(
    tbl <- make_desc_or_table(
      data = dat,
      outcome = refusal,
      predictors = c("age", "injury"),
      or_sample_n = 200,
      seed = 123
    ),
    "Univariate ORs estimated on random subsample"
  )

  expect_s3_class(tbl, "gtsummary")
})


test_that("save_gtsummary rejects non-gtsummary input", {
  expect_error(
    save_gtsummary(mtcars, "test.html"),
    "gtsummary"
  )
})

test_that("compare_uv_or_subsamples returns expected structure", {

  skip_if_not_installed("broom.helpers")
  
  set.seed(123)

  dat <- data.frame(
    refusal = factor(
      sample(c("Transported", "Refused Care"), 2000, replace = TRUE, prob = c(0.9, 0.1)),
      levels = c("Transported", "Refused Care")
    ),
    age = rnorm(2000, 75, 7),
    gender = factor(sample(c("Male", "Female"), 2000, replace = TRUE))
  )

  res <- compare_uv_or_subsamples(
    data = dat,
    outcome = refusal,
    predictors = c("age", "gender"),
    sample_n = 500,
    seed = 42
  )

  expect_s3_class(res, "data.frame")

  expect_true(all(c(
    "estimate_s1", "conf.low_s1", "conf.high_s1",
    "estimate_s2", "conf.low_s2", "conf.high_s2"
  ) %in% names(res)))
})


test_that("compare_uv_or_subsamples errors if sample_n too large", {

  dat <- data.frame(
    refusal = factor(c("Transported", "Refused Care")),
    age = c(70, 80)
  )

  expect_error(
    compare_uv_or_subsamples(
      data = dat,
      outcome = refusal,
      predictors = "age",
      sample_n = 10
    ),
    "sample_n must be smaller"
  )
})
