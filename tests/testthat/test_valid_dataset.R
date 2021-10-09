
data_sets <- fema_data_sets()

# loop over all data set names and perform the same tests
for (data_set in data_sets$name) {
  
  returned_obj <- valid_dataset(data_set = data_set)
  
  test_that("returned object is a character", {
    expect_equal(is.character(returned_obj), T)
  })
  
  test_that("characters of input and output match", {
    expect_match(tolower(returned_obj), tolower(data_set) )
  })
}
