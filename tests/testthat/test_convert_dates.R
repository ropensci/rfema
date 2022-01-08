
test_that("check to insure date column is a POSIXct object", {

  # a sample data frame
  df <- data.frame("date" = c("2021-01-02", "1995-10-01", "2010-06-05"), "something_else" = c(1, 2, 3))

  # data frame passed through convert_dates()
  converted_df <- convert_dates(df)

  # dates column is converted
  expect_true(inherits(converted_df$date, "POSIXct"))

  # something else column is not converted
  expect_true(inherits(converted_df$something_else, "POSIXct") == F)
})
