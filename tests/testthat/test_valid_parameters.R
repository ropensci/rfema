
# get all data sets to test multiple automatically through a loop
data_sets <- fema_data_sets()

# loop over some data sets (this test takes a while so limiting a random data sets)
for (data_set in data_sets$name[c(1, 3, 8, 15, 20)]) {
  print(data_set)
  returned_obj <- valid_parameters(data_set)
  
  test_that(paste0("check returned object is a character vector:", data_set), {
    expect_equal( is.character(returned_obj), TRUE)
  })
  
  test_that(paste0("check returned object is a vector:", data_set), {
    expect_equal(is.vector(returned_obj), TRUE)
  })
  
  test_that(paste0("check returned object has length of at least 1:", data_set), {
    expect_equal(length(returned_obj) > 1, TRUE)
  })
}


