
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
