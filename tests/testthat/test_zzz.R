test_that("package functions are memoised", {
  expect_true(memoise::is.memoised(open_fema))
  expect_true(memoise::is.memoised(fema_data_fields))
  expect_true(memoise::is.memoised(fema_data_sets))
  expect_true(memoise::is.memoised(valid_dataset))
  expect_true(memoise::is.memoised(gen_api_query))
  expect_true(memoise::is.memoised(fema_api_endpoints))
  expect_true(memoise::is.memoised(parameter_values))
})
