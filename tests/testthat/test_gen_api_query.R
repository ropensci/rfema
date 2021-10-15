url <- gen_api_query(data_set = "IndividualAssistanceHousingRegistrantsLargeDisasters",
              top_n = 100, select = c("disasterNumber","waterLevel"),
              filters = list(disasterNumber = "<= 4000"))


test_that("returned url is a character", {
  expect_equal(is.character(url),T)
})

test_that("returned url contains the top n argument", {
   expect_equal(grepl("top=100",url),T)
})

test_that("returned url contains the selected columns", {
   expect_equal(grepl("disasterNumber,waterLevel",url),T)
})

test_that("returned url contains the components of the filter", {
   expect_equal(grepl("filter",url),T)
   expect_equal(grepl("4000",url),T)
})





