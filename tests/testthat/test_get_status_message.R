test_that("message is correct", {
  message <- get_status_message(10,10,10,"2 minutes")
  expect_match(message, "10 matching records found. At 1000 records per call, it will take 10 individual API calls to get the top 10 matching records. It's estimated that this will take approximately 2 minutes. Continue?")
  
  message <- get_status_message(5000, 5, NULL, "5 hours")
  expect_match(message, "5000 matching records found. At 1000 records per call, it will take 5 individual API calls to get all matching records. It's estimated that this will take approximately 5 hours. Continue?")

  message <- get_status_message(2000, 2, 5000, "5 hours")
  expect_match(message, "2000 matching records found. At 1000 records per call, it will take 2 individual API calls to get all matching records. It's estimated that this will take approximately 5 hours. Continue?")
  
})




