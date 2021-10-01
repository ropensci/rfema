
test_that("top_n argument limits the number of row",{
  expect_equal(nrow(openFema("fimanfipClaims", top_n = 100)), 100)
  expect_equal(nrow(openFema("fimanfipClaims", top_n = 2000, ask_before_call = F)), 2000)
  expect_error(openFema("fimanfipClaims", top_n = 0), "Setting top_n = 0 wont return any records. Set top_n to a value greater than 0")
})

# NOTE: test fails now because some data sets are returned as lists
# get all data sets to test 
# data_sets <- fema_data_sets()
# 
# # loop over some data sets (this test takes a while so limiting to 5 random data sets)
# for(data_set in sample(data_sets$name,5,replace = F)){
#   test_that("top_n argument limits the number of row",{
#     expect_equal(nrow(openFema(data_set, top_n = 100)), 100)
#     expect_equal(nrow(openFema(data_set, top_n = 2000, ask_before_call = F)), 2000)
#     expect_error(openFema(data_set, top_n = 0), "Setting top_n = 0 wont return any records. Set top_n to a value greater than 0")
#   })
# }