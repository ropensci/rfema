
# get all data sets from the API so that all the data sets can be tested 
# automatically with a loop
data_sets <- fema_data_sets()


test_that("uncapitalized data set name gets corrected to the FEMA consistent capitalization",{
  expect_match(valid_dataset("fimanfipclaims"), "FimaNfipClaims")
  expect_match(valid_dataset("FIMANFIPCLAIMS"), "FimaNfipClaims")
  expect_match(valid_dataset("fImAnfIPCLaiMs"), "FimaNfipClaims")
  
  # loop over all data set names and perform the same test
  for(data_set in data_sets$name){
    expect_match(valid_dataset(tolower(data_set)), data_set)
  }
  
})

test_that("unrecognized data set name returns an error",{
  expect_error(valid_dataset("asdadsf")) 
  expect_error(valid_dataset(fimaNfipClaims),"object 'fimaNfipClaims' not found") 
  expect_error(valid_dataset(NA),"The data_set argument needs to be a character. Try putting the data set name in quotes.") 
})