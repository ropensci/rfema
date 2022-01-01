

test_that("Error is returned when data field is not in the data set", {
  vcr::use_cassette("non_existing_dataset", {
    expect_error(parameter_values(data_set = "fimanfipclaims", data_field = "asdfasdf"))
  })
})

test_that(paste0("returned object is a tibble of dimension 1 x N"), {
  vcr::use_cassette("parameter_value", {
    returned_obj <- parameter_values("fimanfipclaims", "floodZone", message = FALSE)
  })
  expect_equal(tibble::is_tibble(returned_obj), TRUE) # is a tibble
  expect_equal(ncol(returned_obj) > 1,  TRUE) # has a single row
  expect_equal(nrow(returned_obj) , 1) # has multiple columns
})

test_that(paste0("returned object is NULL when message argument is TRUE"), {
  vcr::use_cassette("parameter_value2", {
    returned_obj <- parameter_values("fimanfipclaims", "floodZone", message = TRUE)
  })
  expect_equal(returned_obj, NULL) 
})


