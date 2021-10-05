# get all data sets from the API so that all the data sets can be tested
# automatically with a loop
data_sets <- fema_data_sets()

# loop over all data set names and perform the same tests
for (data_set in data_sets$name) {
  test_that("returned object is a character", {
    expect_equal(is.character(fema_api_endpoints(data_set)), T)
  })


  test_that("first part of returned character matches the fema API url", {
    expect_equal(substr(fema_api_endpoints(data_set), 1, 24), "https://www.fema.gov/api")
  })
}
