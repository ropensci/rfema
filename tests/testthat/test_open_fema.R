
test_that("top_n argument limits the number of row", {
    expect_equal(nrow(open_fema("fimanfipClaims", top_n = 100)), 100)
    expect_equal(nrow(open_fema("fimanfipClaims", top_n = 2000, ask_before_call = F)), 2000)
    expect_error(open_fema("fimanfipClaims", top_n = 0), "Setting top_n = 0 wont return any records. Set top_n to a value greater than 0")
})

# get all data sets to test multiple automatically through a loop
data_sets <- fema_data_sets()

# loop over some data sets (this test takes a while so limiting a random data sets)
for (data_set in data_sets$name[c(1, 4, 6, 12, 16)]) {
  test_that(paste0("top_n argument limits the number of row for ", data_set), {
    expect_equal((nrow(open_fema(data_set, top_n = 100)) <= 100), TRUE)
    expect_equal((nrow(open_fema(data_set, top_n = 2000, ask_before_call = F)) <= 2000), TRUE)
    expect_error(open_fema(data_set, top_n = 0), "Setting top_n = 0 wont return any records. Set top_n to a value greater than 0")
  })
}


# test that filters actually fiter the API call
test_that("filters limit the value of the respective column", {
  df <- open_fema(data_set = "fimanfipclaims", top_n = 100, filters = list(state = "VA", yearOfLoss = "< 2015"))
  expect_match(unique(as.character(df$state)), "VA")
  expect_equal(max(as.numeric(as.character(df$yearOfLoss))) < 2015, T)
})

# test that select arguments work property
test_that("select limits the columns returned", {
  df <- open_fema(data_set = "fimanfipclaims", top_n = 1000, select = c("state", "yearOfLoss"))
  expect_equal(F %in% (colnames(df) %in% c("state", "yearOfLoss", "id")), F)
})

# test save to file functionality for csv files
# download file
ds <- "femaregions" # using femaregions because it is a small file
open_fema(data_set = ds, file_type = "csv")
open_fema(data_set = ds, file_type = "rds")

# get name of csv files/rds files in wd
csv_file <- list.files(getwd(), pattern = ".csv")
rds_file <- list.files(getwd(), pattern = ".rds")


# check to see if file is in the folder
test_that("downloaded file is in the specified location with correct name", {
  expect_equal(paste0(ds, ".csv"), csv_file)
  expect_equal(paste0(ds, ".rds"), rds_file)
})

# remove file so directory doesn't get cluttered
file.remove(csv_file)
file.remove(rds_file)
