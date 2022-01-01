
test_that("returned object is a character", {
  skip_if_offline(host = "www.fema.gov")
  
  vcr::use_cassette("time_iterations1", {
    # returned object
    obj <- time_iterations(data_set = "fimanfipclaims", iterations = 100)
  })
  
  expect_true(is.character(obj))
  

})


  
