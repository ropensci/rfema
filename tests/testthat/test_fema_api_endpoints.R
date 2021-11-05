test_that("returned object is a character", {
  vcr::use_cassette("api_endpoint", {
    returned_obj <- fema_api_endpoints("fimanfipclaims")
  })
  expect_equal(is.character(returned_obj), T)
})


test_that("first part of returned character matches the fema API url", {
  vcr::use_cassette("api_endpoint", {
    returned_obj <- fema_api_endpoints("fimanfipclaims")
  })
  expect_equal(substr(returned_obj, 1, 24), "https://www.fema.gov/api")
})
