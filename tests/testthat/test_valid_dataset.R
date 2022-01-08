
test_that("returned object is a character", {
  vcr::use_cassette("valid_dataset", {
    returned_obj <- valid_dataset(data_set = "fimanfipclaims")
  })
  expect_equal(is.character(returned_obj), T)
})

test_that("characters of input and output match", {
  vcr::use_cassette("valid_dataset", {
    returned_obj <- valid_dataset(data_set = "fimanfipclaims")
  })
  expect_match(tolower(returned_obj), tolower("fimanfipclaims"))
})


test_that("error is returned when invalid data set argument is used", {
  err <- expect_error(valid_dataset(data_set = "asdfasdfa"))
  expect_true(grepl("is not a valid data set", err$message))
})
