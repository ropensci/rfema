
# loop over some data sets (this test takes a while so limiting a random data sets)
data_set <- "FemaWebDeclarationAreas"

test_that(paste0("check returned object is in the right format:", data_set), {
  vcr::use_cassette("valid_parameters", {
    returned_obj <- valid_parameters(data_set)
  })

  # returned object is a tibble
  expect_equal(tibble::is_tibble(returned_obj), TRUE)

  # returned object has more than one row
  expect_equal(nrow(returned_obj) > 1, TRUE)
})
