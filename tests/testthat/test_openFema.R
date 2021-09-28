
test_that("top_n argument limits the number of row",{
  expect_equal(nrow(openFema("fimanfipClaims", top_n = 100)), 100)
  expect_equal(nrow(openFema("fimanfipClaims", top_n = 2000, ask_before_call = F)), 2000)
  expect_error(openFema("fimanfipClaims", top_n = 0), "Setting top_n = 0 wont return any records. Set top_n to a value greater than 0")
  
})