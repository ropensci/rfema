
test_that("returned api url is correctly specified", {
  # skip if no connection can be established
  # skip_if_offline(host = "www.fema.gov")

  vcr::use_cassette("url", {
    url <- gen_api_query(
      data_set = "IndividualAssistanceHousingRegistrantsLargeDisasters",
      top_n = 100, select = c("disasterNumber", "waterLevel"),
      filters = list(disasterNumber = "<= 4000")
    )
  })

  # returned object is a character
  expect_equal(is.character(url), T)

  # returned string has the top_n component specified
  expect_equal(grepl("top=100", url), T)

  # returned string has the select arguments in it
  expect_equal(grepl("disasterNumber,waterLevel", url), T)

  # returned string has the filter arguments in it
  expect_equal(grepl("filter", url), T)
  expect_equal(grepl("4000", url), T)
})
