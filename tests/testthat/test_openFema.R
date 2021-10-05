
test_that("top_n argument limits the number of row", {
  expect_equal(nrow(openFema("fimanfipClaims", top_n = 100)), 100)
  expect_equal(nrow(openFema("fimanfipClaims", top_n = 2000, ask_before_call = F)), 2000)
  expect_error(openFema("fimanfipClaims", top_n = 0), "Setting top_n = 0 wont return any records. Set top_n to a value greater than 0")
})

# get all data sets to test multiple automatically through a loop
data_sets <- fema_data_sets()

# loop over some data sets (this test takes a while so limiting a random data sets)
for (data_set in data_sets$name[c(1, 4, 6, 12, 16)]) {
  test_that(paste0("top_n argument limits the number of row for ", data_set), {
    expect_equal((nrow(openFema(data_set, top_n = 100)) <= 100), TRUE)
    expect_equal((nrow(openFema(data_set, top_n = 2000, ask_before_call = F)) <= 2000), TRUE)
    expect_error(openFema(data_set, top_n = 0), "Setting top_n = 0 wont return any records. Set top_n to a value greater than 0")
  })
}
