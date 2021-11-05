
test_that("top_n argument limits the number of row", {
  vcr::use_cassette("top_n_100", {
    obj <- open_fema("fimanfipClaims", top_n = 100)
  })
  expect_equal(nrow(obj), 100)

  vcr::use_cassette("top_n_2000", {
    obj <- open_fema("fimanfipClaims", top_n = 2000, ask_before_call = F)
  })
  expect_equal(nrow(obj), 2000)

  expect_error(open_fema("fimanfipClaims", top_n = 0), "Setting top_n = 0 wont return any records. Set top_n to a value greater than 0")
})


# test that filters actually fiter the API call
test_that("filters limit the value of the respective column", {
  vcr::use_cassette("filters_work", {
    df <- open_fema(data_set = "fimanfipclaims", top_n = 100, filters = list(state = "VA", yearOfLoss = "< 2015"))
  })
  expect_match(unique(as.character(df$state)), "VA")
  expect_equal(max(as.numeric(as.character(df$yearOfLoss))) < 2015, T)
})

# test that select arguments work property
test_that("select limits the columns returned", {
  vcr::use_cassette("select_works", {
    df <- open_fema(data_set = "fimanfipclaims", top_n = 1000, select = c("state", "yearOfLoss"))
  })
  expect_equal(F %in% (colnames(df) %in% c("state", "yearOfLoss", "id")), F)
})


# check to see if file is in the folder
test_that("downloaded file is in the specified location with correct name", {
  skip_if_offline(host = "www.fema.gov")
  # test save to file functionality for csv files
  # download file
  ds <- "femaregions" # using femaregions because it is a small file
  open_fema(data_set = ds, file_type = "csv")
  open_fema(data_set = ds, file_type = "rds")

  # get name of csv files/rds files in wd
  csv_file <- list.files(getwd(), pattern = ".csv")
  rds_file <- list.files(getwd(), pattern = ".rds")

  expect_equal(paste0(ds, ".csv"), csv_file)
  expect_equal(paste0(ds, ".rds"), rds_file)

  # remove file so directory doesn't get cluttered
  file.remove(csv_file)
  file.remove(rds_file)
})
