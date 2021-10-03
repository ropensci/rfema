
# get all data sets from the API so that all the data sets can be tested 
# automatically with a loop
data_sets <- fema_data_sets()


test_that("uncapitalized data set name gets corrected to the FEMA consistent capitalization",{
  expect_match(valid_dataset("fimanfipclaims"), "FimaNfipClaims")
  expect_match(valid_dataset("FIMANFIPCLAIMS"), "FimaNfipClaims")
  expect_match(valid_dataset("fImAnfIPCLaiMs"), "FimaNfipClaims")
})

test_that("unrecognized data set name returns an error",{
  expect_error(valid_dataset("asdadsf")) 
  expect_error(valid_dataset(fimaNfipClaims),"object 'fimaNfipClaims' not found") 
})