
# loop over some data sets (this test takes a while so limiting a random data sets)
data_set <- "FemaWebDeclarationAreas"

test_that(paste0("check returned object is in the right format:", data_set), {
  vcr::use_cassette("valid_parameters", {
    returned_obj <- valid_parameters(data_set)
  })

  # returned object is a character
  expect_equal(is.character(returned_obj), TRUE)

  # returned object is a vector
  expect_equal(is.vector(returned_obj), TRUE)

  # returned object has length greater than 1
  expect_equal(length(returned_obj) > 1, TRUE)
})
