
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



# test save to file functionality for csv files

# download file 
ds <- "femaregions" # using femaregions because it is a small file
openFema(data_set = ds, file_type = "csv")
openFema(data_set = ds, file_type = "rds")

# get name of csv files/rds files in wd
csv_file <- list.files(getwd(), pattern = ".csv")
rds_file <- list.files(getwd(), pattern = ".rds")


# check to see if file is in the folder
test_that("downloaded file is in the specified location with correct name", {
  expect_equal( grepl(paste0(ds, "_", Sys.Date()), csv_file), T)
  expect_equal( grepl(paste0(ds, "_", Sys.Date()), rds_file), T)
})

# remove file so directory doesn't get cluttered
file.remove(csv_file)
file.remove(rds_file)


