

test_that("Error is returned when data field is not in the data set", {
  vcr::use_cassette("non_existing_dataset", {
  expect_error(parameter_values(data_set = "fimanfipclaims", data_field = "asdfasdf"))
  })
})

test_that(paste0("returned object is a character vector of dimensions 1 x N"), {
  vcr::use_cassette("parameter_value", {
    returned_obj <- parameter_values("fimanfipclaims", "floodZone")
  })
  expect_equal(is.vector(returned_obj), TRUE)
})

