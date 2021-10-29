

test_that("Error is returned when data field is not in the data set", {
  expect_error(parameter_values(data_set = "fimanfipclaims", data_field = "asdfasdf"))
})


# get all data sets to test multiple automatically through a loop
data_sets <- fema_data_sets()

# loop over some data sets (this test takes a while so limiting a rew random data sets)
for (data_set in data_sets$name[c(1, 3, 4, 7, 19)]) {
  print(data_set)
  test_that(paste0("check returned object is a character vector of dimensions 1 x N for data set:", data_set), {
      returned_obj <- parameter_values(data_set, valid_parameters(data_set)[1])
    expect_equal(is.vector(returned_obj), TRUE)
  })
}
